---
title: "Research"
layout: default
permalink: /research/
highlights:
- title: "Towards Better Interoperability Between Software and AI"
  kind: talk
  link: https://www.youtube.com/watch?v=yD6o_-ZKogs
  summary: "A recording of a lecture given at the international colloquium \"AI meets Software Quality\". It presents ongoing work on creating a synergy between artificial intelligence and software engineering, with Behavioral Programming at its core."
- title: "What Petri Nets Oblige Us to Say: Comparing Approaches for Behavior Composition"
  kind: paper
  link: https://doi.org/10.1109/TSE.2022.3216683
  image: "/assets/img/research/petri-nets.jpg"
  summary: "Shows that specifying multiple requirements in one Petri Net obliges modelers to define how the requirements combine, which often leads to over-specification and incorrect models. Compares this with Behavioral Programming and proposes a tool for translating between the two."
- title: "EC-KitY"
  kind: software
  link: https://www.sciencedirect.com/science/article/pii/S2352711023000778
  image: "/assets/img/research/eckity.jpg"
  summary: "A Python library for evolutionary computation, licensed under GNU GPL v3.0 and compatible with scikit-learn. It supports genetic algorithms, genetic programming, coevolution and multi-objective optimization, among other paradigms."
- title: "Context-Oriented Behavioral Programming"
  kind: paper
  link: https://doi.org/10.1016/j.infsof.2020.106504
  image: "/assets/img/research/cobp.jpg"
  summary: "A paradigm for developing context-aware systems that combines Behavioral Programming with context idioms specifying when scenarios are relevant. Case studies in robotics and IoT show measurable advantages over behavioral programming alone and context-oriented programming alone."
---
# Research

My research looks for new synergies between software engineering and artificial intelligence.

<div class="research-feature">
<h2><a href="{{ '/research/dl-operators/' | relative_url }}">Deep-learning-based evolutionary operators</a></h2>
<p>Crossover, mutation and selection operators that learn how to search while evolution runs, and ML models that approximate costly fitness evaluations. Seven papers since 2024.</p>
</div>

Selected highlights:

<div class="highlights">
{%- for h in page.highlights %}
{% include highlight-card.html h=h %}
{%- endfor %}
</div>
