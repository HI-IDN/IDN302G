<script>
(function () {
  // Collapsed state persists across pages; header-includes.inc applies it
  // before first paint so the sidebar never flashes in and out.
  var KEY = 'hi-sidebar-collapsed';
  var root = document.documentElement;

  var sidebar = document.getElementById('quarto-sidebar');
  if (!sidebar) return;

  // ── Collapsible sidebar ────────────────────────────────────────────────────
  // The edge tab stays vertically centred, independent of the navbar.
  var btn = document.createElement('button');
  btn.type = 'button';
  btn.className = 'hi-sidebar-toggle';
  btn.setAttribute('aria-controls', 'quarto-sidebar');
  document.body.appendChild(btn);

  // While open the button sits on the sidebar's right edge. The sidebar
  // width follows the viewport, so track its right edge and hand it to CSS.
  function placeButton() {
    btn.style.setProperty('--hi-sidebar-right', sidebar.getBoundingClientRect().right + 'px');
  }
  if (window.ResizeObserver) new ResizeObserver(placeButton).observe(sidebar);

  function isCollapsed() { return root.classList.contains('hi-sidebar-collapsed'); }
  function sync() {
    var label = isCollapsed() ? 'Sýna hliðarslá' : 'Fela hliðarslá';
    btn.setAttribute('aria-label', label);
    btn.title = label;
    btn.innerHTML = '<i class="bi bi-chevron-' + (isCollapsed() ? 'right' : 'left') + '" aria-hidden="true"></i>';
    btn.setAttribute('aria-expanded', String(!isCollapsed()));
  }
  function setCollapsed(collapsed) {
    root.classList.toggle('hi-sidebar-collapsed', collapsed);
    // Measure now so the view transition captures the button in its new spot.
    if (!collapsed) placeButton();
    try {
      if (collapsed) localStorage.setItem(KEY, '1');
      else localStorage.removeItem(KEY);
    } catch (e) {}
    sync();
  }
  sync();

  // A view transition does a single layout change and animates snapshots on
  // the compositor, so the slide stays smooth however long the page is.
  var busy = false;
  btn.addEventListener('click', function () {
    if (busy) return;
    var collapsed = !isCollapsed();
    var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!document.startViewTransition || reduce) {
      setCollapsed(collapsed);
      return;
    }
    busy = true;
    root.classList.add('hi-sidebar-animating');
    var transition = document.startViewTransition(function () { setCollapsed(collapsed); });
    transition.finished.finally(function () {
      root.classList.remove('hi-sidebar-animating');
      busy = false;
    });
  });

  // ── Accordion: only one part open at a time ────────────────────────────────
  // Bootstrap ignores hide() on a section that is still animating open, so
  // remember the latest request and close any stragglers once they settle.
  document.addEventListener('DOMContentLoaded', function () {
    if (!window.bootstrap) return;
    var current = null;
    function hide(el) {
      bootstrap.Collapse.getOrCreateInstance(el, { toggle: false }).hide();
    }
    sidebar.addEventListener('show.bs.collapse', function (e) {
      if (!e.target.classList.contains('depth1')) return;
      current = e.target;
      sidebar.querySelectorAll('.sidebar-section.depth1.show').forEach(function (el) {
        if (el !== current) hide(el);
      });
    });
    sidebar.addEventListener('shown.bs.collapse', function (e) {
      if (e.target.classList.contains('depth1') && e.target !== current) hide(e.target);
    });
  });
})();
</script>
