-- Sjálfspróf: gagnvirkt krossapróf úr YAML-skrá.
--
-- Notkun í .qmd:
--
--   ::: {.sjalfsprof src="sjalfsprof.yml"}
--   :::
--
-- `src` er slóð miðað við .qmd-skrána. Í YAML-skránni er listi `spurningar`:
--
--   spurningar:
--     - hluti: Grunnatriði           # spurningar með sama hluta eru flokkaðar saman
--       titill: Tölustafir í texta
--       spurning: 'Hvaða strengir innihalda samsvörun við `\d+`?'
--       valkostir: ['`123`', '`abc`', '`a12b`', '`4567`']
--       rett: [A, C, D]              # einn stafur = einvalsspurning
--       utskyring: |
--         `\d` táknar tölustaf ...
--
-- Allir textar eru markdown. Settu regex alltaf í `bakkomma`, annars les markdown
-- `\d` sem lausan `d`. Númer spurninga, "Hluti 1", "Rétt svar er A" og fjöldi
-- spurninga eru reiknuð; þau á ekki að skrifa í YAML-skrána.
--
-- Útlit og virkni eru í partials/sjalfsprof.inc, sem er aðeins sett inn á síður
-- sem nota sjálfspróf.

local function to_html(value)
  if value == nil then
    return ""
  end
  local t = pandoc.utils.type(value)
  local blocks
  if t == "Inlines" then
    blocks = { pandoc.Plain(value) }
  elseif t == "Blocks" then
    blocks = value
  else
    blocks = { pandoc.Plain({ pandoc.Str(pandoc.utils.stringify(value)) }) }
  end
  -- Textinn verður hrátt HTML, svo Quarto breytir ekki tenglum í .qmd-skrár; gerum það hér.
  local doc = pandoc.Pandoc(blocks):walk({
    -- Mynd ein í málsgrein yrði að figure með alt-textann sem myndatexta, sem gæti
    -- ljóstrað upp svarinu. Sýnum myndina eina.
    Figure = function(f)
      return f.content
    end,
    Link = function(l)
      l.target = l.target:gsub("%.qmd(#?)", ".html%1")
      return l
    end,
  })
  return (pandoc.write(doc, "html"):gsub("%s+$", ""))
end

local function read_questions(src)
  local dir = pandoc.path.directory(quarto.doc.input_file)
  local path = pandoc.path.join({ dir, src })
  local fh = io.open(path, "r")
  if not fh then
    error("sjalfsprof: fann ekki " .. path)
  end
  local text = fh:read("a")
  fh:close()
  local meta = pandoc.read("---\n" .. text .. "\n---\n", "markdown").meta
  local items = meta.spurningar
  if items == nil then
    error("sjalfsprof: " .. path .. " hefur engan lista `spurningar`")
  end

  local out = {}
  for i, q in ipairs(items) do
    local options = {}
    for _, o in ipairs(q.valkostir or {}) do
      table.insert(options, to_html(o))
    end
    local correct = {}
    for _, letter in ipairs(q.rett or {}) do
      local l = pandoc.utils.stringify(letter):upper()
      local idx = string.byte(l) - string.byte("A")
      if idx < 0 or idx >= #options then
        error(string.format("sjalfsprof: spurning %d hefur rett: %s en aðeins %d valkosti",
          i, l, #options))
      end
      table.insert(correct, idx)
    end
    table.sort(correct)
    if #correct == 0 then
      error(string.format("sjalfsprof: spurning %d hefur ekkert rétt svar", i))
    end
    table.insert(out, {
      part = pandoc.utils.stringify(q.hluti or ""),
      title = to_html(q.titill),
      question = to_html(q.spurning),
      options = options,
      correct = correct,
      explanation = to_html(q.utskyring),
    })
  end
  return out
end

local included = false

function Div(el)
  if not el.classes:includes("sjalfsprof") then
    return nil
  end
  if not quarto.doc.is_format("html") then
    return pandoc.Para({ pandoc.Emph({ pandoc.Str("Sjálfsprófið er aðeins í vefútgáfunni.") }) })
  end
  local src = el.attributes.src
  if src == nil then
    error("sjalfsprof: vantar src=\"...\" á .sjalfsprof")
  end
  local data = pandoc.json.encode(read_questions(src))
  -- `</script>` í texta má ekki loka JSON-bútnum
  data = data:gsub("</", "<\\/")

  if not included then
    quarto.doc.include_file("after-body", "../partials/sjalfsprof.inc")
    included = true
  end

  return pandoc.RawBlock("html",
    '<div class="sjalfsprof">\n'
    .. '<script type="application/json" class="sjalfsprof-data">' .. data .. '</script>\n'
    .. '</div>')
end
