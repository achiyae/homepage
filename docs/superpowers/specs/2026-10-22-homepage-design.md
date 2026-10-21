# Homepage Migration: Google Sites → GitHub Pages

**Date:** 2026-10-22
**Status:** Approved design, pending implementation plan

## Goal

Replace the Google Sites homepage at `https://achiya.elyasaf.net/` with a static site that lives in this repo and deploys with GitHub Pages. The content stays about the same. Lab students can add or change any content through pull requests. CI catches broken changes before merge.

**Success criteria**
- A student who hasn't seen the codebase can add a news item, add themselves to the lab, or add a paper by following `CONTRIBUTING.md` and opening a PR from the GitHub web UI.
- Every PR runs a build and link check. A broken PR shows a failing check before merge.
- Merging to `main` deploys automatically to `achiya.elyasaf.net`.
- The publications page loads instantly: it's pre-rendered HTML, with no runtime BibTeX parsing.

## Decisions

| Topic | Decision |
|---|---|
| Generator | Jekyll with a custom layout (no off-the-shelf theme), built by GitHub Actions |
| Content model | One Markdown file per subpage. Structured lists (news, lab members, highlights) go in that page's front matter. |
| Language | English only. The Hebrew affiliation lines are dropped. |
| Contributors | Students may edit any file. The owner's PR review is the gate. |
| Domain | Keep `achiya.elyasaf.net` through a `CNAME` file. The owner updates DNS after launch. |
| Publications | Copy `ElyasafPublications.bib` from `achiyae/bibliography` into `_bibliography/publications.bib` and render it at build time with `jekyll-scholar`. The original repo is not modified. From now on, this repo's copy is the source of truth. |
| Visual design | Produced with the `frontend-design` skill during implementation. Direction: clean, typographic academic look, single accent color, responsive, light and dark modes. |

## Repo layout

```
_config.yml                   site title, url, nav order, social links, scholar config
CNAME                         achiya.elyasaf.net
Gemfile, Gemfile.lock         pinned jekyll, jekyll-scholar, html-proofer
index.md                      Home
biography.md                  Biography
research.md                   Research
lab.md                        Lab
publications.md               Publications
grants-awards.md              Grants & Awards
_bibliography/publications.bib
_layouts/default.html         the only layout: header, nav, footer, page content
_includes/news.html
_includes/member-card.html
_includes/highlight-card.html
_includes/bib-entry.html      jekyll-scholar entry template
assets/css/site.css
assets/js/publications.js     client-side filter over the rendered list (vanilla JS)
assets/img/                   profile photo, research images, lab/<first-last>.jpg
.github/workflows/pages.yml
.github/pull_request_template.md
.github/CODEOWNERS
CONTRIBUTING.md
README.md                     short: what this is, link to CONTRIBUTING.md
```

## Pages and content model

Navigation order: Home, Biography, Research, Lab, Publications, Grants & Awards. It's defined once in `_config.yml`.

Header and footer on every page:
- Name, nav, and social and academic links: Twitter `eggsterino`, LinkedIn `achiyae`, ORCID `0000-0002-4009-5353`, Google Scholar `EBx5rKoAAAAJ`, dblp.
- Footer: "© Achiya Elyasaf since 2019".

### `index.md`: Home
- Body (Markdown):
  - Short intro line: faculty member, Institute of Software, Systems, and Security, Faculty of Computer and Information Science, Ben-Gurion University.
  - Contact: `achiya AT bgu.ac.il`, Building 96, room 224.
  - Recruiting notice: "I am actively recruiting new MSc students, Ph.D. students, and post-docs. Positions come with funding. Please contact me for details."
- Front matter `news:` list. Each item has:
  - `date` (YYYY-MM-DD, required)
  - `title` (required)
  - `link` (optional)
  - `text` (optional, Markdown)
- Rendering: the layout sorts news by `date` descending, so entry order in the file doesn't matter. It shows the newest 8. If there are more, it adds a "More news" toggle that expands the rest in place, so no separate page is needed.
- Seed news: the four current highlights (Deep Neural Crossover; What Petri Nets Oblige Us to Say (IEEE TSE); Context-Oriented Behavioral Programming; EC-KitY). Dates come from the publication years in the `.bib`.

### `biography.md`
Prose migrated from the current Biography page:
- BGU degrees
- Postdoc in David Harel's group at the Weizmann Institute
- Co-founder of Provengo Technologies (2021)
- SE↔AI research focus
- Context-Oriented Behavioral Programming
- AI- and expert-knowledge-based game solvers cited by Bostrom (2014)
- HUMIES Gold 2013, Gold 2011, Bronze 2009

### `research.md`
- Short intro.
- Front matter `highlights:` list. Each item has:
  - `title` (required)
  - `summary` (required, 1–3 sentences)
  - `link` (required)
  - `image` (optional)
  - `kind` (optional: `paper` | `talk` | `software`)
- Seed, in current order: BERT Mutation, Deep Neural Crossover, Towards Better Interoperability Between Software and AI (talk), What Petri Nets Oblige Us to Say, EC-KitY (software), Context-Oriented Behavioral Programming. Links and images come from the current page.

### `lab.md`
- Heading: "AI & SE Integration Lab", with an optional intro and recruiting pointer.
- Front matter `members:` and `alumni:` lists. Each item has:
  - `name` (required)
  - `role` (required, e.g. `Principal Investigator`, `Ph.D. student`, `M.Sc. student`)
  - `topic` (optional)
  - `photo` (optional; path under `/assets/img/lab/`)
  - `email`, `linkedin`, `github`, `website` (all optional)
  - Alumni may also have `now` (optional, where they went)
- Rendering: a card grid, in file order. A missing photo shows an initials placeholder, and missing links are hidden. Emails are shown as `user AT domain` text with a `mailto:` link.
- Seed members (18), in current order: Achiya Elyasaf (PI), Gera Weiss (Co-PI), Roy Polianski, Shimon Regev, Eliad Shem-Tov (Ph.D.), Meir Maor Biton, Ron Ziskind, Ron Tohar, Benny Skidanov, Tomer Halperin, Ron Shefland, Tamir Abu-Haya, Almog Zhivov, Amit Foyershtein, Shmulik Froimovich, Daniel Erbesfeld, Ori Eines, Tali Narovlyansky (M.Sc.). Topics and links come from the current page.
- Seed alumni (3): Tom Yaacov (Ph.D.), Irina Maliukov (M.Sc.), Itai Tzruia (M.Sc.).
- Email fix: Meir Maor Biton and Benny Skidanov use `@post.bgu.ac.il`. The current page has the typo `post.bug.ac.il`.

### `publications.md`
- Copyright notice, migrated verbatim from the current embed.
- Note: "Can't find a paper? Contact me." Link to Google Scholar for citation counts.
- Filter bar: a free-text search plus three dropdowns (first author, any author, topic), built by `assets/js/publications.js` from data attributes on the rendered entries.
  - Search semantics stay as today: whitespace-separated terms are ANDed, matched case-insensitively against the entry's visible text and its raw BibTeX.
  - A Reset button clears everything.
  - With JS disabled, the full list still shows.
- Body: `{% bibliography %}`, grouped by year descending. Within a year, entries are sorted by month descending (`sort_by: year,month`, `order: descending`). Entries without a month come last within their year.
- Each entry shows:
  - title, authors, venue (journal or booktitle), volume, number, pages, year
  - a "view online" link: `url` if present, else `https://doi.org/<doi>`
  - a collapsible `[bib]` block with the raw BibTeX, using `<details>` so no JS is needed
- The BibTeX `groups` field (comma-separated) supplies topic values. Authors come from the parsed author list.

### `grants-awards.md`
Markdown list migrated from the current page:
- ISTRC grant (Guiding and Guarding Deep Learning for Autonomous Vehicles using Scenario-Based Programming)
- I-CORE in Algorithms Postdoctoral Fellowship (CHE & ISF)
- IEEE Outstanding Paper Award
- Dean's List awards from BGU (2014) and the Weizmann Institute (2016)
- Three HUMIES (Gold 2013, Gold 2011, Bronze 2009)
- Nick Bostrom's citation of the evolved combinatorial-game solvers

## Content migration

- Text is copied from the six current Google Sites pages and edited only for formatting.
- Images are downloaded from the current site into `assets/img/`: the profile/banner photo, research highlight images, and the 21 lab member photos. Lab photos are named `<first>-<last>.jpg`, resized to 400×400 max, and kept under 300 KB.
- `_bibliography/publications.bib` is a byte-for-byte copy of `achiyae/bibliography/ElyasafPublications.bib` at the time of migration. Nothing is pushed to `achiyae/bibliography`.
- The BGU logo is not migrated. A text link to the faculty page replaces it.

## Build, CI, deploy

`.github/workflows/pages.yml`:
- **Triggers:** `pull_request` and `push` to `main`, plus `workflow_dispatch`.
- **Build job (all triggers):**
  1. `ruby/setup-ruby` with bundler cache
  2. `bundle exec jekyll build`, with `JEKYLL_ENV=production`
  3. `bundle exec htmlproofer ./_site` with `--disable-external`, checking internal links, images, and scripts
  4. Upload the Pages artifact
- **Deploy job:** only on `push` to `main`. Runs `actions/deploy-pages` with the `pages: write` and `id-token: write` permissions.
- Ruby version pinned in `.ruby-version`. Gems pinned in `Gemfile.lock`, which includes the `x86_64-linux` platform so CI resolves.

**Owner's one-time setup** (recorded in the README):
1. Repo Settings → Pages → Source: **GitHub Actions**.
2. Optional: branch protection on `main` requiring the build check and a CODEOWNERS review.
3. After verifying the site at the Pages URL, change the DNS record for `achiya.elyasaf.net` to a CNAME pointing at `achiyae.github.io`, then turn on "Enforce HTTPS".

## Contributor experience

- `CONTRIBUTING.md` has a copy-paste recipe for each common change:
  - add a news item
  - add yourself to the lab, or move yourself to alumni
  - add a research highlight
  - add a paper to `publications.bib`, including the `groups` field convention
  - add a photo, with size and format rules
  - preview locally (optional)
- Each recipe shows the exact YAML or BibTeX snippet and which file to edit.
- `.github/pull_request_template.md` has a checklist: what changed, photo size, and "the build check is green".
- `.github/CODEOWNERS`: `* @achiyae`.

## Error handling

- Malformed YAML front matter or a bad BibTeX entry fails `jekyll build`, which fails the PR check.
- A wrong image path or broken internal link fails `htmlproofer`.
- Optional fields are guarded in templates (`{% if %}`), so a missing field never breaks rendering.
- `publications.js` fails soft: if it throws, the unfiltered list stays visible.

## Testing

- CI build plus `htmlproofer` on every PR. This is the primary check.
- Manual verification before launch:
  - every page renders locally
  - news sorts correctly
  - publications filters work (search AND-terms, each dropdown, reset)
  - layout works on a phone-width screen, in light and dark mode
- Before merging the initial PR, deliberately break a front-matter block and check that CI fails, then revert.

## Out of scope

- Hebrew or any multilingual support.
- Individual news-item pages or an RSS feed.
- Automatic sync from or to `achiyae/bibliography` or Google Scholar.
- PR preview deployments. CI build status is enough for now.
- Deleting the Google Sites site, which the owner does manually after the DNS cutover.
