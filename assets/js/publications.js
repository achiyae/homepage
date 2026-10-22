export function parseTopics(raw) {
  const out = [];
  for (const part of String(raw || "").split(",")) {
    const t = part.trim();
    if (t && !out.includes(t)) out.push(t);
  }
  return out;
}

export function matches(entry, state) {
  if (state.firstAuthor && entry.firstAuthor !== state.firstAuthor) return false;
  if (state.author && !entry.authors.includes(state.author)) return false;
  if (state.topic && !entry.topics.includes(state.topic)) return false;
  const terms = state.query.toLowerCase().split(/\s+/).filter(Boolean);
  if (terms.length) {
    const text = entry.text.toLowerCase();
    if (!terms.every((t) => text.includes(t))) return false;
  }
  return true;
}

function el(doc, tag, props = {}, text) {
  const node = doc.createElement(tag);
  for (const [k, v] of Object.entries(props)) node.setAttribute(k, v);
  if (text !== undefined) node.textContent = text;
  return node;
}

function makeSelect(doc, id, anyLabel, values) {
  const select = el(doc, "select", { id, "aria-label": anyLabel });
  select.appendChild(el(doc, "option", { value: "" }, anyLabel));
  const sorted = [...values].sort((a, b) => a.localeCompare(b));
  for (const v of sorted) select.appendChild(el(doc, "option", { value: v }, v));
  return select;
}

export function init(doc = document) {
  try {
    const bar = doc.getElementById("pub-filters");
    const list = doc.getElementById("pub-list");
    if (!bar || !list) return;

    const items = [...list.querySelectorAll("li.pub")].map((li) => ({
      li,
      entry: {
        text: li.textContent,
        firstAuthor: li.dataset.firstAuthor || "",
        authors: (li.dataset.authors || "").split("|").map((a) => a.trim()).filter(Boolean),
        topics: parseTopics(li.dataset.topics),
      },
    }));
    const sections = [...list.querySelectorAll("section.pub-year")];

    const firstAuthors = new Set();
    const authors = new Set();
    const topics = new Set();
    for (const { entry } of items) {
      if (entry.firstAuthor) firstAuthors.add(entry.firstAuthor);
      entry.authors.forEach((a) => authors.add(a));
      entry.topics.forEach((t) => topics.add(t));
    }

    const search = el(doc, "input", {
      id: "pub-search",
      type: "search",
      placeholder: "Search publications",
      "aria-label": "Search publications",
    });
    const hint = el(doc, "p", { class: "pub-hint" }, "Example: journal 2022");
    const selFirst = makeSelect(doc, "pub-first-author", "First author", firstAuthors);
    const selAuthor = makeSelect(doc, "pub-author", "Author", authors);
    const selTopic = makeSelect(doc, "pub-topic", "Topic", topics);
    const reset = el(doc, "button", { id: "pub-reset", type: "button" }, "Reset");
    const empty = el(doc, "p", { id: "pub-empty" }, "No publications match.");
    empty.hidden = true;

    bar.replaceChildren(search, hint, selFirst, selAuthor, selTopic, reset);
    list.appendChild(empty);

    const apply = () => {
      const state = {
        query: search.value,
        firstAuthor: selFirst.value,
        author: selAuthor.value,
        topic: selTopic.value,
      };
      let shown = 0;
      for (const { li, entry } of items) {
        const ok = matches(entry, state);
        li.hidden = !ok;
        if (ok) shown++;
      }
      for (const s of sections) {
        s.hidden = !s.querySelector("li.pub:not([hidden])");
      }
      empty.hidden = shown > 0;
    };

    bar.addEventListener("input", apply);
    bar.addEventListener("change", apply);
    reset.addEventListener("click", () => {
      search.value = "";
      selFirst.value = selAuthor.value = selTopic.value = "";
      apply();
    });
    bar.hidden = false;
  } catch (err) {
    console.error("Publication filters failed to initialise", err);
  }
}

if (typeof document !== "undefined") init();
