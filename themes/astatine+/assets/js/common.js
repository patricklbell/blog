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

function setUtterancesTheme(theme) {
  if (document.querySelector(".utterances-frame")) {
    const message = {
      type: "set-theme",
      theme: theme,
    };
    const iframe = document.querySelector(".utterances-frame");
    iframe.contentWindow.postMessage(message, "https://utteranc.es");
  }
}

function updateMode() {
  // On page load or when changing themes, best to add inline in `head` to avoid FOUC
  if (isDark()) {
    document.documentElement.classList.add("dark");
    setUtterancesTheme("github-dark");
  } else {
    document.documentElement.classList.remove("dark");
    setUtterancesTheme("github-light");
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
