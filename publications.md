---
title: "Publications"
layout: default
permalink: /publications/
---
# Publications

Can't find a paper online? [Contact me](mailto:achiya@bgu.ac.il). This list may not be up to date; for the latest publications, see my [Google Scholar]({{ site.social | where: "name", "Google Scholar" | map: "url" | first }}) profile.

<div id="pub-filters" hidden></div>

<div id="pub-list">
{%- for year in site.data.bib_years -%}
  {%- capture year_list -%}{% bibliography --query @*[year={{ year }}] %}{%- endcapture -%}
  {%- if year_list contains "<li" %}
<section class="pub-year" data-year="{{ year }}">
<h2>{{ year }}</h2>
{{ year_list | replace: "<bib-item>", "" | replace: "</bib-item>", "" }}
</section>
  {%- endif -%}
{%- endfor %}
</div>

**Copyright notice:** The documents distributed by this server have been provided by the contributing authors as a means to ensure timely dissemination of scholarly and technical work on a noncommercial basis. Copyright and all rights therein are maintained by the authors or by other copyright holders, notwithstanding that they have offered their works here electronically. It is understood that all persons copying this information will adhere to the terms and constraints invoked by each author's copyright. In most cases, these works may not be reposted without the explicit permission of the copyright holder.
{: .pub-copyright}

<script type="module" src="{{ '/assets/js/publications.js' | relative_url }}"></script>
