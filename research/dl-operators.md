---
title: "Deep-Learning-Based Evolutionary Operators"
layout: default
permalink: /research/dl-operators/
# BibTeX keys from _bibliography/publications.bib, in display order (newest first).
papers:
- ShemTov2026BertMutationGA
- ShemTov2026DeepTournamentSelection
- Foyershtein2026EnergyEfficientDNC
- shem2025bert
- ShemTov2024DLOperators
- ShemTov2024DNC
- Tzruia2023FitnessApproximationMachine
---
<p class="breadcrumb"><a href="{{ '/research/' | relative_url }}">Research</a></p>

# Deep-Learning-Based Evolutionary Operators

Evolutionary algorithms search by repeatedly selecting, recombining and mutating a population of candidate solutions. For decades, the operators that do this work have been *blind*: they make random changes and let selection sort out the good from the bad. Since 2024, our group has been replacing these blind operators with deep networks that learn, during the run itself, how to search.

## Why learn the operators?

Classical genetic operators are domain-independent precisely because they ignore the domain. One-point crossover cuts the parents at a random position, uniform mutation changes random genes, and tournament selection always prefers the fittest of *k* random individuals. None of them knows which genes work well together, which edits tend to help, or how much selection pressure the population needs right now. Domain-specific operators can encode that knowledge, but someone has to design them anew for every problem.

Fitness evaluation is the second bottleneck. When computing an individual's fitness means running a simulation, most of a run's time goes into evaluating individuals that are discarded a generation later.

## Learning to evolve

We treat an evolutionary run as a stream of training data. Every generation shows which parents produced good offspring, which edits improved an individual, and which selections paid off. Our operators are deep networks trained *online*, inside the run, mostly with policy-gradient reinforcement learning whose reward is the fitness of the offspring they produce. The result is an operator that adapts to the problem at hand while staying domain-independent: each one plugs into a standard genetic algorithm (GA) or genetic programming (GP) loop and replaces a single step.

<figure class="evo-loop">
<svg viewBox="0 0 640 440" role="img" aria-labelledby="evo-loop-title evo-loop-desc">
  <title id="evo-loop-title">Where our operators fit in the evolutionary loop</title>
  <desc id="evo-loop-desc">A cycle of four stages around the population: selection, crossover, mutation and evaluation. Each stage lists the classical approach and the learned operator that replaces it: Deep Tournament Selection, Deep Neural Crossover, BERT Mutation, and machine-learning fitness approximation.</desc>
  <defs>
    <marker id="evo-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
      <path d="M0 0 L10 5 L0 10 z" class="evo-arrowhead"/>
    </marker>
  </defs>
  <path class="evo-flow" d="M282 85 H350" marker-end="url(#evo-arrow)"/>
  <path class="evo-flow" d="M490 150 V282" marker-end="url(#evo-arrow)"/>
  <path class="evo-flow" d="M350 355 H290" marker-end="url(#evo-arrow)"/>
  <path class="evo-flow" d="M150 282 V150" marker-end="url(#evo-arrow)"/>
  <circle class="evo-core" cx="320" cy="220" r="62"/>
  <text class="evo-core-label" x="320" y="214" text-anchor="middle">Population</text>
  <text class="evo-core-note" x="320" y="236" text-anchor="middle">each generation is</text>
  <text class="evo-core-note" x="320" y="252" text-anchor="middle">training data</text>
  <g>
    <rect class="evo-stage" x="20" y="20" width="262" height="130" rx="8"/>
    <text class="evo-step" x="40" y="52">1 · Selection</text>
    <text class="evo-classic" x="40" y="82">was: fixed tournament rule</text>
    <text class="evo-ours" x="40" y="114">Deep Tournament</text>
    <text class="evo-ours" x="40" y="136">Selection</text>
  </g>
  <g>
    <rect class="evo-stage" x="358" y="20" width="262" height="130" rx="8"/>
    <text class="evo-step" x="378" y="52">2 · Crossover</text>
    <text class="evo-classic" x="378" y="82">was: random cut points</text>
    <text class="evo-ours" x="378" y="114">Deep Neural</text>
    <text class="evo-ours" x="378" y="136">Crossover</text>
  </g>
  <g>
    <rect class="evo-stage" x="358" y="290" width="262" height="130" rx="8"/>
    <text class="evo-step" x="378" y="322">3 · Mutation</text>
    <text class="evo-classic" x="378" y="352">was: random gene changes</text>
    <text class="evo-ours" x="378" y="384">BERT Mutation</text>
    <text class="evo-ours-sub" x="378" y="406">for GP and for GAs</text>
  </g>
  <g>
    <rect class="evo-stage" x="20" y="290" width="262" height="130" rx="8"/>
    <text class="evo-step" x="40" y="322">4 · Evaluation</text>
    <text class="evo-classic" x="40" y="352">was: simulate every individual</text>
    <text class="evo-ours" x="40" y="384">ML Fitness</text>
    <text class="evo-ours" x="40" y="406">Approximation</text>
  </g>
</svg>
<figcaption>Each stage of the loop, the classical operator it used, and the learned operator that replaces it.</figcaption>
</figure>

## Crossover: Deep Neural Crossover

Deep Neural Crossover (DNC) is a multi-parent crossover operator for GAs. An encoder embeds each parent's genes in a shared latent space, much as language models embed words, and an LSTM summarizes each parent. A decoder with a pointer network then builds the child one gene at a time, choosing which parent to copy from at each position based on the genes chosen so far. Trained with the child's fitness as reward, DNC learns linear and non-linear correlations between genes that random crossover ignores, and it outperformed all baseline operators on two benchmark domains. A transfer-learning variant trains on one problem instance and reuses the network on others from the same domain.

Learned operators cost energy as well as time. A follow-up study profiled DNC's power consumption and introduced a fitness-based training schedule, which runs backpropagation only after a meaningful fitness improvement. The schedule cuts energy use considerably while keeping solution quality close to, and sometimes better than, the best configurations.

<figure class="paper-figure">
<img src="{{ '/assets/img/research/dl-operators/dnc-encoder.png' | relative_url }}" alt="DNC encoder: the genomes of two parents are embedded gene by gene and processed by LSTM encoders into a joint embedded representation of both parents." width="1000" height="404" loading="lazy">
<figcaption>The DNC encoder embeds both parents' genomes into a shared representation. From <cite>Deep Neural Crossover</cite> (GECCO 2024).</figcaption>
</figure>

## Mutation: BERT Mutation

BERT Mutation borrows masked language modeling from natural-language processing. For GP, an individual's tree is written out as a sequence of tokens, some nodes are masked, and a BERT transformer predicts replacements for the masks one at a time. Sampling is restricted to valid choices, so a terminal is replaced only by a terminal and a function only by a function of the same arity. The model is trained with reinforcement learning to prefer replacements that raise fitness. Across symbolic regression, classification and the Artificial Ant problem, it outperformed conventional and state-of-the-art mutation operators in both convergence speed and solution quality.

<figure class="paper-figure">
<img src="{{ '/assets/img/research/dl-operators/bert-mutation-gp.png' | relative_url }}" alt="Two steps of BERT mutation on the expression tree string: BERT outputs a probability for every token, illegal tokens are masked out, and a replacement is sampled before the next mask is filled." width="982" height="463" loading="lazy">
<figcaption>BERT Mutation fills masked tree nodes one at a time, sampling only legal replacements. From <cite>BERT Mutation</cite> (<em>Mathematics</em>, 2025).</figcaption>
</figure>

Extending the idea to GAs is harder: a fixed-length integer or binary vector has no explicit structure for the model to read, a problem we call *semantic opacity*. BERT Mutation for GAs overcomes it with a data-augmentation strategy that builds pseudo-training examples leading toward the population's elite. On Frozen Lake, Artificial Ant, Graph Coloring and Set Cover, it beat One-Point, Uniform, Zigzag and adaptive operator selection, reaching better average fitness in about half the wall-clock time and fewer than half the generations, while preserving population diversity.

<figure class="paper-figure">
<img src="{{ '/assets/img/research/dl-operators/bert-mutation-ga-fitness.png' | relative_url }}" alt="Four line charts of best fitness per generation on Set Cover, Graph Coloring, Artificial Ant and Frozen Lake. In every domain, BERT Mutation's curve reaches the best fitness, ahead of One-Point, Uniform, Zigzag and AOS." width="950" height="640" loading="lazy">
<figcaption>Best fitness per generation (mean of 10 runs); dots mark equal-runtime cutoffs. From <cite>BERT Mutation for Genetic Algorithms</cite> (PPSN 2026).</figcaption>
</figure>

## Selection: Deep Tournament Selection

Selection decides how strongly the search exploits good solutions versus exploring new ones, yet classical schemes apply the same rule throughout the run. Deep Tournament Selection (DTS) reformulates tournament selection as a Markov decision process. A Transformer encoder with global and local rank-based positional encodings scores the candidates in each tournament, and a self-attention pointer picks the winner. The policy is trained fully online, needs no extra fitness evaluations, and adjusts its selection pressure as the population evolves. On Graph Coloring, Set Cover and the Traveling Salesman Problem, DTS converged faster and found better solutions than classical and dynamic selection baselines, with negligible overhead and no loss of diversity.

<figure class="paper-figure">
<img src="{{ '/assets/img/research/dl-operators/deep-tournament-selection.png' | relative_url }}" alt="DTS architecture: for each tournament, individuals and their global and local ranks are embedded, a contextual tournament evaluation produces a selection policy, a parent is sampled into the new population, and a policy-gradient update trains all components." width="960" height="660" loading="lazy">
<figcaption>Deep Tournament Selection: embed, evaluate in context, sample, then update the policy. From <cite>Deep Tournament Selection</cite> (PPSN 2026).</figcaption>
</figure>

## Evaluation: fitness approximation

When fitness comes from a costly simulator, the cheapest evaluation is the one you never run. Our fitness-approximation method trains a machine-learning model on every individual evaluated so far and lets the GA switch dynamically between two modes. In *evolution mode*, every individual is simulated. In *prediction mode*, only a sample of the population is simulated, the rest receive the model's prediction, and the model is retrained before the next generation. Evaluated on agents evolved in Gymnasium game simulators, the approach cut runtimes significantly while reaching fitness identical to, or slightly below, a fully simulated GA.

<figure class="paper-figure">
<img src="{{ '/assets/img/research/dl-operators/fitness-approximation.png' | relative_url }}" alt="Flowchart: the GA checks a switch condition; in evolution mode the whole population is simulated, in prediction mode only a sample is; simulated scores update a population database that retrains the ML model, which supplies approximate scores for the rest." width="1000" height="452" loading="lazy">
<figcaption>Switching between full simulation and ML-predicted fitness. From <cite>Fitness Approximation Through Machine Learning</cite> (<em>Information</em>, 2024).</figcaption>
</figure>

## Papers

<div class="pub-papers">
<ol class="pub-list">
{%- for key in page.papers -%}
  {%- capture entry -%}{% bibliography --query @*[key={{ key }}] %}{%- endcapture -%}
  {{ entry | replace: '<ol class="bibliography">', "" | replace: "</ol>", "" | replace: "<bib-item>", "" | replace: "</bib-item>", "" }}
{%- endfor %}
</ol>
</div>
