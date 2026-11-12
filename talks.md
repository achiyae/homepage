---
title: "Talks"
layout: default
permalink: /talks/
# Online recordings, newest first.
talks:
- title: "Automatic Code Generation"
  kind: lecture
  meta: "“AI meets Software Quality” colloquium · 2024 · 56 min"
  link: https://www.youtube.com/watch?v=02_Dl6CMtBs
  image: "/assets/img/talks/automatic-code-generation.jpg"
  summary: "Three works on automatic code generation: evolving assembly code that survives longest in the CodeGuru Xtreme competition by finding and exploiting weaknesses in opposing programs; evolving behavioral programs from requirements with genetic programming; and using large language models to translate requirements into behavioral programs, so that the generated code stays aligned with every requirement."
- title: "What Petri Nets Oblige Us to Say"
  kind: trailer
  meta: "IEEE Transactions on Software Engineering · 2023 · 1 min"
  link: https://www.youtube.com/watch?v=5COISMtg2P0
  image: "/assets/img/talks/petri-nets-trailer.jpg"
  summary: "A short trailer for our paper comparing Petri nets and Behavioral Programming as ways to compose independent requirements into one model of a reactive system."
- title: "Towards Better Interoperability Between Software and AI"
  kind: lecture
  meta: "“AI meets Software Quality” colloquium · 2022 · 53 min"
  link: https://www.youtube.com/watch?v=yD6o_-ZKogs
  image: "/assets/img/talks/software-ai-interoperability.jpg"
  summary: "A survey of ongoing work on the synergy between artificial intelligence and software engineering. Deep-learning systems can err in new situations, and AI tools for writing software rarely use what software engineering offers. The talk proposes Behavioral Programming, which lets requirements be programmed the way people describe them, as the bridge between the two fields."
---
# Talks

Recorded lectures and paper trailers.

<div class="highlights">
{%- for h in page.talks %}
{% include highlight-card.html h=h %}
{%- endfor %}
</div>
