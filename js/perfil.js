const GAUD_Perfil = (function () {
  const API = window.GAUD_API;
  const U = window.GAUD_Usuarios;
  const MODALIDADES = {
    presencial: "Presencial",
    virtual: "Virtual",
    mixta: "Mixta"
  };
  const CAMPOS = ["nombre", "email", "telefono", "direccion", "universidad", "carrera", "modalidad"];
  let cargadoPara = null;
  let pidiendoPara = null;
  let campoAbierto = null;
  let guardando = false;

  function $(sel) {
    return typeof document === "undefined" ? null : document.querySelector(sel);
  }

  function setTexto(sel, txt) {
    const el = $(sel);
    if (!el) return;
    el.textContent = txt === null || txt === undefined || txt === "" ? "—" : txt;
  }

  function iniciales(nombre) {
    if (!nombre) return "?";
    const partes = String(nombre).trim().split(/\s+/).filter(Boolean);
    if (!partes.length) return "?";
    return partes.slice(0, 2).map(function (p) { return p.charAt(0).toUpperCase(); }).join("");
  }

  function modalTexto(m) {
    return MODALIDADES[m] || m || "—";
  }

  function periodoNombre(u) {
    if (U && U.periodoDelUsuario) return U.periodoDelUsuario(u).nombre;
    return "—";
  }

  function notificar(mensaje, exito) {
    const cont = $("#perfil-alerta");
    if (!cont) return;
    cont.innerHTML = "";
    const div = document.createElement("div");
    div.className = exito ? "success-message" : "form-alert";
    div.textContent = mensaje;
    cont.appendChild(div);
  }

  function bloqueCampo(nombre) {
    return document.querySelector('.campo[data-campo="' + nombre + '"]');
  }

  let catalogo = null;

  function universidadesDelCatalogo() {
    return (catalogo && catalogo.universidades) || [];
  }

  function rellenarCarreras() {
    const sel = $("#carrera-perfil");
    const selUni = $("#universidad-perfil");
    if (!sel || !selUni) return;
    const uniId = selUni.value;
    const actual = sel.value;
    sel.innerHTML = "";
    const optVacia = document.createElement("option");
    optVacia.value = "";
    optVacia.textContent = "Selecciona una carrera";
    sel.appendChild(optVacia);
    const uni = universidadesDelCatalogo().find(function (x) { return String(x.id) === String(uniId); });
    ((uni && uni.carreras) || []).forEach(function (car) {
      const opt = document.createElement("option");
      opt.value = String(car.id);
      opt.textContent = car.nombre;
      sel.appendChild(opt);
    });
    if (actual && Array.prototype.some.call(sel.options, function (o) { return o.value === actual; })) {
      sel.value = actual;
    }
  }

  function rellenarSelects() {
    const selUni = $("#universidad-perfil");
    if (selUni) {
      const actual = selUni.value;
      selUni.innerHTML = "";
      universidadesDelCatalogo().forEach(function (uni) {
        const opt = document.createElement("option");
        opt.value = String(uni.id);
        opt.textContent = uni.nombre;
        selUni.appendChild(opt);
      });
      if (actual && Array.prototype.some.call(selUni.options, function (o) { return o.value === actual; })) {
        selUni.value = actual;
      }
    }
    rellenarCarreras();
  }

  function cargarCatalogo() {
    if (catalogo) return Promise.resolve(catalogo);
    if (!U || !U.obtenerCatalogo) return Promise.resolve(null);
    return U.obtenerCatalogo().then(function (cat) {
      catalogo = cat;
      rellenarSelects();
      pintar();
      return catalogo;
    }).catch(function () {
      return null;
    });
  }

  function textoValor(nombre, u) {
    if (nombre === "modalidad") return modalTexto(u.modalidad);
    const v = u[nombre];
    if (v === null || v === undefined || String(v).trim() === "") return "—";
    return String(v);
  }

  function pintar() {
    const data = window.GAUD_DATA;
    const u = data && data.usuario;
    if (!u) return;
    const d = data.dashboard;

    const avatar = $("#perfil-avatar");
    if (avatar) avatar.textContent = iniciales(u.nombre);
    setTexto("#perfil-nombre-resumen", u.nombre);
    setTexto("#perfil-resumen", [u.universidad, u.carrera, modalTexto(u.modalidad)].filter(Boolean).join(" · "));
    setTexto("#perfil-badge-carrera", u.carrera);
    setTexto("#perfil-badge-modalidad", modalTexto(u.modalidad));

    CAMPOS.forEach(function (nombre) {
      const bloque = bloqueCampo(nombre);
      if (!bloque) return;
      const valor = bloque.querySelector("[data-valor]");
      if (valor) valor.textContent = textoValor(nombre, u);
      const input = bloque.querySelector(".campo-input");
      if (!input) return;
      if (input.tagName === "SELECT") {
        if (nombre === "modalidad") {
          input.value = MODALIDADES[u.modalidad] ? u.modalidad : "presencial";
        } else if (nombre === "universidad") {
          input.value = u.universidad_id ? String(u.universidad_id) : "";
        } else if (nombre === "carrera") {
          input.value = u.carrera_id ? String(u.carrera_id) : "";
        }
      } else {
        input.value = u[nombre] === null || u[nombre] === undefined ? "" : String(u[nombre]);
      }
    });
    if (catalogo) rellenarSelects();

    setTexto("#periodo-perfil", periodoNombre(u));
    if (!d) return;

    const progreso = Number(d.progreso || 0);
    const creditosGanados = Number(d.creditos_ganados || 0);
    const totalCreditos = Number(d.total_creditos || 0);
    const cursadas = Number(d.aprobadas || 0) + Number(d.en_curso || 0);

    setTexto("#indice-perfil", Number(d.indice_academico || 0).toFixed(2));
    setTexto("#creditos-perfil", creditosGanados + " / " + totalCreditos);
    setTexto("#cursadas-perfil", String(cursadas));
    setTexto("#pendientes-perfil", String(d.pendientes || 0));

    const fill = $("#perfil-progreso-fill");
    if (fill) fill.style.width = Math.max(0, Math.min(100, progreso)) + "%";
    setTexto("#perfil-progreso-badge", progreso.toFixed(1) + "%");
    setTexto("#perfil-progreso-ganados", creditosGanados + " créditos aprobados");
    setTexto("#perfil-progreso-restantes", Math.max(0, totalCreditos - creditosGanados) + " créditos restantes");
  }

  function limpiarError(bloque) {
    const err = bloque.querySelector(".campo-error");
    if (err) {
      err.hidden = true;
      err.textContent = "";
    }
    const input = bloque.querySelector(".campo-input");
    if (input) input.classList.remove("campo-invalido");
  }

  function errorCampo(bloque, mensaje) {
    const err = bloque.querySelector(".campo-error");
    if (err) {
      err.hidden = false;
      err.textContent = mensaje;
    }
    const input = bloque.querySelector(".campo-input");
    if (input) input.classList.add("campo-invalido");
  }

  function validarCampo(nombre, valor) {
    const v = String(valor).trim();
    if (nombre === "nombre" || nombre === "universidad" || nombre === "carrera") {
      return v ? null : "Este campo es obligatorio";
    }
    if (nombre === "email") {
      return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) ? null : "Ingresa un correo válido";
    }
    if (nombre === "telefono") {
      return v === "" || /^\+?[\d\s().-]{7,20}$/.test(v) ? null : "Ingresa un teléfono válido";
    }
    if (nombre === "modalidad") {
      return MODALIDADES[v] ? null : "Selecciona una modalidad válida";
    }
    return null;
  }

  function cerrarCampo() {
    if (!campoAbierto) return;
    const bloque = bloqueCampo(campoAbierto);
    if (bloque) {
      bloque.classList.remove("editando");
      const valor = bloque.querySelector("[data-valor]");
      const form = bloque.querySelector(".campo-form");
      if (valor) valor.hidden = false;
      if (form) form.hidden = true;
      limpiarError(bloque);
    }
    campoAbierto = null;
  }

  function abrirCampo(nombre) {
    if (guardando) return;
    if (campoAbierto === nombre) {
      cerrarCampo();
      return;
    }
    cerrarCampo();
    const bloque = bloqueCampo(nombre);
    if (!bloque) return;
    campoAbierto = nombre;
    bloque.classList.add("editando");
    const valor = bloque.querySelector("[data-valor]");
    const form = bloque.querySelector(".campo-form");
    if (valor) valor.hidden = true;
    if (form) form.hidden = false;
    limpiarError(bloque);
    const input = bloque.querySelector(".campo-input");
    if (input) {
      input.focus();
      if (typeof input.select === "function") input.select();
    }
  }

  function payloadBase(u) {
    return {
      nombre: (u.nombre || "").trim(),
      email: (u.email || "").trim(),
      telefono: (u.telefono || "").trim(),
      direccion: (u.direccion || "").trim(),
      universidad_id: Number(u.universidad_id) || 0,
      carrera_id: Number(u.carrera_id) || 0,
      modalidad: u.modalidad || "presencial"
    };
  }

  function guardarCampo(nombre) {
    if (guardando) return;
    const data = window.GAUD_DATA;
    const u = data && data.usuario;
    const bloque = bloqueCampo(nombre);
    if (!u || !bloque || !U || !U.actualizarUsuario) return;
    const input = bloque.querySelector(".campo-input");
    const valor = input ? input.value : "";
    const error = validarCampo(nombre, valor);
    if (error) {
      errorCampo(bloque, error);
      return;
    }
    const payload = payloadBase(u);
    const clave = nombre === "universidad" ? "universidad_id" : nombre === "carrera" ? "carrera_id" : nombre;
    payload[clave] = clave === "universidad_id" || clave === "carrera_id" ? Number(valor) : String(valor).trim();
    guardando = true;
    const botones = bloque.querySelectorAll("[data-accion]");
    botones.forEach(function (b) { b.disabled = true; });
    const btn = bloque.querySelector('[data-accion="guardar"]');
    const texto = btn ? btn.textContent : "";
    if (btn) btn.textContent = "Guardando...";
    U.actualizarUsuario(payload)
      .then(function () {
        notificar("Perfil actualizado", true);
        cerrarCampo();
      })
      .catch(function (err) {
        if (err && err.status === 409 && nombre === "email") {
          errorCampo(bloque, "Ese correo ya está registrado");
        } else {
          notificar((err && err.message) || "No fue posible guardar el cambio");
        }
      })
      .then(function () {
        guardando = false;
        botones.forEach(function (b) { b.disabled = false; });
        if (btn) btn.textContent = texto;
        pintar();
      });
  }

  function cargar() {
    const data = window.GAUD_DATA;
    const u = data && data.usuario;
    if (!u || !API) {
      cargadoPara = null;
      pintar();
      return;
    }
    const id = String(u.id);
    if (cargadoPara === id || pidiendoPara === id) {
      pintar();
      return;
    }
    pidiendoPara = id;
    API.get("/dashboard.php")
      .then(function (d) {
        if (String((window.GAUD_DATA.usuario || {}).id) !== id) return;
        window.GAUD_DATA.dashboard = d;
        cargadoPara = id;
        pintar();
      })
      .catch(function (err) {
        if (String((window.GAUD_DATA.usuario || {}).id) !== id) return;
        if (err && err.status === 401) {
          window.location.replace("index.html");
          return;
        }
        notificar((err && err.message) || "No fue posible cargar el perfil");
      })
      .then(function () {
        if (pidiendoPara === id) pidiendoPara = null;
      });
  }

  function cambiarPassword(e) {
    e.preventDefault();
    const form = e.target;
    if (!U || !U.cambiarPassword) return;
    form.querySelectorAll(".campo-invalido").forEach(function (el) { el.classList.remove("campo-invalido"); });
    form.querySelectorAll(".campo-error").forEach(function (el) { el.remove(); });
    const actual = form.querySelector("#password-actual");
    const nueva = form.querySelector("#password-nueva");
    const confirmar = form.querySelector("#password-confirmar");
    let ok = true;
    if (!actual.value) {
      marcarErrorPassword(actual, "La contraseña actual es obligatoria");
      ok = false;
    }
    if (!nueva.value) {
      marcarErrorPassword(nueva, "La nueva contraseña es obligatoria");
      ok = false;
    } else if (nueva.value.length < 8) {
      marcarErrorPassword(nueva, "Mínimo 8 caracteres");
      ok = false;
    }
    if (nueva.value !== confirmar.value) {
      marcarErrorPassword(confirmar, "Las contraseñas no coinciden");
      ok = false;
    }
    if (!ok) return;
    const btn = $("#btn-cambiar-password");
    const texto = btn ? btn.textContent : "";
    if (btn) {
      btn.disabled = true;
      btn.textContent = "Esperando...";
    }
    U.cambiarPassword(actual.value, nueva.value, confirmar.value)
      .then(function () {
        form.reset();
        notificar("Contraseña actualizada", true);
      })
      .catch(function (err) {
        notificar((err && err.message) || "No fue posible cambiar la contraseña");
      })
      .then(function () {
        if (btn) {
          btn.disabled = false;
          btn.textContent = texto;
        }
      });
  }

  function marcarErrorPassword(campo, mensaje) {
    if (!campo) return;
    campo.classList.add("campo-invalido");
    const err = document.createElement("div");
    err.className = "campo-error";
    err.textContent = mensaje;
    campo.parentElement.appendChild(err);
  }

  function eliminarCuenta(e) {
    e.preventDefault();
    if (!U || !U.eliminarCuenta) return;
    const confirmado = window.confirm("¿Seguro que deseas eliminar tu cuenta?");
    if (!confirmado) return;
    const btn = $("#btn-eliminar-cuenta");
    const texto = btn ? btn.textContent : "";
    if (btn) {
      btn.disabled = true;
      btn.textContent = "Esperando...";
    }
    U.eliminarCuenta()
      .then(function () {
        window.location.replace("index.html");
      })
      .catch(function (err) {
        if (btn) {
          btn.disabled = false;
          btn.textContent = texto;
        }
        notificar((err && err.message) || "No fue posible eliminar la cuenta");
      });
  }

  function enlazar() {
    if (typeof document === "undefined") return;
    document.querySelectorAll(".campo").forEach(function (bloque) {
      const nombre = bloque.getAttribute("data-campo");
      bloque.querySelectorAll("[data-accion]").forEach(function (btn) {
        btn.addEventListener("click", function () {
          const accion = btn.getAttribute("data-accion");
          if (accion === "editar") {
            abrirCampo(nombre);
          } else if (accion === "cancelar") {
            cerrarCampo();
          } else if (accion === "guardar") {
            guardarCampo(nombre);
          }
        });
      });
      const input = bloque.querySelector(".campo-input");
      if (input) {
        input.addEventListener("keydown", function (e) {
          if (e.key === "Enter") {
            e.preventDefault();
            guardarCampo(nombre);
          } else if (e.key === "Escape") {
            e.preventDefault();
            cerrarCampo();
          }
        });
      }
    });
    const formPassword = $("#form-password");
    if (formPassword) formPassword.addEventListener("submit", cambiarPassword);
    const btnEliminar = $("#btn-eliminar-cuenta");
    if (btnEliminar) btnEliminar.addEventListener("click", eliminarCuenta);

    const selUniPerfil = $("#universidad-perfil");
    if (selUniPerfil) {
      selUniPerfil.addEventListener("change", function () {
        rellenarCarreras();
      });
    }
    cargarCatalogo();

    document.addEventListener("gaud:sesion", function (e) {
      const sesion = e && e.detail ? e.detail.sesion : null;
      const id = sesion && sesion.usuario ? String(sesion.usuario.id) : null;
      if (id && cargadoPara === id) {
        pintar();
        return;
      }
      cargadoPara = null;
      pintar();
      cargar();
    });

    if (window.GAUD_DATA && window.GAUD_DATA.usuario) {
      cargar();
    } else {
      pintar();
    }
  }

  return {
    pintar: pintar,
    cargar: cargar,
    enlazar: enlazar
  };
})();

if (typeof document !== "undefined") {
  document.addEventListener("DOMContentLoaded", function () { GAUD_Perfil.enlazar(); });
}
