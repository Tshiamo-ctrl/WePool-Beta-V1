// Initialize basic interactions for the landing page
(function () {
  // Smooth scroll for anchor links
  function smoothScrollTo(targetId) {
    try {
      var el = document.getElementById(targetId);
      if (el) {
        el.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    } catch (e) {}
  }

  document.addEventListener('click', function (e) {
    var link = e.target.closest('a[href^="#"]');
    if (!link) return;
    var hash = link.getAttribute('href');
    if (hash && hash.length > 1) {
      var id = hash.slice(1);
      var target = document.getElementById(id);
      if (target) {
        e.preventDefault();
        smoothScrollTo(id);
        history.replaceState(null, '', '#' + id);
      }
    }
  });

  // Navbar background toggle on scroll
  var navbar = document.querySelector('.navbar');
  function onScroll() {
    if (!navbar) return;
    if (window.scrollY > 10) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  // Simple console message
  if (typeof console !== 'undefined' && console.log) {
    console.log('WePool landing.js loaded');
  }
})();