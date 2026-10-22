# Contributing

You do not need to know Jekyll. Every change is editing a text file and opening a pull request (PR) in the GitHub web UI. An automatic `build` check tells you if something is wrong.

## Editing and opening a PR (GitHub web UI)

1. Open the file on GitHub (paths are listed in each recipe below) and click the pencil icon (**Edit this file**). If you are not a collaborator, GitHub offers to fork the repository; accept.
2. Make your change and click **Commit changes...**. Choose **Create a new branch** and then **Propose changes**.
3. On the next page click **Create pull request**, fill in the checklist, and submit.
4. Wait for the `build` check at the bottom of the PR. Green means OK. Red means click **Details**, open the failed step "Check (build, links, tests)", and read the error. Fix it by editing the file again on the same branch; the check re-runs.

File and folder names are **case-sensitive** on the server (Windows and macOS hide this locally): `/assets/img/lab/Dana-Levi.jpg` is not `dana-levi.jpg`.

Indentation matters in YAML: use spaces (never tabs), and keep list items aligned with their neighbours. Quote values containing a colon, e.g. `title: "Note: a title"`.

## News item

File: `index.md`, in the `news:` list at the top. Order does not matter; the site sorts by date. `date` (YYYY-MM-DD) and `title` are required; `link` and `text` are optional.

```yaml
  - date: 2026-03-15
    title: "Our paper was accepted to ICSE 2026"
    link: "https://doi.org/10.1000/example"
    text: "Optional extra sentence (Markdown allowed)."
```

## Lab member

File: `lab.md`, in the `members:` list. `name` and `role` are required; the rest are optional (omit lines you do not need).

```yaml
- name: Dana Levi
  role: M.Sc. student
  topic: Evolutionary testing of autonomous vehicles
  photo: "/assets/img/lab/dana-levi.jpg"
  email: dana@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/dana-levi/
  github: https://github.com/danalevi
  website: https://example.com/dana
  now: "Now at Example Corp"
```

To move someone to alumni, cut their whole item from `members:` and paste it under `alumni:` (same fields, same indentation). `now` is meant for alumni to say where they are today.

### Photo rules

Square, at most 400x400 px, under 300 KB, lowercase file name `first-last.jpg`. Upload it to `assets/img/lab/` (in the GitHub UI: open that folder, **Add file -> Upload files**) and reference it as `photo: "/assets/img/lab/first-last.jpg"`. The path must match the file name exactly, including case.

## Research highlight

File: `research.md`, in the `highlights:` list. `title`, `summary` and `link` are required; `kind` (one of `paper`, `talk`, `software`) and `image` are optional.

```yaml
- title: "My Paper Title"
  kind: paper
  link: https://doi.org/10.1000/example
  image: "/assets/img/research/my-paper.jpg"
  summary: "Two or three sentences describing the contribution."
```

## Publication

File: `_bibliography/publications.bib`. Paste a BibTeX entry (most publishers and Google Scholar offer "Cite -> BibTeX") and add a `groups` field: a comma-separated list of topics. Reuse existing topic names exactly (for example `Evolutionary Computation`, `Behavioral Programming`, `Artificial Intelligence`, `Deep Learning`, `Testing`) so the filters on the Publications page stay tidy.

```bibtex
@InProceedings{Levi2026Example,
  author    = {Levi, Dana and Elyasaf, Achiya},
  title     = {{An Example Paper}},
  booktitle = {Proceedings of Example Conference},
  year      = {2026},
  doi       = {10.1000/example},
  groups    = {Evolutionary Computation, Testing},
}
```

The key (`Levi2026Example`) must be unique in the file, and every entry needs a 4-digit `year` (the build fails otherwise).

## Local preview (optional)

Not required: the PR check builds the site for you. To preview locally you need Ruby 3.3.

**macOS / Linux:** install [rbenv](https://github.com/rbenv/rbenv) (macOS: `brew install rbenv ruby-build`), then `rbenv install 3.3` and `rbenv local 3.3`. Node.js 20+ is needed only for `rake check`.

**Windows:** in PowerShell 7 (`pwsh`), install [RubyInstaller with Devkit](https://rubyinstaller.org/downloads/) (3.3.x, accept the default `ridk install` step), then reopen the terminal.

Then, in the repository folder:

```
bundle install
bundle exec jekyll serve
```

Open <http://localhost:4000>. Edits reload after a few seconds (refresh the page).

## Running the build check

```
bundle exec rake check
```

This builds the site, checks internal links and images, validates the news/lab/highlight fields, and runs the tests. Errors name the file, the item and the field, e.g. `lab.md: members item 3: missing required field `role``. Fix that item and run it again.
