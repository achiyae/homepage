---
title: Home
layout: default
permalink: /
recruiting: false  # true shows the "actively recruiting" notice here and on the Lab page
news:
  - date: 2024-01-01
    title: "Deep Neural Crossover: A Multi-Parent Operator That Leverages Gene Correlations"
    link: "https://doi.org/10.1145/3638529.3654020"
  - date: 2023-01-01
    title: "What Petri Nets Oblige Us to Say: Comparing Approaches for Behavior Composition (IEEE TSE)"
    link: "https://doi.org/10.1109/TSE.2022.3216683"
  - date: 2021-05-01
    title: "Context-Oriented Behavioral Programming"
    link: "https://doi.org/10.1016/j.infsof.2020.106504"
  - date: 2023-01-01
    title: "EC-KitY: Evolutionary computation tool kit in Python with seamless machine learning integration"
    link: "https://doi.org/10.1016/j.softx.2023.101381"
---
<section class="intro">
  <img class="profile-photo" src="{{ '/assets/img/achiya.jpg' | relative_url }}" alt="Achiya Elyasaf" width="400">
  <div>
    <p>Faculty member at the Institute of Software, Systems, and Security, Faculty of Computer and Information Science, Ben-Gurion University of the Negev.</p>
    <p class="contact">Contact: achiya AT bgu.ac.il<br>Building 96, room 224</p>
    {% if page.recruiting %}{% include recruiting.html %}{% endif %}
  </div>
</section>

## News

{% include news.html items=page.news %}
