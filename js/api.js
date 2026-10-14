(function (global) {
  "use strict";

  const BASE = "/GAUD/api";

  function manejarRespuesta(resp) {
    return resp.json().then(function (body) {
      if (!body.ok) {
        const err = new Error(body.error || "Error desconocido");
        err.status = resp.status;
        err.body = body;
        throw err;
      }
      return body.data;
    });
  }

  function headers() {
    return { "Content-Type": "application/json" };
  }

  function get(url) {
    return fetch(BASE + url, { credentials: "same-origin" }).then(manejarRespuesta);
  }

  function post(url, data) {
    return fetch(BASE + url, {
      method: "POST",
      headers: headers(),
      credentials: "same-origin",
      body: JSON.stringify(data || {})
    }).then(manejarRespuesta);
  }

  function put(url, data) {
    return fetch(BASE + url, {
      method: "PUT",
      headers: headers(),
      credentials: "same-origin",
      body: JSON.stringify(data || {})
    }).then(manejarRespuesta);
  }

  function del(url) {
    return fetch(BASE + url, {
      method: "DELETE",
      credentials: "same-origin"
    }).then(manejarRespuesta);
  }

  global.GAUD_API = { get, post, put, del, BASE };
})(window);
