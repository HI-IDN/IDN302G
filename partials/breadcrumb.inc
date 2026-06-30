<script>
document.addEventListener('DOMContentLoaded', function () {
  // Remove chapter-number span (and its trailing &nbsp;) from the index sidebar link
  document.querySelectorAll(
    'a[href$="index.html"].sidebar-item-text, a[href$="../index.html"].sidebar-item-text'
  ).forEach(function (link) {
    var num = link.querySelector('.chapter-number');
    if (!num) return;
    // Remove the &nbsp; text node that follows the span
    var next = num.nextSibling;
    if (next && next.nodeType === 3) next.remove();
    num.remove();
  });


  // Find active sidebar item
  var activeLink = document.querySelector('.sidebar-item.active > .sidebar-item-container > a, .sidebar-item.active > a');
  if (!activeLink) return;

  // Walk up to find parent part section
  var partTitle = '';
  var section = activeLink.closest('.sidebar-item-section');
  if (section) {
    var partLink = section.querySelector(':scope > .sidebar-item-container > .sidebar-item-text .menu-text');
    if (partLink) partTitle = partLink.textContent.trim();
  }

  var chapterText = activeLink.querySelector('.menu-text');
  var chapterTitle = chapterText ? chapterText.textContent.trim() : activeLink.textContent.trim();

  if (!partTitle && !chapterTitle) return;

  // Build breadcrumb bar
  var bar = document.createElement('div');
  bar.id = 'hi-breadcrumb';
  bar.setAttribute('aria-label', 'brauðmola');

  if (partTitle && chapterTitle && partTitle !== chapterTitle) {
    bar.innerHTML =
      '<span class="hi-bc-part">' + partTitle + '</span>' +
      '<span class="hi-bc-sep" aria-hidden="true">›</span>' +
      '<span class="hi-bc-chapter">' + chapterTitle + '</span>';
  } else {
    bar.innerHTML = '<span class="hi-bc-chapter">' + (partTitle || chapterTitle) + '</span>';
  }

  // Insert right after navbar
  var navbar = document.querySelector('nav.navbar');
  if (navbar && navbar.parentNode) {
    navbar.parentNode.insertBefore(bar, navbar.nextSibling);
  }
});
</script>
