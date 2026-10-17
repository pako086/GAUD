const GAUD_Asignaturas = (function () {
  const API = typeof window !== "undefined" ? window.GAUD_API : null;
  const ESTADOS_VALIDOS = ["aprobada", "en-curso", "pendiente"];
  const ORDEN_MENU = ["pendiente", "en-curso", "aprobada"];
  const ETIQUETA_ESTADOS = { pendiente: "Pendiente", "en-curso": "En curso", aprobada: "Aprobada" };
  const LETRAS_CALIF = ["A", "B", "C"];
  const RANGOS_CALIF = { A: "A · 90-100", B: "B · 80-89", C: "C · 70-79" };

  function etiquetaPeriodo(n) {
    const u = typeof GAUD_DATA !== "undefined" ? GAUD_DATA.usuario : null;
    const tipo = String((u && u.periodo) || "trimestres").toLowerCase();
    const singular = tipo === "cuatrimestres" ? "Cuatrimestre" : tipo === "semestres" ? "Semestre" : "Trimestre";
    return `${singular} ${n}`;
  }

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

  function companerosDe(a) {
    return Array.isArray(a.companeros) ? a.companeros : [];
  }

  function prerrequisitosDe(a) {
    return Array.isArray(a.prerrequisitos) ? a.prerrequisitos : [];
  }

  function grupoCorrequisitosLocal(a) {
    const vistos = new Set();
    const cola = [a];
    const grupo = [];
    while (cola.length) {
      const x = cola.shift();
      const id = String(x.id);
      if (vistos.has(id)) continue;
      vistos.add(id);
      grupo.push(x);
      companerosDe(x).forEach(function (c) {
        const real = buscarPorId(c.id);
        if (real && !vistos.has(String(real.id))) cola.push(real);
      });
    }
    return grupo;
  }

  function sincronizarCompaneros() {
    obtenerPensum().forEach(function (a) {
      companerosDe(a).forEach(function (c) {
        const real = buscarPorId(c.id);
        if (real) c.estado = real.estado;
      });
      prerrequisitosDe(a).forEach(function (r) {
        const real = buscarPorId(r.id);
        if (real) r.estado = real.estado;
      });
    });
  }

  function esOptativa(a) {
    return !!(a && a.tipo === "optativa");
  }

  function esSlot(a) {
    return esOptativa(a) && Number(a.periodo) > 0;
  }

  function esPool(a) {
    return esOptativa(a) && Number(a.periodo) === 0;
  }

  function optativaDeSlot(slot) {
    if (!esSlot(slot)) return null;
    return obtenerPensum().find(function (p) {
      return esPool(p) && p.estado !== "pendiente" && Number(p.periodo_inscrito) === Number(slot.periodo);
    }) || null;
  }

  function slotDeOptativa(p) {
    if (!esPool(p) || p.periodo_inscrito === null || p.periodo_inscrito === undefined) return null;
    return obtenerPensum().find(function (a) {
      return esSlot(a) && Number(a.periodo) === Number(p.periodo_inscrito);
    }) || null;
  }

  function datosDeSlot(a) {
    return esSlot(a) ? optativaDeSlot(a) || a : a;
  }

  function bloqueosPrerrequisitos(a) {
    const bloqueos = [];
    const prereqs = prerrequisitosDe(a);
    if (prereqs.length) {
      prereqs.forEach(function (r) {
        const real = buscarPorId(r.id);
        const estadoRel = real ? real.estado : (r.estado || "pendiente");
        if (estadoRel !== "aprobada") {
          bloqueos.push({ tipo: "prerrequisito", codigo: r.codigo, nombre: r.nombre });
        }
      });
    } else {
      (a.bloqueos || []).forEach(function (b) {
        if (b && b.tipo === "prerrequisito") bloqueos.push(b);
      });
    }
    return bloqueos;
  }

  function bloqueosPara(a, estado) {
    if (!a || estado === "pendiente" || estado === a.estado) return [];
    const bloqueos = [];
    const vistos = new Set();
    const agregar = function (b) {
      const clave = b.tipo + ":" + b.codigo;
      if (vistos.has(clave)) return;
      vistos.add(clave);
      bloqueos.push(b);
    };
    const grupo = grupoCorrequisitosLocal(a);
    grupo.forEach(function (g) {
      bloqueosPrerrequisitos(g).forEach(agregar);
    });
    return bloqueos;
  }

  function esBloqueada(a) {
    return a.estado === "pendiente" && bloqueosPara(a, "en-curso").length > 0;
  }

  function describirBloqueos(bloqueos) {
    if (!bloqueos.length) return "";
    const partes = bloqueos.map(function (b) {
      return b.tipo === "correquisito" ? "correquisito " + b.codigo : "prerrequisito " + b.codigo;
    });
    return "Requiere: " + partes.join(", ");
  }

  function animarShake(el) {
    if (!el) return;
    el.classList.remove("shake");
    void el.offsetWidth;
    el.classList.add("shake");
    setTimeout(function () { el.classList.remove("shake"); }, 550);
  }

  function actualizarFilaSlot(slot) {
    const fila = document.querySelector(`.pensum-grid .course[data-id="${slot.id}"]`);
    if (!fila) return;
    actualizarFila(fila, datosDeSlot(slot));
    const termEl = fila.closest(".term");
    if (termEl)
      sincronizarTerm(termEl, asignaturasDePeriodo(obtenerPensum(), Number(termEl.dataset.periodo)));
  }

  function actualizarUIAsignatura(a) {
    if (typeof document === "undefined") return;
    if (esPool(a)) {
      const item = document.querySelector(`.pool-grid .pool-item[data-id="${a.id}"]`);
      if (item) actualizarItemPool(item, a);
      const slot = slotDeOptativa(a);
      if (slot) actualizarFilaSlot(slot);
    } else {
      const fila = document.querySelector(`.pensum-grid .course[data-id="${a.id}"]`);
      if (fila) {
        actualizarFila(fila, datosDeSlot(a));
        const termEl = fila.closest(".term");
        if (termEl)
          sincronizarTerm(termEl, asignaturasDePeriodo(obtenerPensum(), Number(termEl.dataset.periodo)));
      }
    }
    renderCurrent(obtenerPensum().filter(function (x) { return x.estado === "en-curso"; }));
    aplicar();
  }

  function recalcularUI() {
    if (typeof document === "undefined") return;
    sincronizarCompaneros();
    obtenerPensum().forEach(function (a) {
      if (esPool(a)) {
        const item = document.querySelector(`.pool-grid .pool-item[data-id="${a.id}"]`);
        if (item) actualizarItemPool(item, a);
        return;
      }
      const fila = document.querySelector(`.pensum-grid .course[data-id="${a.id}"]`);
      if (fila) actualizarFila(fila, datosDeSlot(a));
    });
    document.querySelectorAll(".pensum-grid .term").forEach(function (termEl) {
      sincronizarTerm(termEl, asignaturasDePeriodo(obtenerPensum(), Number(termEl.dataset.periodo)));
    });
    renderCurrent(obtenerPensum().filter(function (x) { return x.estado === "en-curso"; }));
    aplicar();
  }

  function revertir(a, anterior) {
    a.estado = anterior.estado;
    a.calificacion = anterior.calificacion;
    if (anterior.periodo_inscrito !== undefined) a.periodo_inscrito = anterior.periodo_inscrito;
    recalcularUI();
  }

  function cerrarModal(overlay) {
    if (overlay && overlay.parentNode) overlay.parentNode.removeChild(overlay);
  }

  function aplicarCambiosEstado(grupo, estado, principal) {
    const main = principal || grupo[0];
    const anteriores = new Map();
    grupo.forEach(function (g) {
      anteriores.set(String(g.id), snapshot(g));
    });
    const califPrincipal = LETRAS_CALIF.includes(main.calificacion) ? main.calificacion : null;
    grupo.forEach(function (g) {
      g.estado = estado;
      if (estado === "aprobada") {
        g.calificacion = g === main ? califPrincipal : (LETRAS_CALIF.includes(g.calificacion) ? g.calificacion : null);
      } else {
        g.calificacion = null;
      }
    });
    recalcularUI();
    if (grupo.length > 1) {
      guardarGrupo(grupo, main, anteriores);
    } else {
      guardarCambios(main, anteriores.get(String(main.id)));
    }
  }

  function cambiarCalificacion(a, letra) {
    if (a.estado !== "aprobada") return;
    const anterior = snapshot(a);
    a.calificacion = a.calificacion === letra ? null : letra;
    recalcularUI();
    guardarCambios(a, anterior);
  }

  function snapshot(a) {
    return { estado: a.estado, calificacion: a.calificacion, periodo_inscrito: a.periodo_inscrito };
  }

  async function guardarCambios(a, anterior) {
    if (!API || !a.id) return;
    const clave = String(a.id);
    if (guardando.has(clave)) return;
    guardando.add(clave);
    try {
      const payload = {
        id: Number(a.id),
        estado: a.estado,
        calificacion: a.calificacion
      };
      if (esPool(a) && a.periodo_inscrito) payload.periodo = Number(a.periodo_inscrito);
      const respuesta = await API.put("/asignaturas.php", payload);
      if (respuesta && typeof respuesta === "object") {
        if (Array.isArray(respuesta.grupo)) {
          aplicarGrupoRespuesta([a], respuesta.grupo);
        } else {
          if (typeof respuesta.estado === "string") a.estado = respuesta.estado;
          if (respuesta.calificacion !== undefined) a.calificacion = respuesta.calificacion;
        }
        if (Array.isArray(respuesta.afectados)) {
          aplicarGrupoRespuesta(null, respuesta.afectados);
        }
      }
    } catch (e) {
      revertir(a, anterior);
      window.alert((e && e.message) || "No se pudo guardar la asignatura.");
    } finally {
      guardando.delete(clave);
    }
  }

  function aplicarGrupoRespuesta(grupo, lista) {
    if (!Array.isArray(lista) || lista.length === 0) return;
    const mapa = new Map();
    lista.forEach(function (item) {
      if (item && item.id !== undefined) mapa.set(String(item.id), item);
    });
    let cambio = false;
    const objetivos = Array.isArray(grupo) && grupo.length > 0 ? grupo : obtenerPensum();
    objetivos.forEach(function (g) {
      const item = mapa.get(String(g.id));
      if (!item) return;
      if (item.estado !== g.estado) {
        g.estado = item.estado;
        cambio = true;
      }
      if (item.calificacion !== g.calificacion) {
        g.calificacion = item.calificacion;
        cambio = true;
      }
    });
    if (cambio) recalcularUI();
  }

  async function guardarGrupo(grupo, principal, anteriores) {
    if (!API || !principal.id) return;
    const claves = grupo.map(function (g) { return String(g.id); });
    if (claves.some(function (c) { return guardando.has(c); })) return;
    claves.forEach(function (c) { guardando.add(c); });
    try {
      const payload = {
        id: Number(principal.id),
        estado: principal.estado,
        calificacion: principal.calificacion,
        con_correquisitos: true
      };
      if (esPool(principal) && principal.periodo_inscrito) payload.periodo = Number(principal.periodo_inscrito);
      const respuesta = await API.put("/asignaturas.php", payload);
      if (respuesta && typeof respuesta === "object") {
        if (Array.isArray(respuesta.grupo)) {
          aplicarGrupoRespuesta(grupo, respuesta.grupo);
        } else {
          const real = buscarPorId(principal.id);
          if (real) {
            if (typeof respuesta.estado === "string") real.estado = respuesta.estado;
            if (respuesta.calificacion !== undefined) real.calificacion = respuesta.calificacion;
            recalcularUI();
          }
        }
        if (Array.isArray(respuesta.afectados)) {
          aplicarGrupoRespuesta(null, respuesta.afectados);
        }
      }
    } catch (e) {
      grupo.forEach(function (g) {
        const prev = anteriores.get(String(g.id));
        if (!prev) return;
        g.estado = prev.estado;
        g.calificacion = prev.calificacion;
        if (prev.periodo_inscrito !== undefined) g.periodo_inscrito = prev.periodo_inscrito;
      });
      recalcularUI();
      window.alert((e && e.message) || "No se pudo guardar el grupo de asignaturas.");
    } finally {
      claves.forEach(function (c) { guardando.delete(c); });
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
    const extra = [calif, esBloqueada(a) ? "bloqueada" : "", companerosDe(a).length > 0 ? "grupo-correquisito" : ""].filter(Boolean).join(" ");
    return (base + " " + extra).trim();
  }

  function asignaturasDePeriodo(pensum, periodo) {
    return pensum.filter(function (a) { return a.periodo === periodo; });
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

  function colapsoEfectivo(periodo, asigs) {
    const ov = overridesColapso.get(periodo);
    return ov !== undefined ? ov : todasConCalificacion(asigs);
  }

  function agruparPorPeriodo(pensum) {
    const mapa = new Map();
    pensum.forEach(function (a) {
      if (!mapa.has(a.periodo)) mapa.set(a.periodo, []);
      mapa.get(a.periodo).push(a);
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
      const tri = u && u.periodo_actual ? Number(u.periodo_actual) : (asignaturas[0] ? Number(asignaturas[0].periodo_inscrito || asignaturas[0].periodo) : null);
      badge.textContent = tri ? etiquetaPeriodo(tri) : "—";
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
        cambiarCalificacion(a, letra);
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
    const oculto = fila.classList.contains("oculto");
    fila.className = (clasesFila(a) + (oculto ? " oculto" : "")).trim();
    fila.dataset.estado = a.estado;
    const lock = fila.querySelector(".lock-icon");
    if (lock) {
      const bloqueada = esBloqueada(a);
      lock.hidden = !bloqueada;
      lock.title = bloqueada ? describirBloqueos(bloqueosPara(a, "en-curso")) : "";
    }
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
    const d = datosDeSlot(a);
    menuEl.querySelectorAll(".estado-opt").forEach(function (opt) {
      const estadoOpt = opt.dataset.estado;
      const activa = estadoOpt === d.estado;
      const bloqueos = activa ? [] : bloqueosPara(a, estadoOpt);
      opt.classList.toggle("activo", activa);
      opt.classList.toggle("deshabilitada", bloqueos.length > 0);
      opt.setAttribute("aria-checked", String(activa));
      opt.setAttribute("aria-disabled", String(bloqueos.length > 0));
      opt.title = bloqueos.length ? describirBloqueos(bloqueos) : "";
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
    if (!a) return;
    const d = datosDeSlot(a);
    if (d.estado === estado) return;
    const bloqueos = bloqueosPara(a, estado);
    if (bloqueos.length) {
      animarShake(fila);
      return;
    }
    if (esSlot(a)) {
      elegirEstadoSlot(a, estado);
      return;
    }
    aplicarCambiosEstado(grupoCorrequisitosLocal(a), estado, a);
  }

  function elegirEstadoSlot(a, estado) {
    const opt = optativaDeSlot(a);
    if (estado === "pendiente") {
      if (opt) {
        const anterior = snapshot(opt);
        opt.estado = "pendiente";
        opt.calificacion = null;
        opt.periodo_inscrito = null;
        recalcularUI();
        guardarCambios(opt, anterior);
      }
      return;
    }
    if (opt) {
      const anterior = snapshot(opt);
      opt.estado = estado;
      if (estado !== "aprobada") opt.calificacion = null;
      recalcularUI();
      guardarCambios(opt, anterior);
      return;
    }
    abrirModalOptativas(a, estado);
  }

  function abrirModalOptativas(slot, estado) {
    const overlay = document.createElement("div");
    overlay.className = "overlay";
    const cont = document.createElement("div");
    cont.className = "contenidoT modal";
    cont.setAttribute("role", "dialog");
    cont.setAttribute("aria-modal", "true");
    const h2 = document.createElement("h2");
    h2.textContent = "Elegir optativa";
    const p = document.createElement("p");
    p.textContent = "Selecciona la optativa para " + etiquetaPeriodo(Number(slot.periodo)) + ".";
    const lista = document.createElement("div");
    lista.className = "pool-lista";
    const pools = obtenerPensum().filter(function (x) { return esPool(x); })
      .sort(function (x, y) { return String(x.codigo).localeCompare(String(y.codigo)); });
    if (!pools.length) {
      const vacio = document.createElement("p");
      vacio.textContent = "No hay optativas disponibles.";
      lista.appendChild(vacio);
    }
    pools.forEach(function (x) {
      const btn = document.createElement("button");
      btn.type = "button";
      const ocupada = x.periodo_inscrito !== null && x.periodo_inscrito !== undefined;
      btn.className = "pool-opt" + (ocupada ? " ocupada" : "");
      btn.textContent = `${x.codigo} · ${x.nombre} (${x.creditos} cr)`;
      if (ocupada) btn.title = "Inscrita en " + etiquetaPeriodo(Number(x.periodo_inscrito));
      btn.addEventListener("click", function () { confirmarOptativa(overlay, slot, estado, x); });
      lista.appendChild(btn);
    });
    const btns = document.createElement("div");
    btns.className = "button-container";
    const cancel = document.createElement("button");
    cancel.type = "button";
    cancel.className = "btn btn-outline";
    cancel.textContent = "Cancelar";
    cancel.addEventListener("click", function () { cerrarModal(overlay); });
    btns.appendChild(cancel);
    cont.appendChild(h2);
    cont.appendChild(p);
    cont.appendChild(lista);
    cont.appendChild(btns);
    overlay.appendChild(cont);
    overlay.addEventListener("click", function (e) {
      if (e.target === overlay) cerrarModal(overlay);
    });
    document.body.appendChild(overlay);
  }

  function confirmarOptativa(overlay, slot, estado, pool) {
    cerrarModal(overlay);
    const anterior = snapshot(pool);
    pool.estado = estado;
    pool.calificacion = null;
    pool.periodo_inscrito = Number(slot.periodo);
    recalcularUI();
    guardarCambios(pool, anterior);
  }

  function renderPool(pensum) {
    if (typeof document === "undefined") return;
    const cont = document.querySelector(".pool-grid");
    if (!cont) return;
    cont.innerHTML = "";
    const pools = pensum.filter(function (a) { return esPool(a); })
      .sort(function (x, y) { return String(x.codigo).localeCompare(String(y.codigo)); });
    pools.forEach(function (p) {
      const item = document.createElement("div");
      item.className = "pool-item";
      item.dataset.id = String(p.id);
      const code = document.createElement("span");
      code.className = "pool-code";
      code.textContent = p.codigo;
      const name = document.createElement("span");
      name.className = "pool-name";
      name.textContent = p.nombre;
      const credits = document.createElement("span");
      credits.className = "pool-credits";
      credits.textContent = `${p.creditos} cr`;
      const periodo = document.createElement("span");
      periodo.className = "pool-periodo";
      item.appendChild(code);
      item.appendChild(name);
      item.appendChild(credits);
      item.appendChild(periodo);
      cont.appendChild(item);
      actualizarItemPool(item, p);
    });
  }

  function actualizarItemPool(item, p) {
    const oculto = item.classList.contains("oculto");
    item.className = "pool-item st-" + claseEstado(p.estado) + (oculto ? " oculto" : "");
    const periodo = item.querySelector(".pool-periodo");
    if (periodo) {
      const slot = slotDeOptativa(p);
      periodo.textContent = slot ? etiquetaPeriodo(Number(slot.periodo)) : "";
      periodo.hidden = !slot;
    }
  }

  function renderPensum(pensum) {
    if (typeof document === "undefined") return;
    const cont = document.querySelector(".pensum-grid");
    if (!cont) return;
    cont.innerHTML = "";
    const grid = pensum.filter(function (a) { return !esPool(a); });
    agruparPorPeriodo(grid).forEach(function (asigs, tri) {
      const term = document.createElement("table");
      term.className = "term";
      term.dataset.periodo = tri;

      const head = document.createElement("thead");
      head.className = "term-head";
      head.setAttribute("role", "button");
      head.setAttribute("tabindex", "0");
      head.setAttribute("aria-expanded", "true");
      const headRow = document.createElement("tr");
      const thMain = document.createElement("th");
      const num = document.createElement("span");
      num.className = "term-num";
      num.textContent = etiquetaPeriodo(tri);
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
        const d = datosDeSlot(a);
        const fila = document.createElement("tr");
        fila.className = clasesFila(d);
        fila.dataset.id = String(a.id);
        fila.dataset.codigo = d.codigo;
        fila.dataset.estado = d.estado;
        const tdMain = document.createElement("td");
        tdMain.className = "course-main";
        const name = document.createElement("div");
        name.className = "course-name";
        name.textContent = d.nombre;
        const code = document.createElement("div");
        code.className = "course-code";
        code.textContent = d.codigo;
        tdMain.appendChild(name);
        tdMain.appendChild(code);
        const tdCredits = document.createElement("td");
        tdCredits.className = "course-credits";
        tdCredits.textContent = `${d.creditos} cr`;
        const tdEstado = document.createElement("td");
        tdEstado.className = "course-estado";
        const lock = document.createElement("img");
        lock.className = "lock-icon";
        lock.src = "icon/lock.png";
        lock.alt = "";
        lock.hidden = !esBloqueada(d);
        lock.title = esBloqueada(d) ? describirBloqueos(bloqueosPara(d, "en-curso")) : "";
        const chip = crearChip(d);
        const estadoWrap = document.createElement("span");
        estadoWrap.className = "estado-lock";
        estadoWrap.appendChild(chip);
        estadoWrap.appendChild(lock);
        tdEstado.appendChild(estadoWrap);
        const tdCalif = document.createElement("td");
        tdCalif.className = "course-calif";
        renderCalif(d, tdCalif);
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
    const tri = Number(termEl.dataset.periodo);
    const colapsado = forzarExpandido ? false : colapsoEfectivo(tri, asigs);
    termEl.classList.toggle("term-collapsed", colapsado);
    termEl.classList.toggle("term-current", asigs.some(function (a) { return a.estado === "en-curso"; }));
    const head = termEl.querySelector(".term-head");
    if (head) head.setAttribute("aria-expanded", String(!colapsado));
  }

  function alternarTerm(termEl) {
    const tri = Number(termEl.dataset.periodo);
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
    document.querySelectorAll(".pool-grid .pool-item").forEach(function (c) {
      c.classList.toggle("oculto", !visibles.has(c.dataset.id));
    });
    const poolSection = document.querySelector(".pool-section");
    if (poolSection) {
      const poolVisible = document.querySelector(".pool-grid .pool-item:not(.oculto)") !== null;
      poolSection.classList.toggle("oculto", !poolVisible);
    }
    const filtrando = String(busqueda || "").trim() !== "" || estado !== "todas";
    document.querySelectorAll(".pensum-grid .term").forEach(function (t) {
      if (t.classList.contains("oculto")) return;
      const asigs = data.filter(function (a) { return a.periodo === Number(t.dataset.periodo); });
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
      const a = buscarPorId(fila.dataset.id);
      if (a && esBloqueada(datosDeSlot(a))) {
        animarShake(fila);
        return;
      }
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
    renderPool(pensum);
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
    companerosDe,
    grupoCorrequisitosLocal,
    prerrequisitosDe,
    sincronizarCompaneros,
    bloqueosPrerrequisitos,
    recalcularUI,
    esOptativa,
    esSlot,
    esPool,
    optativaDeSlot,
    slotDeOptativa,
    datosDeSlot,
    bloqueosPara,
    esBloqueada,
    describirBloqueos,
    animarShake,
    actualizarUIAsignatura,
    revertir,
    cerrarModal,
    aplicarCambiosEstado,
    cambiarCalificacion,
    guardarCambios,
    aplicarGrupoRespuesta,
    guardarGrupo,
    claseEstado,
    claseCalificacion,
    clasesFila,
    asignaturasDePeriodo,
    calcularCreditos,
    contarAprobadas,
    todasAprobadas,
    todasConCalificacion,
    colapsoEfectivo,
    agruparPorPeriodo,
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
