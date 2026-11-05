<!-- Sjálfspróf: útlit og virkni. Sett inn af filters/sjalfsprof.lua á síður sem nota það. -->
<style>
.sjalfsprof {
  /* Litapalletta HÍ úr styles/hi-book.scss; appelsínugulur er aðallitur sjálfsprófa */
  --sp-accent: var(--hi-orange, #FFA05F);
  --sp-accent-dark: color-mix(in srgb, var(--sp-accent) 65%, var(--hi-ink, #262626));
  --sp-accent-soft: color-mix(in srgb, var(--sp-accent) 15%, transparent);
  --sp-correct: var(--hi-teal, #2DD2C0);
  --sp-incorrect: var(--hi-red, #FC8484);
  max-width: 800px;
  margin: 30px auto;
}
.sjalfsprof .sp-progress-track {
  height: 9px;
  background: var(--hi-panel, #EEEEEE);
  border-radius: 20px;
  overflow: hidden;
  margin-bottom: 24px;
}
.sjalfsprof .sp-progress-fill {
  height: 100%;
  width: 0%;
  background: var(--sp-accent);
  transition: width 0.3s;
}
.sjalfsprof .sp-card {
  background: var(--bs-tertiary-bg, #f7f8fa);
  border: 1px solid var(--bs-border-color, #ddd);
  border-radius: 14px;
  padding: 25px;
  margin-bottom: 25px;
}
.sjalfsprof .sp-part {
  color: var(--bs-secondary-color, #666);
  font-size: 0.9rem;
  margin-bottom: 8px;
}
.sjalfsprof .sp-card h3 { margin-top: 8px; }
.sjalfsprof .sp-option {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 13px;
  margin: 8px 0;
  border: 1px solid var(--bs-border-color, #ccc);
  border-radius: 9px;
  cursor: pointer;
}
.sjalfsprof .sp-option:has(input:checked) {
  border-color: var(--sp-accent);
  background: var(--sp-accent-soft);
}
.sjalfsprof .sp-option.sp-is-correct { border-color: var(--sp-correct); }
.sjalfsprof .sp-option input { accent-color: var(--sp-accent); }
.sjalfsprof .sp-option:has(input:disabled) { cursor: default; }
.sjalfsprof .sp-btn {
  background: var(--sp-accent);
  color: var(--hi-ink, #262626);
  border: none;
  padding: 12px 22px;
  border-radius: 9px;
  cursor: pointer;
  margin-top: 15px;
  font-weight: 600;
}
.sjalfsprof .sp-btn:hover {
  background: var(--sp-accent-dark);
  color: var(--hi-white, #ffffff);
}
.sjalfsprof .sp-feedback {
  margin-top: 20px;
  padding: 18px;
  border-radius: 10px;
  line-height: 1.7;
}
.sjalfsprof .sp-feedback.correct {
  background: color-mix(in srgb, var(--sp-correct) 15%, transparent);
  border: 1px solid var(--sp-correct);
}
.sjalfsprof .sp-feedback.incorrect {
  background: color-mix(in srgb, var(--sp-incorrect) 15%, transparent);
  border: 1px solid var(--sp-incorrect);
}
.sjalfsprof .sp-feedback h4 { margin-top: 0; }
.sjalfsprof .sp-result {
  text-align: center;
  padding: 30px;
  border: 1px solid var(--bs-border-color, #ccc);
  border-radius: 14px;
}
.sjalfsprof .sp-score {
  font-size: 2.5rem;
  font-weight: bold;
  color: var(--sp-accent-dark);
}
</style>

<script>
(function () {
  const letter = i => String.fromCharCode(65 + i);
  const join = xs => xs.length < 2 ? xs.join("")
    : xs.slice(0, -1).join(", ") + " og " + xs[xs.length - 1];
  const el = (tag, cls, html) => {
    const e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html !== undefined) e.innerHTML = html;
    return e;
  };
  // Stærðfræði ($A \cap B$) er sett inn eftir að MathJax hefur keyrt, svo við biðjum um hana aftur
  const typeset = node => {
    if (window.MathJax && MathJax.typesetPromise) MathJax.typesetPromise([node]);
  };

  function init(root, n) {
    const questions = JSON.parse(root.querySelector(".sjalfsprof-data").textContent);
    // "Hluti 1", "Hluti 2", ... í þeirri röð sem hlutarnir birtast fyrst
    const parts = [...new Set(questions.map(q => q.part).filter(Boolean))];

    const progress = el("p", "sp-progress");
    progress.setAttribute("role", "status");
    const track = el("div", "sp-progress-track");
    const fill = el("div", "sp-progress-fill");
    track.appendChild(fill);
    const content = el("div");
    root.append(progress, track, content);

    let current = 0, score = 0;

    function show() {
      const q = questions[current];
      progress.textContent = `Spurning ${current + 1} af ${questions.length}`;
      fill.style.width = `${current / questions.length * 100}%`;

      const card = el("section", "sp-card");
      if (q.part) {
        card.appendChild(el("p", "sp-part",
          `Hluti ${parts.indexOf(q.part) + 1} – ` + q.part));
      }
      card.appendChild(el("h3", "", `Spurning ${current + 1}` + (q.title ? " – " + q.title : "")));
      card.appendChild(el("div", "sp-question", q.question));

      const single = q.correct.length === 1;
      const inputs = q.options.map((opt, i) => {
        const label = el("label", "sp-option");
        const input = document.createElement("input");
        input.type = single ? "radio" : "checkbox";
        input.name = `sjalfsprof-${n}-${current}`;
        input.value = i;
        label.append(input, el("span", "", `${letter(i)}. ` + opt));
        card.appendChild(label);
        return input;
      });
      if (!single) card.appendChild(el("p", "sp-part", "Veldu öll rétt svör."));

      const button = el("button", "sp-btn");
      button.type = "button";
      button.textContent = "Athuga svar";
      const feedback = el("div");
      feedback.setAttribute("aria-live", "polite");
      card.append(button, feedback);

      let answered = false;
      button.addEventListener("click", () => {
        if (answered) {
          current++;
          current < questions.length ? show() : results();
          return;
        }
        const chosen = inputs.filter(x => x.checked).map(x => Number(x.value));
        if (chosen.length === 0) {
          feedback.className = "sp-feedback incorrect";
          feedback.textContent = "Veldu að minnsta kosti eitt svar.";
          return;
        }
        answered = true;
        const ok = chosen.join() === q.correct.join();
        if (ok) score++;
        inputs.forEach((x, i) => {
          x.disabled = true;
          if (q.correct.includes(i)) x.parentElement.classList.add("sp-is-correct");
        });
        const right = q.correct.map(letter);
        feedback.className = "sp-feedback " + (ok ? "correct" : "incorrect");
        feedback.replaceChildren(
          el("h4", "", ok ? "✓ Rétt svar!" : "✗ Rangt svar"),
          el("p", "", (right.length === 1 ? "Rétt svar er " : "Rétt svör eru ")
            + join(right) + "."),
          el("div", "", q.explanation)
        );
        typeset(feedback);
        button.textContent = current === questions.length - 1 ? "Sjá niðurstöðu" : "Næsta spurning";
      });

      content.replaceChildren(card);
      typeset(card);
    }

    function results() {
      progress.textContent = "Prófi lokið!";
      fill.style.width = "100%";
      const card = el("div", "sp-result");
      const restart = el("button", "sp-btn");
      restart.type = "button";
      restart.textContent = "Taka prófið aftur";
      restart.addEventListener("click", () => { current = 0; score = 0; show(); });
      card.append(
        el("h2", "", "Niðurstaða"),
        el("p", "sp-score", `${score} / ${questions.length}`),
        el("p", "", `Þú svaraðir ${Math.round(score / questions.length * 100)}% rétt.`),
        el("p", "", score === questions.length
          ? "Frábært! Þú svaraðir öllum spurningunum rétt."
          : "Vel gert að æfa þig! Skoðaðu útskýringarnar og reyndu aftur."),
        restart
      );
      content.replaceChildren(card);
    }

    show();
  }

  document.querySelectorAll(".sjalfsprof").forEach(init);
})();
</script>
