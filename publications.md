---
title: "Publications"
layout: default
permalink: /publications/
---
# Publications

**Copyright notice:** The documents distributed by this server have been provided by the contributing authors as a means to ensure timely dissemination of scholarly and technical work on a noncommercial basis. Copyright and all rights therein are maintained by the authors or by other copyright holders, notwithstanding that they have offered their works here electronically. It is understood that all persons copying this information will adhere to the terms and constraints invoked by each author's copyright. In most cases, these works may not be reposted without the explicit permission of the copyright holder.

Can't find a paper online? [Contact me](mailto:achiya@bgu.ac.il), or see [Google Scholar]({{ site.social | where: "name", "Google Scholar" | map: "url" | first }}) for citation counts.

<div id="pub-filters" hidden></div>

<div id="pub-list">
{%- assign this_year = site.time | date: "%Y" | plus: 0 -%}
{%- for year in (2000..this_year) reversed -%}
  {%- capture year_list -%}{% bibliography --query @*[year={{ year }}] %}{%- endcapture -%}
  {%- if year_list contains "<li" %}
<section class="pub-year" data-year="{{ year }}">
<h2>{{ year }}</h2>
{{ year_list | replace: "<bib-item>", "" | replace: "</bib-item>", "" }}
</section>
  {%- endif -%}
{%- endfor %}
</div>
