const GAUD_Header = (function () {
  const mq = typeof window !== "undefined" && window.matchMedia
    ? window.matchMedia("(max-width: 768px)")
    : null;

  let fab = null;
  let fabBoton = null;
  let fabMenu = null;
  let enlazado = false;

  function iniciales(nombre) {
    if (!nombre) return "?";
    const partes = String(nombre).trim().split(/\s+/).filter(Boolean);
    if (partes.length === 0) return "?";
    return partes.slice(0, 2).map(function (p) { return p.charAt(0).toUpperCase(); }).join("");
  }

  function nombreCorto(nombre) {
    if (!nombre) return "";
    const partes = String(nombre).trim().split(/\s+/).filter(Boolean);
    if (partes.length < 2) return partes[0] || "";
    return `${partes[0]} ${partes[partes.length - 1]}`;
  }

  function sidebarOculto() {
    if (mq) return mq.matches;
    return typeof window !== "undefined" && window.innerWidth <= 768;
  }

  function crearDropdown() {
    const menu = document.createElement("div");
    menu.className = "dropdown";
    menu.innerHTML = [
      '<div class="dropdown-header">',
      '  <div class="dropdown-avatar">?</div>',
      '  <div class="dropdown-user">',
      '    <div class="dropdown-name">—</div>',
      '    <div class="dropdown-email">—</div>',
      '  </div>',
      '</div>',
      '<a class="dropdown-item" data-pagina-link="dashboard" href="dashboard-tommisan.html">',
      '  <img class="dropdown-icon" src="icon/tachometer-average.png" alt=""> Dashboard',
      '</a>',
      '<a class="dropdown-item" data-pagina-link="asignaturas" href="asignaturas.html">',
      '  <img class="dropdown-icon" src="icon/books.png" alt=""> Asignaturas',
      '</a>',
      '<a class="dropdown-item" data-pagina-link="perfil" href="perfil.html">',
      '  <img class="dropdown-icon" src="icon/user.png" alt=""> Mi Perfil',
      '</a>',
      '<div class="dropdown-sep"></div>',
      '<a class="dropdown-item dropdown-danger" data-logout href="#">',
      '  <img class="dropdown-icon" src="icon/user-logout.png" alt=""> Cerrar sesión',
      '</a>'
    ].join("");
    return menu;
  }

  function crearMenu() {
    const fragmento = document.createDocumentFragment();

    const chevron = document.createElement("span");
    chevron.className = "user-chevron";
    chevron.setAttribute("aria-hidden", "true");
    chevron.textContent = "▾";
    fragmento.appendChild(chevron);

    fragmento.appendChild(crearDropdown());
    return fragmento;
  }

  function crearFab() {
    const contenedor = document.createElement("div");
    contenedor.className = "user-fab";

    const boton = document.createElement("button");
    boton.type = "button";
    boton.className = "user-fab__boton";
    boton.setAttribute("aria-haspopup", "true");
    boton.setAttribute("aria-expanded", "false");
    boton.setAttribute("aria-label", "Menú de usuario");

    const avatar = document.createElement("span");
    avatar.className = "user-avatar";
    avatar.textContent = "?";
    boton.appendChild(avatar);

    contenedor.appendChild(boton);
    contenedor.appendChild(crearDropdown());
    return contenedor;
  }

  function alternarMenu(menu, contenedor, ariaEl) {
    if (!menu) return false;
    const abierto = !menu.classList.contains("abierto");
    menu.classList.toggle("abierto", abierto);
    if (contenedor) {
      contenedor.classList.toggle("menu-abierto", abierto);
    }
    if (ariaEl) {
      ariaEl.setAttribute("aria-expanded", String(abierto));
    }
    return abierto;
  }

  function cerrarMenu(menu, contenedor, ariaEl) {
    if (!menu) return;
    menu.classList.remove("abierto");
    if (contenedor) {
      contenedor.classList.remove("menu-abierto");
    }
    if (ariaEl) {
      ariaEl.setAttribute("aria-expanded", "false");
    }
  }

  function cerrarSesion() {
    const U = window.GAUD_Usuarios;
    if (U && U.cerrarSesion) {
      U.cerrarSesion().then(function () {
        window.location.href = "index.html";
      }).catch(function () {
        window.location.href = "index.html";
      });
      return;
    }
    window.location.href = "index.html";
  }

  function actualizarEstado() {
    if (!document.body) return;
    const oculto = sidebarOculto();
    document.body.classList.toggle("sidebar-oculto", oculto);
    if (!oculto && fab && fabMenu) {
      cerrarMenu(fabMenu, fab, fabBoton);
    }
  }

  function observarMedia() {
    if (mq) {
      if (typeof mq.addEventListener === "function") {
        mq.addEventListener("change", actualizarEstado);
      } else if (typeof mq.addListener === "function") {
        mq.addListener(actualizarEstado);
      }
    } else if (typeof window !== "undefined") {
      window.addEventListener("resize", actualizarEstado);
    }
    actualizarEstado();
  }

  function pintarPeriodo() {
    const el = document.getElementById("topbar-periodo");
    if (!el) return;
    const F = typeof GAUD_Fechas !== "undefined" ? GAUD_Fechas : null;
    if (F && typeof F.rangoTrimestreActual === "function") {
      el.textContent = F.rangoTrimestreActual().rango;
      return;
    }
    el.textContent = "—";
  }

  function pintarUsuario() {
    const usuario = typeof GAUD_DATA !== "undefined" && GAUD_DATA.usuario ? GAUD_DATA.usuario : null;
    const inicialesUsuario = usuario ? (usuario.iniciales || iniciales(usuario.nombre)) : "?";

    document.querySelectorAll(".sidebar .user-mini").forEach(function (userMini) {
      const nombreEl = userMini.querySelector(".user-name");
      const rolEl = userMini.querySelector(".user-role");
      const avatar = userMini.querySelector(".user-avatar");
      if (usuario) {
        if (nombreEl) nombreEl.textContent = nombreCorto(usuario.nombre);
        if (rolEl) rolEl.textContent = usuario.carrera || "Estudiante";
        if (avatar) avatar.innerHTML = inicialesUsuario;
      }
    });

    if (fab) {
      const fabAvatar = fab.querySelector(".user-avatar");
      if (fabAvatar) fabAvatar.textContent = inicialesUsuario;
    }

    document.querySelectorAll(".dropdown").forEach(function (menu) {
      const dropAvatar = menu.querySelector(".dropdown-avatar");
      const dropName = menu.querySelector(".dropdown-name");
      const dropEmail = menu.querySelector(".dropdown-email");
      if (dropAvatar) dropAvatar.textContent = inicialesUsuario;
      if (dropName) dropName.textContent = usuario ? (usuario.nombre || "—") : "—";
      if (dropEmail) dropEmail.textContent = usuario ? (usuario.email || "—") : "—";
    });

    const pagina = document.body ? document.body.dataset.pagina : null;
    document.querySelectorAll(".dropdown-item[data-pagina-link]").forEach(function (a) {
      a.classList.toggle("activo", Boolean(pagina) && a.dataset.paginaLink === pagina);
    });

    const titulo = document.getElementById("topbar-titulo");
    const subtitulo = document.getElementById("topbar-subtitulo");
    if (titulo && usuario) titulo.textContent = usuario.nombre || "";
    if (subtitulo && usuario) subtitulo.textContent = usuario.carrera || "";
  }

  function enlazar() {
    if (enlazado) return;
    if (!document.querySelector(".sidebar")) return;
    enlazado = true;

    fab = document.querySelector(".user-fab");
    if (!fab) {
      fab = crearFab();
      document.body.appendChild(fab);
    }
    fabBoton = fab.querySelector(".user-fab__boton");
    fabMenu = fab.querySelector(".dropdown");

    pintarUsuario();
    pintarPeriodo();

    if (fabBoton) {
      fabBoton.addEventListener("click", function () {
        if (!sidebarOculto()) return;
        alternarMenu(fabMenu, fab, fabBoton);
      });
    }

    document.addEventListener("click", function (e) {
      const btn = e.target.closest("[data-logout]");
      if (btn) {
        e.preventDefault();
        cerrarSesion();
      }
    });

    document.addEventListener("click", function (e) {
      if (fab && fabMenu && !fab.contains(e.target)) {
        cerrarMenu(fabMenu, fab, fabBoton);
      }
    });

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && fab && fabMenu) {
        cerrarMenu(fabMenu, fab, fabBoton);
      }
    });

    document.addEventListener("gaud:sesion", pintarUsuario);

    observarMedia();
  }

  return {
    iniciales,
    nombreCorto,
    crearMenu,
    crearDropdown,
    crearFab,
    alternarMenu,
    cerrarMenu,
    cerrarSesion,
    pintarUsuario,
    enlazar,
    sidebarOculto
  };
})();

if (typeof document !== "undefined") {
  document.addEventListener("DOMContentLoaded", function () { GAUD_Header.enlazar(); });
}
