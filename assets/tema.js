// Botão de modo claro/escuro. A escolha fica salva neste navegador.
(function () {
  var root = document.documentElement, btn = document.getElementById("tema");
  if (!btn) return;
  function sync() {
    var dark = root.dataset.theme === "dark";
    btn.setAttribute("aria-pressed", dark ? "true" : "false");
    btn.setAttribute("aria-label", dark ? "Ativar modo claro" : "Ativar modo escuro");
    var m = document.querySelector('meta[name="theme-color"]');
    if (m) m.setAttribute("content", dark ? "#0F0F0F" : "#FF4F1F");
  }
  btn.addEventListener("click", function () {
    root.dataset.theme = root.dataset.theme === "dark" ? "light" : "dark";
    try { localStorage.setItem("tema", root.dataset.theme); } catch (e) {}
    sync();
  });
  sync();
})();
