---
title: "Research"
layout: default
permalink: /research/
highlights:
- title: "Towards Better Interoperability Between Software and AI"
  kind: talk
  link: https://www.youtube.com/watch?v=yD6o_-ZKogs
  summary: "A recording of a lecture given at the international colloquium \"AI meets Software Quality\". It presents ongoing work on creating a synergy between artificial intelligence and software engineering, with Behavioral Programming at its core."
- title: "EC-KitY"
  kind: software
  link: https://www.sciencedirect.com/science/article/pii/S2352711023000778
  image: "/assets/img/research/eckity.jpg"
  summary: "A Python library for evolutionary computation, licensed under GNU GPL v3.0 and compatible with scikit-learn. It supports genetic algorithms, genetic programming, coevolution and multi-objective optimization, among other paradigms."
---
# Research

My research looks for new synergies between software engineering and artificial intelligence.

<div class="research-feature">
<h2><a href="{{ '/research/dl-operators/' | relative_url }}">Deep-learning-based evolutionary operators</a></h2>
<p>Crossover, mutation and selection operators that learn how to search while evolution runs, and ML models that approximate costly fitness evaluations. Seven papers since 2024.</p>
</div>

<div class="research-feature">
<h2><a href="{{ '/research/behavioral-programming/' | relative_url }}">Behavioral programming</a></h2>
<p>Executable specifications built from independent scenarios, one per requirement: their semantics, context awareness, integration with machine learning, automatic generation and testing. Fifteen papers since 2018.</p>
</div>

Selected highlights:

<div class="highlights">
{%- for h in page.highlights %}
{% include highlight-card.html h=h %}
{%- endfor %}
</div>
