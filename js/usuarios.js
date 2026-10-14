(function (global) {
  "use strict";

  const API = global.GAUD_API;

global.GAUD_DATA = global.GAUD_DATA || {
    usuario: null,
    pensum: [],
    dashboard: null,
    catalogo: null
};

  let sesionPromise = null;

  function iniciales(nombre) {
    const partes = String(nombre || "").trim().split(/\s+/).filter(Boolean);
    if (!partes.length) return "?";
    return partes.slice(0, 2).map(function (p) { return p[0].toUpperCase(); }).join("");
  }

  function ordinal(n) {
    const num = Number(n);
    if (!Number.isFinite(num)) return "";
    const mapa = {
      1: "1er", 2: "2do", 3: "3er", 4: "4to", 5: "5to", 6: "6to",
      7: "7mo", 8: "8vo", 9: "9no", 10: "10mo", 11: "11vo", 12: "12vo",
      13: "13er", 14: "14to", 15: "15to", 16: "16to"
    };
    return mapa[num] || num + "º";
  }

  function periodoDelUsuario(u) {
    if (!u) return { nombre: "—", rango: "—", anio: new Date().getFullYear() };
    const num = Number(u.trimestre_actual) || 1;
    return {
      nombre: ordinal(num) + " Trimestre",
      rango: "—",
      anio: new Date().getFullYear()
    };
  }

  function emitirSesion(sesion) {
    global.GAUD_DATA.usuario = sesion ? sesion.usuario : null;
    document.dispatchEvent(new CustomEvent("gaud:sesion", {
      detail: { sesion: sesion }
    }));
  }

  function obtenerSesion() {
    return API.get("/auth.php").then(function (usuario) {
      return { id: usuario.id, usuario: usuario };
    }).catch(function (err) {
      if (err.status === 401) return null;
      throw err;
    });
  }

  function cargarSesion() {
    if (!sesionPromise) {
      sesionPromise = obtenerSesion().then(function (sesion) {
        emitirSesion(sesion);
        return sesion;
      }).catch(function (err) {
        sesionPromise = null;
        throw err;
      });
    }
    return sesionPromise;
  }

  function autenticar(email, password) {
    return API.post("/auth.php", { email: email, password: password }).then(function (usuario) {
      sesionPromise = null;
      emitirSesion({ id: usuario.id, usuario: usuario });
      return usuario;
    });
  }

  function cerrarSesion() {
    sesionPromise = null;
    return API.post("/auth.php?action=logout").then(function () {
      emitirSesion(null);
    }).catch(function () {
      emitirSesion(null);
    });
  }

  function crearUsuario(datos) {
    return API.post("/usuarios.php", datos).then(function (usuario) {
      sesionPromise = null;
      emitirSesion({ id: usuario.id, usuario: usuario });
      return usuario;
    });
  }

  function obtenerUsuario() {
    return API.get("/usuarios.php").then(function (usuario) {
      const actual = global.GAUD_DATA.usuario;
      if (!actual || actual.id === usuario.id) {
        sesionPromise = null;
        emitirSesion({ id: usuario.id, usuario: usuario });
      }
      return usuario;
    });
  }

  function obtenerCatalogo() {
    const actual = global.GAUD_DATA.catalogo;
    if (actual) return Promise.resolve(actual);
    return API.get("/catalogo.php").then(function (cat) {
      global.GAUD_DATA.catalogo = cat;
      return cat;
    });
  }

  function actualizarUsuario(cambios) {
    return API.put("/usuarios.php", cambios).then(function () {
      return obtenerUsuario();
    });
  }

  function cambiarPassword(password_actual, password_nueva, password_confirmar) {
    return API.put("/usuarios.php?action=password", {
      password_actual: password_actual,
      password_nueva: password_nueva,
      password_confirmar: password_confirmar
    }).then(function (resultado) {
      if (resultado && resultado.id) {
        const actual = global.GAUD_DATA.usuario;
        if (!actual || actual.id === resultado.id) {
          sesionPromise = null;
          emitirSesion({ id: resultado.id, usuario: resultado });
        }
      }
      return resultado;
    });
  }

  function eliminarCuenta() {
    return API.del("/usuarios.php").then(function () {
      sesionPromise = null;
      emitirSesion(null);
    });
  }

  global.GAUD_Usuarios = {
    iniciales: iniciales,
    ordinal: ordinal,
    periodoDelUsuario: periodoDelUsuario,
    obtenerSesion: obtenerSesion,
    cargarSesion: cargarSesion,
    autenticar: autenticar,
    cerrarSesion: cerrarSesion,
    crearUsuario: crearUsuario,
    obtenerUsuario: obtenerUsuario,
    obtenerCatalogo: obtenerCatalogo,
    actualizarUsuario: actualizarUsuario,
    cambiarPassword: cambiarPassword,
    eliminarCuenta: eliminarCuenta
  };
})(window);
