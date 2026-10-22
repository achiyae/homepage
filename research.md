---
title: "Research"
layout: default
permalink: /research/
highlights:
- title: "BERT Mutation: Deep Transformer Model for Masked Uniform Mutation in Genetic Programming"
  kind: paper
  link: https://www.mdpi.com/2227-7390/13/5/779
  image: "/assets/img/research/bert-mutation.jpg"
  summary: "A domain-independent mutation operator for Genetic Programming that uses Masked Language Modeling with a BERT transformer and deep reinforcement learning to suggest node replacements. Evaluated on three benchmark domains, it outperforms conventional and state-of-the-art mutation operators in convergence speed and solution quality."
- title: "Deep Neural Crossover: A Multi-Parent Operator That Leverages Gene Correlations"
  kind: paper
  link: https://dl.acm.org/doi/10.1145/3638529.3654020
  image: "/assets/img/research/deep-neural-crossover.jpg"
  summary: "A multi-parent crossover operator for genetic algorithms that uses deep reinforcement learning and an encoder-decoder architecture to learn which genes to select. It outperforms all baseline operators on two benchmark domains."
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

My research looks for new synergies between software engineering and artificial intelligence. Selected highlights:

<div class="highlights">
{%- for h in page.highlights %}
{% include highlight-card.html h=h %}
{%- endfor %}
</div>
