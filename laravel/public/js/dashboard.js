const GAUD_Dashboard = (function () {
  const API = typeof window !== "undefined" ? window.GAUD_API : null;
  const TOTAL_PERIODOS = 16;

  function elemento(id) {
    if (typeof document === "undefined") return null;
    return document.getElementById(id);
  }

  function texto(id, valor) {
    const el = elemento(id);
    if (el) el.textContent = String(valor);
  }

  function letraPromedio(d) {
    if (!d || !d.aprobadas) return "—";
    const indice = Number(d.indice_academico) || 0;
    if (indice >= 3.5) return "A";
    if (indice >= 2.5) return "B";
    return "C";
  }

  function poblarEstadisticas(d) {
    texto("indice-academico-dashboard", Number(d.indice_academico || 0).toFixed(2));
    texto("creditos-ganados-dashboard", d.creditos_ganados);
    texto("total-creditos-dashboard", d.total_creditos);
    texto("creditos-restantes-dashboard", Math.max((Number(d.total_creditos) || 0) - (Number(d.creditos_ganados) || 0), 0));
    texto("aprobadas-dashboard", d.aprobadas);
    texto("en-curso-dashboard", d.en_curso);
    texto("pendientes-dashboard", d.pendientes);
    texto("periodo-actual-dashboard", d.periodo_actual);
    texto("periodos-restantes-dashboard", Math.max(TOTAL_PERIODOS - (Number(d.periodo_actual) || 0), 0));
  }

  function poblarRendimiento(d) {
    texto("letra-promedio-dashboard", letraPromedio(d));
    const dist = d.distribucion || { A: 0, B: 0, C: 0 };
    const total = (Number(dist.A) || 0) + (Number(dist.B) || 0) + (Number(dist.C) || 0);
    ["A", "B", "C"].forEach(function (letra) {
      const cuenta = Number(dist[letra]) || 0;
      const seg = elemento("dist-" + letra + "-dashboard");
      if (seg) seg.style.width = (total > 0 ? (cuenta / total) * 100 : 0) + "%";
    });
  }

  function poblarProgreso(d) {
    const ganados = Number(d.creditos_ganados) || 0;
    const total = Number(d.total_creditos) || 0;
    const restantes = Math.max(total - ganados, 0);
    const progreso = total > 0 ? Math.round((ganados / total) * 100) : 0;

    const fill = elemento("dashboard-progreso-fill");
    if (fill) fill.style.width = progreso + "%";
    texto("dashboard-progreso-badge", progreso + "%");
    texto("dashboard-progreso-ganados", ganados + " créditos cursados");
    texto("dashboard-progreso-restantes", restantes + " créditos restantes");
    texto("dashboard-progreso-total", "de " + total + " créditos");
  }

  function poblarPeriodo() {
    const U = window.GAUD_Usuarios;
    const usuario = typeof GAUD_DATA !== "undefined" ? GAUD_DATA.usuario : null;
    if (U && usuario) texto("rango-periodo", U.periodoDelUsuario(usuario).nombre);
  }

  function renderPeriodo(asignaturas) {
    const cont = document.getElementById("lista-periodo");
    if (!cont) return;
    cont.innerHTML = "";

    const enCurso = asignaturas.filter(function (a) { return a.estado === "en-curso"; });
    if (!enCurso.length) {
      const item = document.createElement("div");
      item.className = "subject-list-item";
      const info = document.createElement("div");
      info.className = "subject-info";
      const h4 = document.createElement("h4");
      h4.textContent = "Sin asignaturas en curso";
      const p = document.createElement("p");
      p.textContent = "No tienes asignaturas activas en este período.";
      info.appendChild(h4);
      info.appendChild(p);
      item.appendChild(info);
      cont.appendChild(item);
      return;
    }

    enCurso.forEach(function (a) {
      const item = document.createElement("div");
      item.className = "subject-list-item";
      const info = document.createElement("div");
      info.className = "subject-info";
      const h4 = document.createElement("h4");
      h4.textContent = `${a.codigo} - ${a.nombre}`;
      const p = document.createElement("p");
      p.textContent = `${a.creditos} créditos`;
      info.appendChild(h4);
      info.appendChild(p);
      const badge = document.createElement("span");
      badge.className = "badge badge-success";
      badge.textContent = "Cursando";
      item.appendChild(info);
      item.appendChild(badge);
      cont.appendChild(item);
    });
  }

  function cargar() {
    if (!API || typeof GAUD_DATA === "undefined" || !GAUD_DATA.usuario) return;
    Promise.all([
      API.get("/dashboard.php"),
      API.get("/asignaturas.php")
    ]).then(function (res) {
      const dashboard = res[0];
      const asignaturas = res[1];
      GAUD_DATA.dashboard = dashboard;
      GAUD_DATA.pensum = asignaturas;
      poblarEstadisticas(dashboard);
      poblarRendimiento(dashboard);
      poblarProgreso(dashboard);
      poblarPeriodo();
      renderPeriodo(asignaturas);
    }).catch(function () {});
  }

  function enlazar() {
    if (typeof GAUD_DATA === "undefined") return;
    if (GAUD_DATA.usuario) cargar();
    document.addEventListener("gaud:sesion", function (e) {
      if (e.detail && e.detail.sesion) cargar();
    });
  }

  return {
    cargar: cargar,
    enlazar: enlazar
  };
})();

if (typeof document !== "undefined") {
  document.addEventListener("DOMContentLoaded", function () { GAUD_Dashboard.enlazar(); });
}
