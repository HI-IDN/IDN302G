<script>
document.addEventListener('DOMContentLoaded', function () {
  // Strip chapter number only from the main index link (exact href match)
  document.querySelectorAll('.sidebar-item-text[href="./index.html"], .sidebar-item-text[href="../index.html"]')
    .forEach(function (link) {
      link.classList.add('hi-index-link');
      var menuText = link.querySelector('.menu-text');
      var titleSpan = link.querySelector('.chapter-title');
      if (menuText && titleSpan) {
        menuText.textContent = titleSpan.textContent;
      }
    });


  // Find active sidebar item
  var activeLink = document.querySelector('a.sidebar-link.active, .sidebar-item.active > .sidebar-item-container > a, .sidebar-item.active > a');
  if (!activeLink) return;

  // Walk up to find parent part section
  var partTitle = '';
  var section = activeLink.closest('.sidebar-item-section');
  if (section) {
    var partLink = section.querySelector(':scope > .sidebar-item-container .menu-text');
    if (partLink) partTitle = partLink.textContent.trim();
  }

  var chapterText = activeLink.querySelector('.menu-text');
  var chapterTitle = chapterText ? chapterText.textContent.trim() : activeLink.textContent.trim();

  // Browser tab title: course name + part, constant across a part's subpages
  // (e.g. "Upplýsingaverkfræði – Erindrekar"), instead of the page name.
  var TAB_BASE = 'Upplýsingaverkfræði';
  document.title = (partTitle && partTitle !== TAB_BASE)
    ? TAB_BASE + ' – ' + partTitle
    : TAB_BASE;

  // Prefix the previous/next page links with the part name when they cross into
  // a different part (e.g. "Git og GitHub: Inngangur"); leave same-part links as
  // just the page name.
  function partOfHref(abs) {
    var links = document.querySelectorAll('.sidebar-link');
    for (var i = 0; i < links.length; i++) {
      if (links[i].href === abs) {
        var s = links[i].closest('.sidebar-item-section');
        if (s) {
          var m = s.querySelector(':scope > .sidebar-item-container .menu-text');
          return m ? m.textContent.trim() : '';
        }
      }
    }
    return '';
  }
  document.querySelectorAll('.page-navigation a').forEach(function (link) {
    var span = link.querySelector('.nav-page-text');
    if (!span) return;
    var targetPart = partOfHref(link.href);
    if (targetPart && targetPart !== partTitle) {
      span.textContent = targetPart + ': ' + span.textContent.trim();
    }
  });

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
