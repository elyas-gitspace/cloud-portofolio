// Progressive enhancement only: the page reads fine without JS.
(() => {
  document.documentElement.classList.add("js");
  const year = document.getElementById("year");
  if (year) year.textContent = new Date().getFullYear();

  // Bar: hairline appears once content slides under it
  const bar = document.querySelector(".bar");
  const onScroll = () => bar.classList.toggle("is-stuck", window.scrollY > 8);
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  if (!("IntersectionObserver" in window)) {
    document.querySelectorAll(".rule-metal").forEach((el) => el.classList.add("in"));
    return;
  }

  // Current section in the bar
  const links = [...document.querySelectorAll(".bar nav a")];
  const spy = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (!e.isIntersecting) return;
      links.forEach((a) => a.setAttribute("aria-current", String(a.getAttribute("href") === `#${e.target.id}`)));
    });
  }, { rootMargin: "-45% 0px -50% 0px" });
  links.forEach((a) => { const s = document.querySelector(a.getAttribute("href")); if (s) spy.observe(s); });
  new IntersectionObserver(([e]) => {
    if (e.isIntersecting) links.forEach((a) => a.setAttribute("aria-current", "false"));
  }, { rootMargin: "0px 0px -60% 0px" }).observe(document.getElementById("top"));

  // Reveal once: the metal rule draws, blocks settle
  const targets = document.querySelectorAll(".rule-metal, .job, .edu, .chain, .proof, .plate, .build, .oss, .quote, .notes-facts");
  const io = new IntersectionObserver((entries) => {
    entries.forEach((e) => { if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); } });
  }, { rootMargin: "0px 0px -6% 0px" });
  targets.forEach((el) => { if (!el.classList.contains("rule-metal")) el.classList.add("rv"); io.observe(el); });
})();
