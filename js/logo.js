const GAUD_Logo = (function () {
  const CLASE = "logo-animado";

  function obtenerLogo() {
    if (typeof document === "undefined") return null;
    return document.querySelector("#logo-dashboard") || document.querySelector(".logo-img");
  }

  function animar(el) {
    if (!el) return false;
    el.classList.remove(CLASE);
    void el.offsetWidth;
    el.classList.add(CLASE);
    return true;
  }

  function quitar(el) {
    if (!el) return false;
    el.classList.remove(CLASE);
    return true;
  }

  function enlazar() {
    const logo = obtenerLogo();
    if (!logo) return;
    logo.addEventListener("mouseenter", function () { animar(logo); });
    logo.addEventListener("mouseleave", function () { quitar(logo); });
  }

  return { CLASE, obtenerLogo, animar, quitar, enlazar };
})();

if (typeof document !== "undefined") {
  document.addEventListener("DOMContentLoaded", function () { GAUD_Logo.enlazar(); });
}
