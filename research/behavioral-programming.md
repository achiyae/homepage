---
title: "Behavioral Programming"
layout: default
permalink: /research/behavioral-programming/
# BibTeX keys from _bibliography/publications.bib, listed at the end of each topic (newest first).
papers:
  semantics:
  - yaacov2025adding
  - Yaacov2024Liveness
  - Elyasaf2023BPPN
  - Elyasaf2020COBP
  context:
  - Elyasaf2020COBP
  - Elyasaf2018LSC4IoT
  - Elyasaf2018IntegrationContextBased
  ml:
  - yaacov2025adding
  - Harel2024CategorizingMethodsIntegrating
  - Yerushalmi2023EnhancingDRL
  - Yerushalmi2022ScenarioassistedDeep
  - Katz2021TowardsCombiningDeep
  - Elyasaf2019RoboCup
  generation:
  - Yaacov2024BoostingLLMBP
  - Poliansky2022BPGP
  testing:
  - Elyasaf2023GeneralizedCoverageCriteria
  - BarSinai2023ProvengoToolSuite
---
<p class="breadcrumb"><a href="{{ '/research/' | relative_url }}">Research</a></p>

# Behavioral Programming

Requirements documents describe a system one behavior at a time: "lower the gate when a train approaches", "never raise it while a train is inside". Most code does not look like that. A single requirement ends up spread across many functions, and a single function serves many requirements. Behavioral programming (BP) is a scenario-based paradigm that keeps the two aligned, and our group has been extending it since 2018.

## How behavioral programs run

A behavioral program is a set of independent modules called *b-threads*, each implementing one requirement or scenario. B-threads run in lockstep. At every synchronization point, each b-thread declares which events it *requests*, which it *waits for* and which it *blocks*. An event arbiter then selects an event that is requested and not blocked, and notifies the b-threads that requested or waited for it. Because the protocol does the composition, a new requirement is added as a new b-thread without changing existing ones, and a requirement that forbids something is written as a b-thread that blocks it. The same model can be executed, simulated, or explored exhaustively for verification.

<figure class="evo-loop">
<svg viewBox="0 0 640 500" role="img" aria-labelledby="bp-cycle-title bp-cycle-desc">
  <title id="bp-cycle-title">The behavioral programming execution cycle and our research directions</title>
  <desc id="bp-cycle-desc">In the center, b-threads declare the events they request, wait for and block; an event arbiter selects an event that is requested and not blocked and notifies the b-threads. Around it are five research directions, each linking to its section below: semantics, context, machine learning, automatic generation and testing.</desc>
  <defs>
    <marker id="bp-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
      <path d="M0 0 L10 5 L0 10 z" class="evo-arrowhead"/>
    </marker>
  </defs>
  <path class="bp-tie" d="M165 130 V158 M475 130 V158 M113 342 V370 M320 342 V370 M527 342 V370"/>
  <rect class="evo-core" x="20" y="158" width="600" height="184" rx="8"/>
  <text class="evo-step" x="40" y="186">The BP execution cycle</text>
  <rect class="bp-thread" x="40" y="202" width="214" height="32" rx="6"/>
  <text class="evo-classic" x="54" y="223">b-thread · requests A</text>
  <rect class="bp-thread" x="40" y="244" width="214" height="32" rx="6"/>
  <text class="evo-classic" x="54" y="265">b-thread · waits for B</text>
  <rect class="bp-thread" x="40" y="286" width="214" height="32" rx="6"/>
  <text class="evo-classic" x="54" y="307">b-thread · blocks C</text>
  <path class="evo-flow" d="M266 234 H372" marker-end="url(#bp-arrow)"/>
  <text class="evo-core-note" x="319" y="225" text-anchor="middle">declare</text>
  <path class="evo-flow" d="M372 288 H266" marker-end="url(#bp-arrow)"/>
  <text class="evo-core-note" x="319" y="308" text-anchor="middle">notify</text>
  <rect class="evo-stage" x="384" y="202" width="216" height="116" rx="8"/>
  <text class="evo-core-label" x="492" y="236" text-anchor="middle">Event arbiter</text>
  <text class="evo-classic" x="492" y="262" text-anchor="middle">selects an event that is</text>
  <text class="evo-classic" x="492" y="284" text-anchor="middle">requested and not blocked</text>
  <a class="evo-link" href="#semantics">
    <rect class="evo-stage" x="20" y="20" width="290" height="110" rx="8"/>
    <text class="evo-step" x="40" y="50">Semantics</text>
    <text class="evo-ours" x="40" y="82">What BP can express</text>
    <text class="evo-ours-sub" x="40" y="110">composition · liveness</text>
  </a>
  <a class="evo-link" href="#context">
    <rect class="evo-stage" x="330" y="20" width="290" height="110" rx="8"/>
    <text class="evo-step" x="350" y="50">Context</text>
    <text class="evo-ours" x="350" y="82">Context idioms</text>
    <text class="evo-ours-sub" x="350" y="110">LSC idioms · COBP</text>
  </a>
  <a class="evo-link" href="#ml">
    <rect class="evo-stage" x="20" y="370" width="186" height="110" rx="8"/>
    <text class="evo-step" x="36" y="400">Machine learning</text>
    <text class="evo-ours" x="36" y="432">Guided DRL</text>
    <text class="evo-ours-sub" x="36" y="460">scenarios as rules</text>
  </a>
  <a class="evo-link" href="#generation">
    <rect class="evo-stage" x="227" y="370" width="186" height="110" rx="8"/>
    <text class="evo-step" x="243" y="400">Generation</text>
    <text class="evo-ours" x="243" y="432">GP and LLMs</text>
    <text class="evo-ours-sub" x="243" y="460">code from requirements</text>
  </a>
  <a class="evo-link" href="#testing">
    <rect class="evo-stage" x="434" y="370" width="186" height="110" rx="8"/>
    <text class="evo-step" x="450" y="400">Testing</text>
    <text class="evo-ours" x="450" y="432">Test suites</text>
    <text class="evo-ours-sub" x="450" y="460">coverage · Provengo</text>
  </a>
</svg>
<figcaption>The BP execution cycle and the directions in which we extend it. Select a direction to jump to its section.</figcaption>
</figure>

## Semantics and expressiveness <a class="to-top" href="#main">Back to top</a> {#semantics}

BP's central claim is that the execution protocol, not the modeler, should combine requirements. [What Petri Nets Oblige Us to Say](#semantics-Elyasaf2023BPPN) tests that claim against Petri nets. When several requirements share one net, the modeler must also specify how they combine, which leads to over-specification, missed execution paths and unintended ones. BP avoids this while keeping the same mathematical properties. [Context-Oriented Behavioral Programming](#semantics-Elyasaf2020COBP) gives formal semantics, and two implementations, for b-threads that read and update a context data model, so verification and reasoning apply to context-aware programs too.

The original protocol can only enforce safety: what the system must not do. We added a *must-finish* idiom that marks states in which a task is still pending, so liveness requirements such as "do X at least three times" are written directly as b-threads ([RE 2024](#semantics-Yaacov2024Liveness)). The [journal version](#semantics-yaacov2025adding) adds two execution mechanisms, one through Büchi automata and one through Markov decision processes, and a user study showing that the idiom improves the alignment between code and requirements.

<div class="topic-papers">
<h3>Papers</h3>
{% include paper-list.html topic="semantics" keys=page.papers.semantics %}
</div>

## Context-oriented behavioral programming <a class="to-top" href="#main">Back to top</a> {#context}

IoT devices and robots behave differently depending on their situation, and flat scenario specifications become unwieldy as conditions, exceptions and refinements pile up. We first proposed subjecting scenarios in live sequence charts (LSC) to context, using existing LSC idioms or embedding the charts in statecharts ([2018](#context-Elyasaf2018IntegrationContextBased)), and then added dedicated context idioms to LSC for [IoT systems](#context-Elyasaf2018LSC4IoT). [COBP](#context-Elyasaf2020COBP) carries these ideas into BP. Each b-thread states when it is relevant and what data it needs through queries on a context model, so context-dependent behavior stays aligned with the requirements. Case studies in robotics and IoT showed advantages over BP alone and over context-oriented programming alone.

<div class="topic-papers">
<h3>Papers</h3>
{% include paper-list.html topic="context" keys=page.papers.context %}
</div>

## Scenarios and machine learning <a class="to-top" href="#main">Back to top</a> {#ml}

Deep reinforcement learning (DRL) agents perform well, but they are opaque and may violate requirements that engineers care about. Scenarios are small, readable and verifiable, which makes them a natural complement. For a simplified [RoboCup-type game](#ml-Elyasaf2019RoboCup), we built four BP controllers, extending the base protocol with a constraint solver, context idioms and a DRL component. A [position paper](#ml-Katz2021TowardsCombiningDeep) outlines how scenarios, together with verification, can guard and repair neural-network controllers. [Scenario-assisted DRL](#ml-Yerushalmi2022ScenarioassistedDeep) and its [journal extension](#ml-Yerushalmi2023EnhancingDRL) inject expert scenarios into the reward function during training. In internet congestion control, the resulting agents were far more likely to obey the specified constraints, and the scenarios help explain their decisions. In the other direction, the [MDP-based execution of must-finish requirements](#ml-yaacov2025adding) scales through DRL.

Our [survey](#ml-Harel2024CategorizingMethodsIntegrating) gives a framework for categorizing the ways machine learning can be integrated with executable specifications, and guidelines for choosing among them during system development.

<div class="topic-papers">
<h3>Papers</h3>
{% include paper-list.html topic="ml" keys=page.papers.ml %}
</div>

## Automatic generation of behavioral programs <a class="to-top" href="#main">Back to top</a> {#generation}

Because each b-thread implements one requirement, behavioral programs are small, regular and checkable, which makes them a good target for automatic generation. [Evolution of Behavioral Programs](#generation-Poliansky2022BPGP) uses genetic programming with COBP to evolve complete programs from scratch. The evolved tic-tac-toe player loses or misses a win in fewer than one percent of the possible cases, consists of readable modules that resemble the handcrafted program, and was verified over all execution paths. [Boosting LLM-based software generation](#generation-Yaacov2024BoostingLLMBP) uses BP as the design for LLM code generation. Each requirement, including the scenarios that must not happen, is translated into its own module without a global view of the system, and on a railway level-crossing controller the generated BP code aligned with the requirements better than plain Python.

<div class="topic-papers">
<h3>Papers</h3>
{% include paper-list.html topic="generation" keys=page.papers.generation %}
</div>

## Scenario-driven testing <a class="to-top" href="#main">Back to top</a> {#testing}

The same modularity serves testing: small b-threads describe the behaviors to exercise, and the execution engine explores their combinations. [Generalized coverage criteria](#testing-Elyasaf2023GeneralizedCoverageCriteria) specify what a suite of action sequences must cover. A tool generates optimized test suites from test plans, and a Bayesian method estimates the remaining risk, balancing exploration against exploitation. [Provengo](#testing-BarSinai2023ProvengoToolSuite), built on the BPjs engine, implements scenario-driven model-based testing. Testers write user stories as scenarios and grow the model incrementally, starting from simple stories.

<div class="topic-papers">
<h3>Papers</h3>
{% include paper-list.html topic="testing" keys=page.papers.testing %}
</div>
