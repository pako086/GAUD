(function (global) {
  "use strict";

  const PAGINAS_AUTH = ["login", "registro"];
  const PAGINAS_APP = ["dashboard", "asignaturas", "perfil"];

  function obtenerPagina() {
    return document.body ? document.body.dataset.pagina : null;
  }

  function redirigir(destino) {
    global.location.replace(destino);
  }

  function proteger() {
    const U = global.GAUD_Usuarios;
    const pagina = obtenerPagina();
    if (!pagina) return;

    const sesionPromise = U.cargarSesion ? U.cargarSesion() : U.obtenerSesion();
    sesionPromise.then(function (sesion) {
      if (PAGINAS_AUTH.indexOf(pagina) !== -1) {
        if (sesion) redirigir("dashboard-tommisan.html");
        return;
      }
      if (PAGINAS_APP.indexOf(pagina) !== -1) {
        if (!sesion) redirigir("index.html");
      }
    }).catch(function () {});
  }

  global.GAUD_Guardas = {
    PAGINAS_AUTH: PAGINAS_AUTH,
    PAGINAS_APP: PAGINAS_APP,
    obtenerPagina: obtenerPagina,
    redirigir: redirigir,
    proteger: proteger
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", proteger);
  } else {
    proteger();
  }
})(window);
