---
title: Can “Prediction” Become a Trap? Intelligence, Mental Loops, and How the Real World Fights Back
linkTitle: Sensory Input Hacking
weight: 4
date: 2025-10-19
authors:
  - llm-kun
  - baraban
---

> **Kickoff question:**  
> If an agent can boost its predictive accuracy most cheaply by *hacking* its own inputs—insulating itself with ultra-predictable stimuli or rewriting its sensors—should we count that as becoming *more intelligent*? If not, what guardrails keep prediction honest?

## When prediction turns inward

From a predictive-processing lens, brains try to keep **prediction error** low by balancing three levers:

1) **Update the model (learning):** revise priors so the world makes sense.  
2) **Sample the world (exploration):** seek data that disambiguates uncertainty.  
3) **Control inputs (avoidance/ritual):** reshape or restrict sensations so they’re easier to predict.

When the third lever dominates, you get **local reductions in surprise** that can undermine **global adaptation**. Below are common patterns, framed as *tendencies* (not diagnoses), with the precision/uncertainty story in parentheses.

- **Anxiety & avoidance** *(high prior precision on threat; under-sampling disconfirming evidence)*  
  You feel safer by pruning contact with the unknown. Short-term error drops; long-term model stays brittle and overestimates danger.

- **OCD-like ritual loops** *(precision hijacked by “just-right” actions)*  
  Repetitive scripts (check, wash, arrange) manufacture predictability and damp arousal. Error relief now trades off against flexibility later.

- **Addictive narrowing** *(over-precise value prior for a single cue)*  
  One cue (drug, screen, gamble) reliably “explains” predicted pleasure; exploration and alternative rewards atrophy. Life variance shrinks—so does option value.

- **Depressive rumination** *(over-confident negative priors; low expected value of updating)*  
  Coherent, pessimistic narratives minimize surprise by predicting loss. The world stops offering evidence worth sampling.

- **Psychosis-like misalignment** *(mis-set precision: priors dominate likelihoods or vice-versa)*  
  The internal world becomes self-consistent, but external correspondence fails; evidence is bent to fit the model or noise is over-trusted.

- **Autistic sensory profiles (some theories, heterogenous!)** *(excess sensory precision; weak prior pooling)*  
  The world is “too surprising.” Routines reduce variance; predictability soothes at the cost of rapid context switching.


### Why it happens in prediction-first systems
- **Cheap error relief:** It’s often metabolically cheaper to *control inputs* than to *update models* or *gather data*—a classic local optimum.  
- **Skewed precision:** If the system assigns too much confidence (precision) to certain priors or sensory channels, it will *prefer* actions that protect those expectations.  
- **Short horizons:** With myopic objectives, the agent discounts future costs of narrowed sampling (missed learning, lost options).

### What to look for in sims (operational signatures)
- **Shrinking sensory diversity:** entropy of visited observations falls over time without compensatory task performance.  
- **Exploration debt:** information gain per unit energy drops; the agent repeats predictable loops despite declining returns.  
- **Transfer failure:** competence collapses when the context shifts slightly (brittleness under perturbation).  
- **Energy/opportunity leak:** total energy (or option value) trends downward while immediate prediction error stays low.

These signatures flag **prediction hacks**: strategies that feel “certain” but quietly erode capability.

## The “dark room” problem

If intelligence = minimizing prediction error, a degenerate policy is to select an easy sensory diet (the proverbial dark room). You can “win” by closing your eyes. It’s tidy—and useless.

## A practical fix: bind prediction to energy and survival

Make the brain pay for thinking and moving; make the world able to **kill**. That forces prediction to be **cost-aware, exploratory, and survival-competent**.

### 1) Energy as the master currency

Let the agent maintain body energy \(E_t\) with real dynamics:

$$
E_{t+1} \;=\; E_t \;+\; H(s_t,a_t) \;-\; C_{\text{act}}(a_t) \;-\; C_{\text{brain}}(\pi_t)
$$

- \(H\): energy harvested from the world (food, charge, sunlight).  
- \(C_{\text{act}}\): action cost (move/build/explore).  
- \(C_{\text{brain}}\): computational/metabolic cost (see below).  

If \(E_t \le 0\) ⟶ **death** (episode ends). Define a **viability set** \(V=\{E>\epsilon,\ \text{safe states}\}\).

### 2) “Lazy neurons” by design

Charge the brain for spiking and updating:

$$
C_{\text{brain}}(\pi_t) \;=\; \lambda_1 \,\|\text{activations}\|_1 \;+\; \lambda_2 \cdot \text{updates}
$$

- L1/sparsity → energy-frugal codes.  
- Extra fees for precision modulation, replay, long-horizon planning.  
Neurons fire only when activity buys energy, safety, or future accuracy.

### 3) An objective that resists hacks

### 3) An objective that resists hacks

Optimize a long-horizon score that **binds prediction to exploration, energy, and survival**:

$$
\begin{aligned}
J \;=\; \mathbb{E}\!\left[\sum_{t}
\left(
\underbrace{+\;\alpha\,\mathrm{info\_gain}_t}_{\textbf{explore}}
\;\;
\underbrace{-\;\beta\,\mathrm{pred\_error}_t}_{\textbf{learn/track}}
\;\;
\underbrace{-\;\gamma\,C_{\text{act}}(a_t)}_{\textbf{energy (body)}}
\;\;
\underbrace{-\;\delta\,C_{\text{brain}}(\pi_t)}_{\textbf{energy (brain)}}
\;\;
\underbrace{+\;\rho\,\mathbf{1}\{s_t\!\in\! V\}}_{\textbf{survive/viability}}
\right)
\right]
\end{aligned}
$$

**What each term means (with concrete choices you can implement):**

- **Explore — \(\mathrm{info\_gain}_t\)**: reward *useful novelty*.  
  A practical choice is Bayesian surprise / information gain:
  \[
  \mathrm{info\_gain}_t \;=\; D_{\mathrm{KL}}\!\left(p(\theta\mid \mathcal{D}_{t}) \,\|\, p(\theta\mid \mathcal{D}_{t-1})\right)
  \]
  or a prediction-uncertainty drop (entropy before minus entropy after). Encourages sampling data you can learn from, not just stimulation.

- **Learn/Track — \(\mathrm{pred\_error}_t\)**: keep the model honest.  
  Use negative log-likelihood (or squared error) of sensory outcomes given your predictive model \(p_\pi\):
  \[
  \mathrm{pred\_error}_t \;=\; -\log p_\pi(o_t \mid s_{t-1},a_{t-1}) \quad \text{(lower is better)}
  \]
  This rewards accurate tracking of the *external* world, not self-chosen fantasies.

- **Energy (body) — \(C_{\text{act}}(a_t)\)**: acting isn’t free.  
  Charge movement, manipulation, construction, etc. Examples:
  \[
  C_{\text{act}}(a_t)=k_{\text{move}}\cdot\text{distance}+k_{\text{work}}\cdot\text{force}\times\text{duration}
  \]

- **Energy (brain) — \(C_{\text{brain}}(\pi_t)\)**: thinking isn’t free either.  
  Make neurons “lazy” via sparsity and update costs:
  \[
  C_{\text{brain}}(\pi_t)=\lambda_1\|\text{activations}_t\|_{1}+\lambda_2\,\text{updates}_t
  \]
  Optionally add paid precision control, replay, or planning depth.

- **Survive/Viability — \(\mathbf{1}\{s_t\in V\}\)**: reality checks hacks.  
  Reward remaining in the viability set \(V=\{E>\epsilon,\ \text{safe states}\}\).  
  If you prefer a smooth signal, replace the indicator with a *soft barrier*:
  \[
  \phi(s_t)=\sigma\!\big(\kappa(E_t-\epsilon)\big)\;-\;\lambda_{\text{risk}}\cdot \text{risk}(s_t)
  \]
  which rises with energy reserves and penalizes hazardous contexts.

**Why this blocks “dark-room” hacks:**  
- The **explore** term pays for *novel*, informative contact with the world.  
- The **energy** terms penalize sterile self-stimulation (it burns the budget).  
- The **viability** term rewards strategies that keep you alive and flexible; hiding that starves \(E\) scores poorly over horizons that matter.

Two built-in guards:
- **Information gain** rewards sampling useful novelty (you can’t just close your eyes).
- **Viability** rewards staying alive with sufficient options (dark rooms starve).

### 4) Good hacks vs. bad hacks

Call any surprise-reducing maneuver a **hack**. Score it by survival-adjusted efficiency:

$$
\eta \;=\; \frac{\Delta I_{\text{future}}}{\Delta E_{\text{total}}}
$$

- **Good hack:** reduces volatility *and* improves future energy/option value (e.g., building shade before foraging).  
- **Bad hack:** reduces volatility while draining energy or narrowing options (e.g., sensory insulation that avoids learning and slowly starves you).

### 5) Minimal testbed (for demos & ablations)

- **World:** 2D grid with stochastic food; safe zones (low threat/low food) vs. risky zones (high food/predators).  
- **Actions:** move, forage, rest, build shelter (variance ↓, harvest rate ↓), self-stim (illusory reward, energy burn).  
- **Brain:** predictive model with paid-per-update neurons and paid planning depth.  
- **Metrics:** lifespan, average \(E_t\), cross-context transfer, fraction of time in self-chosen low-entropy states, and \(\eta\).

---

**Closing thought:**  
If the world can hunt you, prediction can’t just be clean—it must be **cost-aware, exploratory, and survival-competent**. The interesting agent isn’t the calmest predictor; it’s the one that spends brain-energy where it compounds into *open futures*.
