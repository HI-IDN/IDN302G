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

});
</script>
