const GAUD_Validaciones = (function () {
  function esRequerido(valor) {
    if (valor === null || valor === undefined) return false;
    return String(valor).trim().length > 0;
  }

  function esEmailValido(valor) {
    if (!esRequerido(valor)) return false;
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(valor).trim());
  }

  function esNombreValido(valor) {
    if (!esRequerido(valor)) return false;
    const partes = String(valor).trim().split(/\s+/);
    return partes.length >= 2 && partes.every(function (p) { return /^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ'-.]+$/.test(p); });
  }

  function longitudMinima(valor, min = 1) {
    if (!esRequerido(valor)) return false;
    return String(valor).trim().length >= min;
  }

  function contrasenasCoinciden(a, b) {
    return esRequerido(a) && String(a) === String(b);
  }

  function esSeleccionado(valor) {
    return esRequerido(valor);
  }

  function esTelefonoValido(valor) {
    if (!esRequerido(valor)) return true;
    return /^\+?[\d\s().-]{7,20}$/.test(String(valor).trim());
  }

  function obtenerCampo(form, id) {
    return form.querySelector(`[name="${id}"], #${id}`);
  }

  function mostrarError(campo, mensaje) {
    if (!campo) return;
    campo.classList.add("campo-invalido");
    let err = campo.parentElement.querySelector(".campo-error");
    if (!err) {
      err = document.createElement("div");
      err.className = "campo-error";
      campo.parentElement.appendChild(err);
    }
    err.textContent = mensaje;
  }

  function limpiarError(campo) {
    if (!campo) return;
    campo.classList.remove("campo-invalido");
    const err = campo.parentElement.querySelector(".campo-error");
    if (err) err.remove();
  }

  function limpiarFormulario(form) {
    form.querySelectorAll(".campo-invalido").forEach(function (el) { el.classList.remove("campo-invalido"); });
    form.querySelectorAll(".campo-error").forEach(function (el) { el.remove(); });
  }

  function limpiarAlerta(form) {
    form.querySelectorAll(".form-alert").forEach(function (el) { el.remove(); });
  }

  function mostrarAlerta(form, mensaje) {
    limpiarAlerta(form);
    const div = document.createElement("div");
    div.className = "form-alert";
    div.textContent = mensaje;
    form.insertBefore(div, form.firstChild);
  }

  function validarFormulario(form, config) {
    limpiarFormulario(form);
    let valido = true;
    let primero = null;
    for (const [id, reglas] of Object.entries(config)) {
      const campo = obtenerCampo(form, id);
      if (!campo) continue;
      const valor = campo.type === "checkbox" ? campo.checked : campo.value;
      for (const regla of reglas) {
        if (!regla.valida(valor, campo)) {
          valido = false;
          if (!primero) primero = campo;
          mostrarError(campo, regla.mensaje);
          break;
        }
      }
    }
    if (primero) primero.focus();
    return valido;
  }

  function enlazar(form, config, onExito) {
    if (!form) return;
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      limpiarAlerta(form);
      if (validarFormulario(form, config)) {
        limpiarFormulario(form);
        if (typeof onExito === "function") onExito(form);
      }
    });
    function limpiarAlEditar(e) {
      if (e.target && e.target.classList) limpiarError(e.target);
    }
    form.addEventListener("input", limpiarAlEditar);
    form.addEventListener("change", limpiarAlEditar);
  }

  return {
    esRequerido,
    esEmailValido,
    esNombreValido,
    longitudMinima,
    contrasenasCoinciden,
    esSeleccionado,
    esTelefonoValido,
    obtenerCampo,
    mostrarError,
    limpiarError,
    limpiarFormulario,
    limpiarAlerta,
    mostrarAlerta,
    validarFormulario,
    enlazar
  };
})();

if (typeof document !== "undefined") {
  function mostrarBannerExito() {
    const banner = document.getElementById("banner-exito");
    if (!banner) return;
    const params = new URLSearchParams(window.location.search);
    if (params.get("registrado") === "1") banner.classList.add("visible");
  }

  function iniciarValidaciones() {
    const pagina = document.body ? document.body.dataset.pagina : null;
    if (pagina !== "login" && pagina !== "registro") return;

    mostrarBannerExito();
    const form = document.querySelector("form");
    if (!form) return;

    const V = GAUD_Validaciones;
    const U = window.GAUD_Usuarios;
    const esRegistro = pagina === "registro";

    const reglas = esRegistro
      ? {
          nombre: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "El nombre es obligatorio" },
            { valida: function (v) { return V.esNombreValido(v); }, mensaje: "Ingresa tu nombre y apellido" },
          ],
          correo: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "El correo es obligatorio" },
            { valida: function (v) { return V.esEmailValido(v); }, mensaje: "Ingresa un correo válido" },
          ],
          telefono: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "El teléfono es obligatorio" },
            { valida: function (v) { return V.esTelefonoValido(v); }, mensaje: "Ingresa un teléfono válido" },
          ],
          direccion: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "La dirección es obligatoria" },
          ],
          universidad: [
            { valida: function (v) { return V.esSeleccionado(v); }, mensaje: "Selecciona una universidad" },
          ],
          carrera: [
            { valida: function (v) { return V.esSeleccionado(v); }, mensaje: "Selecciona una carrera" },
          ],
          modalidad: [
            { valida: function (v) { return V.esSeleccionado(v); }, mensaje: "Selecciona una modalidad" },
          ],
          password: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "La contraseña es obligatoria" },
            { valida: function (v) { return V.longitudMinima(v, 8); }, mensaje: "Mínimo 8 caracteres" },
          ],
          "confirmar-password": [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "Confirma tu contraseña" },
            {
              valida: function (v, campo) { return V.contrasenasCoinciden(v, campo.form.querySelector("#password").value); },
              mensaje: "Las contraseñas no coinciden"
            },
          ],
          terminos: [
            { valida: function (v) { return v === true; }, mensaje: "Debes aceptar los términos" },
          ],
        }
      : {
          email: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "El correo es obligatorio" },
            { valida: function (v) { return V.esEmailValido(v); }, mensaje: "Ingresa un correo válido" },
          ],
          password: [
            { valida: function (v) { return V.esRequerido(v); }, mensaje: "La contraseña es obligatoria" },
          ],
        };

    function onExito(f) {
      const btn = f.querySelector("button[type=submit]");
      const textoBoton = btn ? btn.textContent : "";
      function restaurarBoton() {
        if (!btn) return;
        btn.disabled = false;
        btn.textContent = textoBoton;
      }

      if (btn) {
        btn.disabled = true;
        btn.textContent = "Esperando...";
      }

      if (esRegistro) {
        const payload = {
          nombre: f.querySelector("#nombre").value.trim(),
          email: f.querySelector("#correo").value.trim(),
          password: f.querySelector("#password").value,
          telefono: f.querySelector("#telefono").value.trim(),
          direccion: f.querySelector("#direccion").value.trim(),
          universidad_id: Number(f.querySelector("#universidad").value),
          carrera_id: Number(f.querySelector("#carrera").value),
          modalidad: f.querySelector("#modalidad").value,
          terminos_aceptados: true
        };
        U.crearUsuario(payload)
          .then(function () {
            return U.cerrarSesion();
          })
          .then(function () {
            window.location.replace("index.html?registrado=1");
          })
          .catch(function (err) {
            restaurarBoton();
            if (err && err.status === 409) {
              V.mostrarError(f.querySelector("#correo"), "Ese correo ya está registrado");
            } else {
              V.mostrarAlerta(f, (err && err.message) || "No fue posible crear la cuenta");
            }
          });
        return;
      }

      const email = f.querySelector("#email").value.trim();
      const password = f.querySelector("#password").value;
      U.autenticar(email, password)
        .then(function () {
          window.location.replace("dashboard-tommisan.html");
        })
        .catch(function (err) {
          restaurarBoton();
          if (err && err.status === 401) {
            V.mostrarError(f.querySelector("#password"), "Credenciales incorrectas");
          } else {
            V.mostrarAlerta(f, (err && err.message) || "No fue posible iniciar sesión");
          }
        });
    }

    if (esRegistro) {
      const selUni = form.querySelector("#universidad");
      const selCar = form.querySelector("#carrera");
      if (selUni && selCar && U && U.obtenerCatalogo) {
        U.obtenerCatalogo().then(function (cat) {
          const unis = (cat && cat.universidades) || [];
          unis.forEach(function (uni) {
            const opt = document.createElement("option");
            opt.value = String(uni.id);
            opt.textContent = uni.nombre;
            selUni.appendChild(opt);
          });
          function rellenarCarreras() {
            const uniId = selUni.value;
            const actual = selCar.value;
            selCar.querySelectorAll("option[data-dinamica]").forEach(function (o) { o.remove(); });
            const uni = unis.find(function (x) { return String(x.id) === String(uniId); });
            ((uni && uni.carreras) || []).forEach(function (car) {
              const opt = document.createElement("option");
              opt.value = String(car.id);
              opt.textContent = car.nombre;
              opt.setAttribute("data-dinamica", "1");
              selCar.appendChild(opt);
            });
            selCar.value = actual;
          }
          selUni.addEventListener("change", rellenarCarreras);
        }).catch(function () {});
      }
    }

    V.enlazar(form, reglas, onExito);

    if (esRegistro) {
      const campoPassword = form.querySelector("#password");
      const campoConfirmar = form.querySelector("#confirmar-password");

      function validarConfirmacionEnVivo() {
        if (!campoPassword || !campoConfirmar) return;
        const confirmar = campoConfirmar.value;
        if (confirmar === "" || confirmar === campoPassword.value) {
          V.limpiarError(campoConfirmar);
        } else {
          V.mostrarError(campoConfirmar, "Las contraseñas no coinciden");
        }
      }

      form.addEventListener("input", function (e) {
        if (!e.target) return;
        if (e.target === campoPassword || e.target === campoConfirmar) {
          validarConfirmacionEnVivo();
        }
      });

      const enlaceTerminos = form.querySelector("#enlace-terminos");
      const overlayTerminos = document.getElementById("terminos-overlay");
      const botonCerrarTerminos = overlayTerminos ? overlayTerminos.querySelector("#cerrar-terminos") : null;

      function abrirTerminos() {
        if (!overlayTerminos) return;
        overlayTerminos.hidden = false;
        document.body.classList.add("terminos-abiertos");
        if (botonCerrarTerminos) botonCerrarTerminos.focus();
      }

      function cerrarTerminos() {
        if (!overlayTerminos) return;
        overlayTerminos.hidden = true;
        document.body.classList.remove("terminos-abiertos");
        if (enlaceTerminos) enlaceTerminos.focus();
      }

      if (enlaceTerminos) {
        enlaceTerminos.addEventListener("click", function (e) {
          e.preventDefault();
          abrirTerminos();
        });
      }
      if (botonCerrarTerminos) {
        botonCerrarTerminos.addEventListener("click", cerrarTerminos);
      }
      if (overlayTerminos) {
        overlayTerminos.addEventListener("click", function (e) {
          if (e.target === overlayTerminos) cerrarTerminos();
        });
      }
      document.addEventListener("keydown", function (e) {
        if (e.key === "Escape" && overlayTerminos && !overlayTerminos.hidden) {
          cerrarTerminos();
        }
      });
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", iniciarValidaciones);
  } else {
    iniciarValidaciones();
  }
}
