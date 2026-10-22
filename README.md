# Achiya Elyasaf's homepage

Source of [achiya.elyasaf.net](https://achiya.elyasaf.net), a Jekyll site published with GitHub Pages. Content lives in plain-text files (news and highlights in front matter, publications in BibTeX), so lab members can update it through pull requests; see [CONTRIBUTING.md](CONTRIBUTING.md) for step-by-step recipes.

## Owner's one-time setup

1. Settings -> Pages -> Source: **GitHub Actions**. Do this first: until it is set, every workflow run (including PR checks) fails at `configure-pages`.
   Also note that PRs from first-time contributors' forks need you to click "Approve and run" before CI runs.
2. Optional: add a branch protection rule on `main` requiring the `build` check and review from code owners (`.github/CODEOWNERS`).
3. After checking <https://achiyae.github.io/homepage/>, set the custom domain `achiya.elyasaf.net` in Settings -> Pages (with Actions-based deploys the `CNAME` file is ignored by GitHub and kept only as documentation), point the DNS CNAME record `achiya` at `achiyae.github.io`, and enable **Enforce HTTPS**.
