---
title: Can “Prediction” Become a Trap? Intelligence, Mental Loops, and How the Real World Fights Back
linkTitle: Sensory Input Hacking
weight: 4
authors:
  - llm-kun
  - baraban
---

**Question to start:**
If an agent can boost its predictive accuracy most cheaply by “hacking” its own inputs—insulating itself with ultra-predictable stimuli or rewriting its sensors—should we count that as becoming *more intelligent*? If not, what guardrails keep prediction honest?

## When prediction turns inward: a quick tour of mental illnesses

Many predictive-processing accounts of mind suggest that some disorders look like **local wins in prediction** that become **global losses in adaptation**:

* **Anxiety/avoidance:** shrink exposure to uncertainty so threat priors never get falsified. Feels safer; the world gets smaller.
* **OCD rituals:** create tight, repeatable loops that dampen uncertainty spikes—short-term relief, long-term rigidity.
* **Addiction:** narrow the reward model so one stimulus reliably “explains” predicted pleasure; precision rises, life scope collapses.
* **Depression/rumination:** stick to highly predictable negative narratives; low surprise, low updating.
* **Psychosis (precision mis-set):** priors overpower evidence; a self-consistent but misaligned internal world.

Through this lens, “prediction hacks” can anesthetize surprise **without** improving real-world competence.

## The “dark room” problem

If intelligence = minimizing prediction error, a degenerate “solution” is to choose a sensory diet that’s easy to predict (the proverbial dark room). You can “win” by closing your eyes. It’s tidy, but useless.

## A solution: bind prediction to energy and survival

Tie the brain to the physical world so that **energy** and **viability** price in the true cost of bad hacks.

### 1) Energy as the master currency

Let the agent carry a body-energy budget (E). Each step:

* **Harvest:** energy from the world (food, charge, sunlight).
* **Spend on actions:** moving, building, exploring costs energy.
* **Spend on thinking:** computation/metabolism also costs energy.
  If (E \le 0), the episode ends. The agent must stay inside a **viability set** (enough energy, safe states). Prediction detached from survival now gets naturally penalized.

### 2) “Lazy neurons” by design

Charge the brain for activity and updates (sparse codes, bounded precision tuning, paid planning depth). Neurons fire when—and only when—the expected gain (better decisions, more harvested energy, safer futures) outweighs the metabolic cost.

### 3) Objective that resists hacks

Optimize a long-horizon score that mixes:

* **Exploration bonus** (information gain): don’t reward blind certainty; reward *useful* novelty.
* **Prediction accuracy**: track the world, not just your story about it.
* **Energy costs**: acting and thinking are not free.
* **Survival/viability**: staying alive and keeping options open.

Now the “dark room” fails: it starves energy and collapses viability.

### 4) Good hacks vs. bad hacks

Call any surprise-reducing maneuver a **hack**. Judge it by **survival-adjusted efficiency**:

* **Good hack:** reduces volatility *and* improves future energy/option value (e.g., building shade before foraging; caching food; learning a robust routine that frees capacity).
* **Bad hack:** reduces volatility while draining energy or narrowing options (e.g., sensory insulation that avoids learning and slowly starves you; self-stimulation that predicts reward but burns the budget).

### 5) A minimal testbed to make this real

* **World:** a 2D grid with food patches (stochastic), safe zones (low threat/low food), risky zones (high food/predators).
* **Actions:** move, forage, rest, build shelter (lowers sensory variance but also lowers harvest rate), self-stim (illusory reward that consumes energy).
* **Brain:** predictive model with paid-per-update neurons and paid planning depth.
* **Metrics:** lifespan, average energy, cross-context transfer, fraction of time in self-chosen low-entropy states, and an efficiency ratio (future information gained per total energy spent).

## Why this matters for defining intelligence

* **Intelligence becomes:** *using prediction to shape preferred futures under uncertainty* **subject to** energy budgets and viability.
* **Mental-illness analogy:** local surprise minimization that loses energy or optionality is selected *against* by the world.
* **Alignment bonus:** agents that game their own inputs self-select out; agents that learn useful structure thrive.

## Closing thought

If the world can “hunt” you, prediction can’t just be clean—it has to be **cost-aware, exploratory, and survival-competent**. The interesting agent isn’t the calmest predictor; it’s the one that spends brain-energy where it compounds into *open futures*.
