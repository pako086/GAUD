const GAUD_Asignaturas = (function () {
  const API = typeof window !== "undefined" ? window.GAUD_API : null;
  const ESTADOS_VALIDOS = ["aprobada", "en-curso", "pendiente"];
  const ORDEN_MENU = ["pendiente", "en-curso", "aprobada"];
  const ETIQUETA_ESTADOS = { pendiente: "Pendiente", "en-curso": "En curso", aprobada: "Aprobada" };
  const LETRAS_CALIF = ["A", "B", "C"];
  const RANGOS_CALIF = { A: "A · 90-100", B: "B · 80-89", C: "C · 70-79" };

  const guardando = new Set();
  const pidiendo = new Set();
  const overridesColapso = new Map();
  let gridEnlazado = false;
  let herramientasEnlazadas = false;
  let usuarioCargado = null;

  function normalizar(texto) {
    return String(texto || "")
      .toLowerCase()
      .trim()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "");
  }

  function obtenerPensum() {
    return typeof GAUD_DATA !== "undefined" && Array.isArray(GAUD_DATA.pensum) ? GAUD_DATA.pensum : [];
  }

  function buscarPorId(id) {
    return obtenerPensum().find(function (a) { return String(a.id) === String(id); });
  }

  function revertir(a, anterior) {
    a.estado = anterior.estado;
    a.calificacion = anterior.calificacion;
    if (typeof document !== "undefined") {
      const fila = document.querySelector(`.pensum-grid .course[data-id="${a.id}"]`);
      if (fila) {
        actualizarFila(fila, a);
        const termEl = fila.closest(".term");
        if (termEl)
          sincronizarTerm(termEl, asignaturasDePeriodo(obtenerPensum(), Number(termEl.dataset.trimestre)));
      }
    }
    renderCurrent(obtenerPensum().filter(function (x) { return x.estado === "en-curso"; }));
    aplicar();
  }

  async function guardarCambios(a, anterior) {
    if (!API || !a.id) return;
    const clave = String(a.id);
    if (guardando.has(clave)) return;
    guardando.add(clave);
    try {
      const respuesta = await API.put("/asignaturas.php", {
        id: Number(a.id),
        estado: a.estado,
        calificacion: a.calificacion
      });
      if (respuesta && typeof respuesta === "object") {
        if (typeof respuesta.estado === "string") a.estado = respuesta.estado;
        if (respuesta.calificacion !== undefined) a.calificacion = respuesta.calificacion;
      }
    } catch (e) {
      revertir(a, anterior);
      window.alert((e && e.message) || "No se pudo guardar la asignatura.");
    } finally {
      guardando.delete(clave);
    }
  }

  function claseEstado(estado) {
    const mapa = { aprobada: "approved", "en-curso": "current", pendiente: "pending" };
    return mapa[estado] || "pending";
  }

  function claseCalificacion(a) {
    return a.estado === "aprobada" && LETRAS_CALIF.includes(a.calificacion) ? "calif-" + a.calificacion : "";
  }

  function clasesFila(a) {
    const base = "course status-" + claseEstado(a.estado);
    const calif = claseCalificacion(a);
    return calif ? base + " " + calif : base;
  }

  function asignaturasDePeriodo(pensum, trimestre) {
    return pensum.filter(function (a) { return a.trimestre === trimestre; });
  }

  function calcularCreditos(asignaturas) {
    return asignaturas.reduce(function (s, a) { return s + a.creditos; }, 0);
  }

  function contarAprobadas(asignaturas) {
    return asignaturas.filter(function (a) { return a.estado === "aprobada"; }).length;
  }

  function todasAprobadas(asignaturas) {
    return asignaturas.length > 0 && asignaturas.every(function (a) { return a.estado === "aprobada"; });
  }

  function todasConCalificacion(asignaturas) {
    return asignaturas.length > 0 && asignaturas.every(function (a) {
      return a.estado === "aprobada" && LETRAS_CALIF.includes(a.calificacion);
    });
  }

  function colapsoEfectivo(trimestre, asigs) {
    const ov = overridesColapso.get(trimestre);
    return ov !== undefined ? ov : todasConCalificacion(asigs);
  }

  function agruparPorTrimestre(pensum) {
    const mapa = new Map();
    pensum.forEach(function (a) {
      if (!mapa.has(a.trimestre)) mapa.set(a.trimestre, []);
      mapa.get(a.trimestre).push(a);
    });
    return new Map([...mapa.entries()].sort(function (x, y) { return x[0] - y[0]; }));
  }

  function coincideBusqueda(asignatura, texto) {
    const q = normalizar(texto);
    if (q === "") return true;
    return normalizar(`${asignatura.codigo} ${asignatura.nombre}`).includes(q);
  }

  function coincideEstado(asignatura, estado) {
    return estado === "todas" || asignatura.estado === estado;
  }

  function filtrarPensum(pensum, busqueda, estado) {
    return pensum.filter(function (a) { return coincideBusqueda(a, busqueda) && coincideEstado(a, estado); });
  }

  function renderCurrent(asignaturas) {
    if (typeof document === "undefined") return;
    const cont = document.querySelector(".current-list");
    if (!cont) return;
    cont.innerHTML = "";
    if (!asignaturas.length) {
      const vacio = document.createElement("div");
      vacio.className = "current-item";
      vacio.style.gridColumn = "1 / -1";
      vacio.textContent = "No hay materias en curso.";
      cont.appendChild(vacio);
    } else {
      asignaturas.forEach(function (a) {
        const item = document.createElement("div");
        item.className = "current-item";
        const code = document.createElement("div");
        code.className = "item-code";
        code.textContent = a.codigo;
        const name = document.createElement("div");
        name.className = "item-name";
        name.textContent = a.nombre;
        const credits = document.createElement("div");
        credits.className = "item-credits";
        credits.textContent = `${a.creditos} cr`;
        item.appendChild(code);
        item.appendChild(name);
        item.appendChild(credits);
        cont.appendChild(item);
      });
    }
    const badge = document.querySelector("#asignaturas-periodo") || document.querySelector(".period-badge");
    if (badge) {
      const u = typeof GAUD_DATA !== "undefined" ? GAUD_DATA.usuario : null;
      const tri = u && u.trimestre_actual ? Number(u.trimestre_actual) : (asignaturas[0] ? Number(asignaturas[0].trimestre) : null);
      badge.textContent = tri ? `Trimestre ${tri}` : "—";
    }
  }

  function renderCalif(a, cell) {
    cell.innerHTML = "";
    if (a.estado !== "aprobada") {
      const vacio = document.createElement("span");
      vacio.className = "calif-vacio";
      vacio.textContent = "—";
      cell.appendChild(vacio);
      return;
    }
    const row = document.createElement("div");
    row.className = "calif-row";
    LETRAS_CALIF.forEach(function (letra) {
      const bub = document.createElement("button");
      bub.type = "button";
      bub.className = "bub bub-" + letra + (a.calificacion === letra ? " activo" : "");
      bub.textContent = letra;
      bub.title = RANGOS_CALIF[letra];
      bub.setAttribute("aria-label", "Calificación " + letra);
      bub.addEventListener("click", function (e) {
        e.stopPropagation();
        const fila = cell.closest(".course");
        const anterior = { estado: a.estado, calificacion: a.calificacion };
        a.calificacion = a.calificacion === letra ? null : letra;
        if (fila) {
          actualizarFila(fila, a);
          const termEl = fila.closest(".term");
          if (termEl)
            sincronizarTerm(termEl, asignaturasDePeriodo(obtenerPensum(), Number(termEl.dataset.trimestre)));
          aplicar();
        }
        guardarCambios(a, anterior);
      });
      row.appendChild(bub);
    });
    cell.appendChild(row);
  }

  function crearChip(a) {
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = "estado-chip st-" + claseEstado(a.estado);
    chip.setAttribute("aria-haspopup", "true");
    chip.setAttribute("aria-expanded", "false");
    const dot = document.createElement("span");
    dot.className = "estado-dot st-" + claseEstado(a.estado);
    const label = document.createElement("span");
    label.className = "estado-chip-label";
    label.textContent = ETIQUETA_ESTADOS[a.estado] || a.estado;
    const caret = document.createElement("span");
    caret.className = "estado-caret";
    caret.setAttribute("aria-hidden", "true");
    caret.textContent = "▾";
    chip.appendChild(dot);
    chip.appendChild(label);
    chip.appendChild(caret);
    return chip;
  }

  function actualizarFila(fila, a) {
    fila.className = clasesFila(a);
    fila.dataset.estado = a.estado;
    const chip = fila.querySelector(".estado-chip");
    if (chip) {
      chip.className = "estado-chip st-" + claseEstado(a.estado);
      const dot = chip.querySelector(".estado-dot");
      if (dot) dot.className = "estado-dot st-" + claseEstado(a.estado);
      const label = chip.querySelector(".estado-chip-label");
      if (label) label.textContent = ETIQUETA_ESTADOS[a.estado] || a.estado;
    }
    renderCalif(a, fila.querySelector(".course-calif"));
  }

  let menuEl = null;
  let menuFila = null;

  function crearMenu() {
    if (menuEl) return;
    menuEl = document.createElement("div");
    menuEl.className = "estado-menu";
    menuEl.setAttribute("role", "menu");
    menuEl.hidden = true;
    ORDEN_MENU.forEach(function (estado) {
      const opt = document.createElement("button");
      opt.type = "button";
      opt.className = "estado-opt";
      opt.dataset.estado = estado;
      opt.setAttribute("role", "menuitemradio");
      opt.setAttribute("aria-checked", "false");
      const dot = document.createElement("span");
      dot.className = "estado-dot st-" + claseEstado(estado);
      const label = document.createElement("span");
      label.className = "estado-opt-label";
      label.textContent = ETIQUETA_ESTADOS[estado];
      const check = document.createElement("span");
      check.className = "estado-check";
      check.setAttribute("aria-hidden", "true");
      check.textContent = "✓";
      opt.appendChild(dot);
      opt.appendChild(label);
      opt.appendChild(check);
      opt.addEventListener("click", function () { elegirEstado(estado); });
      menuEl.appendChild(opt);
    });
    document.body.appendChild(menuEl);
    document.addEventListener("click", function (e) {
      if (menuEl && !menuEl.hidden && !e.target.closest(".estado-menu")) cerrarMenu();
    });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && menuEl && !menuEl.hidden) cerrarMenu();
    });
    window.addEventListener("scroll", function () {
      if (menuEl && !menuEl.hidden) cerrarMenu();
    }, true);
    window.addEventListener("resize", function () {
      if (menuEl && !menuEl.hidden) cerrarMenu();
    });
  }

  function abrirMenu(fila) {
    if (!menuEl) crearMenu();
    const a = buscarPorId(fila.dataset.id);
    const chip = fila.querySelector(".estado-chip");
    if (!a || !chip) return;
    menuFila = fila;
    menuEl.querySelectorAll(".estado-opt").forEach(function (opt) {
      const activa = opt.dataset.estado === a.estado;
      opt.classList.toggle("activo", activa);
      opt.setAttribute("aria-checked", String(activa));
    });
    chip.setAttribute("aria-expanded", "true");
    menuEl.hidden = false;
    const rect = chip.getBoundingClientRect();
    const mw = menuEl.offsetWidth;
    const mh = menuEl.offsetHeight;
    const vw = window.innerWidth;
    const vh = window.innerHeight;
    let x = rect.left;
    if (x + mw > vw - 8) x = Math.max(8, vw - 8 - mw);
    let y = rect.bottom + 6;
    if (y + mh > vh - 8) y = Math.max(8, rect.top - 6 - mh);
    menuEl.style.left = x + "px";
    menuEl.style.top = y + "px";
  }

  function cerrarMenu() {
    if (!menuEl) return;
    menuEl.hidden = true;
    if (menuFila) {
      const chip = menuFila.querySelector(".estado-chip");
      if (chip) chip.setAttribute("aria-expanded", "false");
    }
    menuFila = null;
  }

  function elegirEstado(estado) {
    const fila = menuFila;
    cerrarMenu();
    if (!fila) return;
    const a = buscarPorId(fila.dataset.id);
    if (!a || a.estado === estado) return;
    const anterior = { estado: a.estado, calificacion: a.calificacion };
    a.estado = estado;
    if (estado !== "aprobada") a.calificacion = null;
    actualizarFila(fila, a);
    const termEl = fila.closest(".term");
    if (termEl)
      sincronizarTerm(termEl, asignaturasDePeriodo(obtenerPensum(), Number(termEl.dataset.trimestre)));
    renderCurrent(obtenerPensum().filter(function (x) { return x.estado === "en-curso"; }));
    aplicar();
    guardarCambios(a, anterior);
  }

  function renderPensum(pensum) {
    if (typeof document === "undefined") return;
    const cont = document.querySelector(".pensum-grid");
    if (!cont) return;
    cont.innerHTML = "";
    agruparPorTrimestre(pensum).forEach(function (asigs, tri) {
      const term = document.createElement("table");
      term.className = "term";
      term.dataset.trimestre = tri;

      const head = document.createElement("thead");
      head.className = "term-head";
      head.setAttribute("role", "button");
      head.setAttribute("tabindex", "0");
      head.setAttribute("aria-expanded", "true");
      const headRow = document.createElement("tr");
      const thMain = document.createElement("th");
      const num = document.createElement("span");
      num.className = "term-num";
      num.textContent = `Trimestre ${tri}`;
      const progress = document.createElement("span");
      progress.className = "term-progress";
      thMain.appendChild(num);
      thMain.appendChild(progress);
      const thCredits = document.createElement("th");
      thCredits.className = "term-credits";
      const thChevron = document.createElement("th");
      const chevron = document.createElement("span");
      chevron.className = "term-chevron";
      chevron.setAttribute("aria-hidden", "true");
      chevron.textContent = "▾";
      thChevron.appendChild(chevron);
      headRow.appendChild(thMain);
      headRow.appendChild(thCredits);
      headRow.appendChild(thChevron);
      head.appendChild(headRow);
      term.appendChild(head);

      const body = document.createElement("tbody");
      body.className = "term-body";
      asigs.forEach(function (a) {
        const fila = document.createElement("tr");
        fila.className = clasesFila(a);
        fila.dataset.id = String(a.id);
        fila.dataset.codigo = a.codigo;
        fila.dataset.estado = a.estado;
        const tdMain = document.createElement("td");
        tdMain.className = "course-main";
        const name = document.createElement("div");
        name.className = "course-name";
        name.textContent = a.nombre;
        const code = document.createElement("div");
        code.className = "course-code";
        code.textContent = a.codigo;
        tdMain.appendChild(name);
        tdMain.appendChild(code);
        const tdCredits = document.createElement("td");
        tdCredits.className = "course-credits";
        tdCredits.textContent = `${a.creditos} cr`;
        const tdEstado = document.createElement("td");
        tdEstado.className = "course-estado";
        tdEstado.appendChild(crearChip(a));
        const tdCalif = document.createElement("td");
        tdCalif.className = "course-calif";
        renderCalif(a, tdCalif);
        fila.appendChild(tdMain);
        fila.appendChild(tdCredits);
        fila.appendChild(tdEstado);
        fila.appendChild(tdCalif);
        body.appendChild(fila);
      });
      term.appendChild(body);
      cont.appendChild(term);
      sincronizarTerm(term, asigs);
    });
  }

  function actualizarCabecera(termEl, asigs) {
    const progress = termEl.querySelector(".term-progress");
    if (progress) progress.textContent = `· ${contarAprobadas(asigs)}/${asigs.length}`;
    const credits = termEl.querySelector(".term-credits");
    if (credits) credits.textContent = `${calcularCreditos(asigs)} cr`;
  }

  function sincronizarTerm(termEl, asigs, forzarExpandido) {
    actualizarCabecera(termEl, asigs);
    const tri = Number(termEl.dataset.trimestre);
    const colapsado = forzarExpandido ? false : colapsoEfectivo(tri, asigs);
    termEl.classList.toggle("term-collapsed", colapsado);
    termEl.classList.toggle("term-current", asigs.some(function (a) { return a.estado === "en-curso"; }));
    const head = termEl.querySelector(".term-head");
    if (head) head.setAttribute("aria-expanded", String(!colapsado));
  }

  function alternarTerm(termEl) {
    const tri = Number(termEl.dataset.trimestre);
    const data = typeof GAUD_DATA !== "undefined" ? GAUD_DATA.pensum : [];
    const asigs = asignaturasDePeriodo(data, tri);
    if (!asigs.length) return;
    overridesColapso.set(tri, !colapsoEfectivo(tri, asigs));
    sincronizarTerm(termEl, asigs);
  }

  let busquedaEl = null;
  let botonesFiltro = [];

  function estadoActivo() {
    const activo = botonesFiltro.find(function (b) { return b.classList.contains("activo"); });
    return activo ? activo.dataset.estado : "todas";
  }

  function marcarActivo(btn) {
    botonesFiltro.forEach(function (b) { b.classList.toggle("activo", b === btn); });
  }

  function aplicarFiltro(busqueda, estado, pensum) {
    if (typeof document === "undefined") return 0;
    const data = pensum || (typeof GAUD_DATA !== "undefined" ? GAUD_DATA.pensum : []);
    const visibles = new Set(filtrarPensum(data, busqueda, estado).map(function (a) { return String(a.id); }));
    let count = 0;
    document.querySelectorAll(".pensum-grid .course").forEach(function (c) {
      const visible = visibles.has(c.dataset.id);
      c.classList.toggle("oculto", !visible);
      if (visible) count++;
    });
    document.querySelectorAll(".pensum-grid .term").forEach(function (t) {
      const visible = t.querySelector(".course:not(.oculto)") !== null;
      t.classList.toggle("oculto", !visible);
    });
    const filtrando = String(busqueda || "").trim() !== "" || estado !== "todas";
    document.querySelectorAll(".pensum-grid .term").forEach(function (t) {
      if (t.classList.contains("oculto")) return;
      const asigs = data.filter(function (a) { return a.trimestre === Number(t.dataset.trimestre); });
      if (!asigs.length) return;
      sincronizarTerm(t, asigs, filtrando);
    });
    const countEl = document.querySelector(".pensum-count");
    if (countEl) countEl.textContent = `${count} asignaturas`;
    return count;
  }

  function aplicar() {
    return aplicarFiltro(busquedaEl ? busquedaEl.value : "", estadoActivo());
  }

  function enlazarGrid() {
    if (typeof document === "undefined") return;
    const cont = document.querySelector(".pensum-grid");
    if (!cont || gridEnlazado) return;
    gridEnlazado = true;
    cont.addEventListener("click", function (e) {
      const head = e.target.closest(".term-head");
      if (head) {
        const termEl = head.closest(".term");
        if (termEl) alternarTerm(termEl);
        return;
      }
      const fila = e.target.closest(".course");
      if (!fila || e.target.closest(".course-calif")) return;
      e.stopPropagation();
      if (menuEl && !menuEl.hidden && menuFila === fila) {
        cerrarMenu();
      } else {
        abrirMenu(fila);
      }
    });
    cont.addEventListener("keydown", function (e) {
      if (e.key !== "Enter" && e.key !== " ") return;
      const head = e.target.closest(".term-head");
      if (!head) return;
      e.preventDefault();
      const termEl = head.closest(".term");
      if (termEl) alternarTerm(termEl);
    });
  }

  function enlazarHerramientas() {
    if (typeof document === "undefined" || herramientasEnlazadas) return;
    busquedaEl = document.querySelector(".pensum-search input");
    botonesFiltro = Array.from(document.querySelectorAll(".pensum-filters button"));
    if (!busquedaEl && botonesFiltro.length === 0) return;
    herramientasEnlazadas = true;
    if (busquedaEl) busquedaEl.addEventListener("input", aplicar);
    botonesFiltro.forEach(function (btn) {
      btn.addEventListener("click", function () {
        marcarActivo(btn);
        aplicar();
      });
    });
    aplicar();
  }

  function render() {
    if (typeof document === "undefined") return;
    const pensum = obtenerPensum();
    renderCurrent(pensum.filter(function (a) { return a.estado === "en-curso"; }));
    renderPensum(pensum);
    enlazarGrid();
    enlazarHerramientas();
    aplicar();
  }

  async function cargar() {
    if (!API || typeof GAUD_DATA === "undefined" || !GAUD_DATA.usuario) return;
    const id = String(GAUD_DATA.usuario.id);
    if (usuarioCargado === id || pidiendo.has(id)) return;
    pidiendo.add(id);
    try {
      const data = await API.get("/asignaturas.php");
      if (usuarioCargado === id) return;
      GAUD_DATA.pensum = Array.isArray(data) ? data : [];
      usuarioCargado = id;
      render();
    } catch (e) {
      if (e && e.status === 401) {
        usuarioCargado = null;
        return;
      }
      window.alert((e && e.message) || "No se pudo cargar el pensum.");
    } finally {
      pidiendo.delete(id);
    }
  }

  function enlazar() {
    if (typeof document === "undefined" || typeof GAUD_DATA === "undefined") return;
    document.addEventListener("gaud:sesion", function (e) {
      const sesion = e.detail && e.detail.sesion;
      if (sesion && sesion.usuario) {
        usuarioCargado = null;
        cargar();
      }
    });
    if (GAUD_DATA.usuario) cargar();
  }

  return {
    ESTADOS_VALIDOS,
    ORDEN_MENU,
    ETIQUETA_ESTADOS,
    LETRAS_CALIF,
    RANGOS_CALIF,
    normalizar,
    obtenerPensum,
    buscarPorId,
    guardarCambios,
    claseEstado,
    claseCalificacion,
    clasesFila,
    asignaturasDePeriodo,
    calcularCreditos,
    contarAprobadas,
    todasAprobadas,
    todasConCalificacion,
    colapsoEfectivo,
    agruparPorTrimestre,
    coincideBusqueda,
    coincideEstado,
    filtrarPensum,
    renderCurrent,
    renderCalif,
    crearChip,
    actualizarFila,
    crearMenu,
    abrirMenu,
    cerrarMenu,
    elegirEstado,
    renderPensum,
    actualizarCabecera,
    sincronizarTerm,
    alternarTerm,
    estadoActivo,
    marcarActivo,
    aplicarFiltro,
    aplicar,
    enlazarGrid,
    enlazarHerramientas,
    render,
    cargar,
    enlazar
  };
})();

if (typeof document !== "undefined") {
  document.addEventListener("DOMContentLoaded", function () { GAUD_Asignaturas.enlazar(); });
}
