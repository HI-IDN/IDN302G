-- Birtir `description` úr frontmatter sem stílaðan "lead" efst á síðunni,
-- undir titlinum. Aðeins fyrir HTML (ekki reveal.js glærur).

function Pandoc(doc)
  if not FORMAT:match("html") then
    return doc
  end
  local desc = doc.meta.description
  if desc == nil then
    return doc
  end
  local lead = pandoc.Div(
    { pandoc.Para(pandoc.utils.blocks_to_inlines({ pandoc.Plain(desc) })) },
    pandoc.Attr("", { "page-lead" })
  )
  table.insert(doc.blocks, 1, lead)
  return doc
end
