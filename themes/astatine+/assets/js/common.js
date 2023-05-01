function isDark() {
  if (
    localStorage.theme === "dark" ||
    (!("theme" in localStorage) &&
      window.matchMedia("(prefers-color-scheme: dark)").matches)
  ) {
    return true;
  }

  return false;
}

var remark_config = {
  host: "https://remark42.patricklbell.xyz",
  site_id: "remark42.patricklbell.xyz",
  simple_view: true,
  no_footer: true,
  components: ["embed"],
  theme: isDark() ? "dark" : "light",
};

!(function (e, n) {
  for (var o = 0; o < e.length; o++) {
    var r = n.createElement("script"),
      c = ".js",
      d = n.head || n.body;
    "noModule" in r ? ((r.type = "module"), (c = ".mjs")) : (r.async = !0),
      (r.defer = !0),
      (r.src = remark_config.host + "/web/" + e[o] + c),
      d.appendChild(r);
  }
})(remark_config.components || ["embed"], document);

function updateMode() {
  // On page load or when changing themes, best to add inline in `head` to avoid FOUC
  if (isDark()) {
    document.documentElement.classList.add("dark");
    window?.REMARK42?.changeTheme("dark");
  } else {
    document.documentElement.classList.remove("dark");
    window?.REMARK42?.changeTheme("light");
  }
}
function toggleMode() {
  if (isDark()) {
    // Whenever the user explicitly chooses light mode
    localStorage.theme = "light";
  } else {
    // Whenever the user explicitly chooses dark mode
    localStorage.theme = "dark";
  }
  updateMode();
}
window.onload = updateMode();
function toggleMenu() {
  let navbar = document.getElementById("navbar-default");
  if (navbar.classList.contains("hidden")) {
    navbar.classList.remove("hidden");
  } else {
    navbar.classList.add("hidden");
  }
}
