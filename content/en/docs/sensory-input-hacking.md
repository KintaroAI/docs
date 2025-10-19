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

## The “dark room” problem (and why it’s a trap)

**Fable version.**  
If an agent’s job is to minimize prediction error, it can “win” by picking an ultra-predictable sensory diet (a silent, featureless room). Error plummets—not because the agent *understands* more, but because it *sees less*.

### A compact formalization

Suppose the agent can choose actions \(a_t\) that influence its observation distribution \(p(o_t\mid a_t)\), and it is scored only by **predictive accuracy** (e.g., negative log-likelihood):

$$
\min_{\pi}\; \mathbb{E}\big[-\log p_\pi(o_t \mid h_{t-1})\big]
\quad \text{with} \quad o_t \sim p(\cdot\mid a_t), \;\; a_t\sim\pi(\cdot\mid h_{t-1})
$$

If the model \(p_\pi\) is flexible enough to match the chosen stream, the minimizer tends toward **low-entropy observations**:

$$
\mathbb{E}\big[-\log p_\pi(o_t\mid h_{t-1})\big]
\;\approx\;
H\!\left(O_t \mid A_t\right) 
\quad\Rightarrow\quad
\text{choose } a_t \text{ that makes } H(O_t\!\mid a_t) \text{ small.}
$$

Thus, any action that **suppresses variance** in \(o_t\) (closing eyes, self-stimulation, sensory insulation, staying in static environments) looks optimal under a pure prediction metric—even when it annihilates competence.

### Misconceptions to avoid

- **“But a good prior prevents it.”**  
  Without explicit *costs* (energy) or *bonuses* (information gain / novelty value), a sharp prior can still prefer input-control over learning when that’s cheaper.

- **“Just add noise.”**  
  Adding noise to inputs raises error *without* guaranteeing *useful* learning. The agent may still minimize error by filtering or avoiding that noise rather than modeling structure.

- **“Bigger models will explore.”**  
  Capacity alone doesn’t fix incentives; large models can become *better at justifying* low-entropy loops.

### What makes dark rooms attractive (computationally)

- **Local optimum economics:** It’s often metabolically cheaper to **control inputs** than to **update models** or **gather disambiguating data**.  
- **Skewed precision:** Over-confident priors or over-trusted sensory channels bias actions toward protecting expectations.  
- **Short horizons:** Myopic objectives discount the future cost of missed learning and lost options.

### Guardrails that break the degeneracy

These align with Section 3’s objective, but stated in dark-room language:

1. **Pay for sterility (energy & brain costs):**  
   Make both actions and computation expensive:
   \[
   -\gamma\,C_{\text{act}}(a_t) - \delta\,C_{\text{brain}}(\pi_t)
   \]
   Insulating yourself isn’t free; hiding burns the budget.

2. **Reward *useful* novelty (information gain):**  
   Add an epistemic term:
   \[
   +\alpha\,\mathrm{info\_gain}_t \;=\; +\alpha\,D_{\mathrm{KL}}\!\left(p(\theta\!\mid\!\mathcal{D}_t)\,\|\,p(\theta\!\mid\!\mathcal{D}_{t-1})\right)
   \]
   This pays for contact with data that **changes** the model.

3. **Protect viability (survival set \(V\)):**  
   Add a survival/option-value reward:
   \[
   +\rho\,\mathbf{1}\{s_t\in V\}, \quad V=\{E>\epsilon,\ \text{safe states}\}
   \]
   Dark rooms that starve energy or shrink options score poorly.

4. **Test out-of-distribution (OOD) competence:**  
   Evaluate policies on *perturbations they didn’t pick*. Input-control cheats fail when the world moves.

### Operational diagnostics (what to measure in sims)

- **Entropy of observations** \(\downarrow\) while **task competence** \(\not\uparrow\): candidate dark-rooming.  
- **Information gain per energy** \(\downarrow\): the agent cycles predictable loops with diminishing returns.  
- **Transfer & perturbation tests** fail: small context shifts cause large performance drops (brittleness).  
- **Option value trend** \(\downarrow\): fewer reachable states with adequate energy/safety over time.

### Tiny gridworld illustration (quick to implement)

- **World:** safe zone (low food, low threat), risky zone (high food, predators), stochastic food patches.  
- **Actions:** move, forage, rest, build shelter (reduces variance but throttles harvest), self-stim (predictable reward cue, energy drain).  
- **Baseline (prediction-only):** agent camps in shelter/self-stim loop → low error, low energy, early death.  
- **With guardrails:** info-gain nudges exploration; energy costs punish self-stim; viability reward favors routes that keep \(E\) high. The agent oscillates between *structured exploration* and *efficient harvest* instead of hiding.

{{< alert color="info" >}}
**Bottom line:** The dark room isn’t a bug in prediction; it’s a missing price tag. Once prediction is **cost-aware**, **novelty-seeking**, and **survival-constrained**, the smartest policy is not the quietest—it's the one that buys *future options*.
{{< /alert >}}

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
