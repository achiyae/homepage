---
title: "Lab"
layout: default
permalink: /lab/
members:
- name: Achiya Elyasaf
  role: Principal Investigator
  photo: "/assets/img/lab/achiya-elyasaf.jpg"
  email: achiya@bgu.ac.il
  linkedin: https://www.linkedin.com/in/achiyae/
  github: https://github.com/achiyae/
- name: Gera Weiss
  role: Co-Principal Investigator
  photo: "/assets/img/lab/gera-weiss.jpg"
  email: geraw@bgu.ac.il
  linkedin: https://www.linkedin.com/in/gera-weiss-0a640016/
  github: https://github.com/geraw
- name: Roy Polianski
  role: Ph.D. student
  topic: Behavioral programs evolution
  photo: "/assets/img/lab/roy-polianski.jpg"
  email: roypoli@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/roy-poliansky-4275b0201/
  github: https://github.com/RoyPoli99
- name: Shimon Regev
  role: Ph.D. student
  topic: Evolutionary algorithms for multi-objective games
  photo: "/assets/img/lab/shimon-regev.jpg"
  email: regevs@post.bgu.ac.il
- name: Eliad Shem-Tov
  role: Ph.D. student
  topic: Deep learning-based operators for evolutionary algorithms
  email: eliads@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/eliad-shem-tov-5a39381a6/
- name: Meir Maor Biton
  role: M.Sc. student
  topic: 'BP-Flow: A Flow-Based Behavioral Programming Language'
  photo: "/assets/img/lab/meir-maor-biton.jpg"
  email: bitme@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/meir-biton-9b0688201
  github: https://github.com/maor226
- name: Ron Ziskind
  role: M.Sc. student
  topic: Software Engineering in the Era of AI
  email: ronzi@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/ron-ziskind-9aa61b220/
  github: https://github.com/ronzi-2002
- name: Ron Tohar
  role: M.Sc. student
  topic: BP-based feature construction for deep reinforcement learning
  photo: "/assets/img/lab/ron-tohar.jpg"
  email: rontoh@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/ron-tohar-7091861ba
  github: https://github.com/ronTohar1
- name: Benny Skidanov
  role: M.Sc. student
  topic: Human actions modeling and prediction
  email: skidanov@post.bgu.ac.il
  github: https://github.com/BennySkidanov
- name: Tomer Halperin
  role: M.Sc. student
  topic: EC-KitY developer. Evolutionary algorithms & ML
  photo: "/assets/img/lab/tomer-halperin.jpg"
  email: tomerhal@post.bgu.ac.il
  github: https://github.com/tomerhal
- name: Ron Shefland
  role: M.Sc. student
  topic: EC-KitY developer. Behavioral programs evolution
  email: ronshef@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/ron-shefland/
  github: https://github.com/ronshef
- name: Tamir Abu-Haya
  role: M.Sc. student
  topic: BP-based Non-Playable Characters (NPC) in video games
  photo: "/assets/img/lab/tamir-abu-haya.jpg"
  email: abuhayat@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/tamir-abu-haya
  github: https://github.com/TamirAbuHaya
- name: Almog Zhivov
  role: M.Sc. student
  topic: Debugging methodologies for Behavioral Programing
  photo: "/assets/img/lab/almog-zhivov.jpg"
  email: almogzh@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/almog-zhivov-196b2626b/
  github: https://github.com/AlmogZhivov
- name: Amit Foyershtein
  role: M.Sc. student
  topic: Green Neuroevolution
  photo: "/assets/img/lab/amit-foyershtein.jpg"
  email: amitfoye@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/amit-oshri-foyershtein-7b572b266/
  github: https://github.com/FoyerD
- name: Shmulik Froimovich
  role: M.Sc. student
  topic: BP-Based Agentic AI
  email: shmulikf@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/shmulik-froimovich-6276a06
- name: Daniel Erbesfeld
  role: M.Sc. student
  topic: Human actions modeling and prediction
  email: erbesfel@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/daniel-erbesfeld-b25b50134/
  github: https://github.com/DanielErb
- name: Ori Eines
  role: M.Sc. student
  topic: Evolving Assembly Code in an Adversarial Environment
  email: eineso@post.bgu.ac.il
- name: Tali Narovlyansky
  role: M.Sc. student
  topic: Requirements Engineering through Behavioral Programming
  email: talinaro@post.bgu.ac.il
alumni:
- name: Tom Yaacov
  role: Ph.D. student
  topic: Model-based approaches toward improved software engineering practices
  photo: "/assets/img/lab/tom-yaacov.jpg"
  email: tomya@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/tom-yaacov-43474a10b/
  github: https://github.com/tomyaacov
- name: Irina Maliukov
  role: M.Sc. student
  topic: Evolving Assembly Code in an Adversarial Environment
  photo: "/assets/img/lab/irina-maliukov.jpg"
  email: irinamal@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/irina-maliukov-8a0966306
  github: https://github.com/irenamal/EC-KitY/tree/assembly_code_generation
- name: Itai Tzruia
  role: M.Sc. student
  topic: EC-KitY developer. Evolutionary algorithms & machine learning
  email: itaitz@post.bgu.ac.il
  linkedin: https://www.linkedin.com/in/itai-tzruia-4a47a91b8/
  github: https://github.com/itaitzruia4
---
# AI & SE Integration Lab

Our lab seeks new synergies between software engineering and artificial intelligence to improve their interoperability and contribute to both.

{% assign home = site.pages | where: "url", "/" | first -%}
{% if home.recruiting %}Interested in joining? See the [recruiting information on the home page]({{ '/' | relative_url }}).{% endif %}

## The Team

<section class="members">
{% for m in page.members %}{% include member-card.html m=m %}
{% endfor %}</section>

## Alumni

<section class="alumni">
{% for m in page.alumni %}{% include member-card.html m=m %}
{% endfor %}</section>
