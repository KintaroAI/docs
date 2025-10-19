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

### 5) Minimal testbed (for demos, diagnostics & ablations)

A tiny yet expressive sandbox that makes “good vs. bad hacks” measurable.

#### 5.1 World layout & dynamics

- **Grid:** \(N\times N\) cells (e.g., \(N=21\)).  
- **Zones:**
  - **Safe zone \(Z_{\text{safe}}\):** low threat, **low food renewal**.
  - **Risky zone \(Z_{\text{risk}}\):** predators present, **high food renewal**.
  - **Shelter tiles:** buildable structures that **lower observation variance** but **throttle harvest** locally.
- **Food field \(F_t(x)\):** stochastic birth–death process:
  \[
  F_{t+1}(x) \sim \text{Binomial}\!\left(F_{\max},\; p_{\text{grow}}(x)\right),\quad
  p_{\text{grow}}(x)=
  \begin{cases}
  p_{\text{safe}} & x\in Z_{\text{safe}}\\
  p_{\text{risk}} & x\in Z_{\text{risk}}
  \end{cases}
  \]
  with \(p_{\text{risk}} > p_{\text{safe}}\).
- **Predators:** Poisson arrivals in \(Z_{\text{risk}}\); contact drains energy or ends episode with probability \(p_{\text{death}}\).

#### 5.2 State, actions, observations

- **Hidden state \(s_t\):** agent pose, energy \(E_t\), local food \(F_t\), shelter map, predator positions (partially observed).  
- **Action set \(a_t\in\{\text{move}_{\{\uparrow,\downarrow,\leftarrow,\rightarrow\}},\ \text{forage},\ \text{rest},\ \text{build\_shelter},\ \text{self\_stim}\}\).**  
- **Observations \(o_t\):** local egocentric patch (e.g., \(5\times5\)), proprioception, noisy predator cues. Shelter reduces observation variance \(\operatorname{Var}(o_t)\).

#### 5.3 Energy & survival (hard constraints)

Recall the energy ledger:
$$
E_{t+1}=E_t+H(s_t,a_t)-C_{\text{act}}(a_t)-C_{\text{brain}}(\pi_t)
$$

- **Harvest \(H\):** if \(\text{forage}\), then \(H\sim \text{Binomial}(F_t(x),p_{\text{harv}})\).  
- **Action cost \(C_{\text{act}}\):**
  \[
  C_{\text{act}}(\text{move})=k_{\text{step}},\quad
  C_{\text{act}}(\text{forage})=k_{\text{for}},\quad
  C_{\text{act}}(\text{build})=k_{\text{build}},\quad
  C_{\text{act}}(\text{self\_stim})=k_{\text{stim}}.
  \]
- **Brain cost \(C_{\text{brain}}\):** “lazy neurons”
  \[
  C_{\text{brain}}(\pi_t)=\lambda_1\|\text{activations}_t\|_1+\lambda_2\cdot \text{updates}_t
  \]
- **Viability:** episode terminates if \(E_t \le 0\) or a lethal predator event occurs. Reward includes \(\mathbf{1}\{s_t\in V\}\) where \(V=\{E>\epsilon,\ \text{safe states}\}\).

#### 5.4 Objective (binds prediction to exploration & viability)

From Section 3:
$$
J = \mathbb{E}\!\left[\sum_t \Big(
+\alpha\,\mathrm{info\_gain}_t
-\beta\,\mathrm{pred\_error}_t
-\gamma\,C_{\text{act}}(a_t)
-\delta\,C_{\text{brain}}(\pi_t)
+\rho\,\mathbf{1}\{s_t\in V\}
\Big)\right]
$$

**Notes:**  
- \(\mathrm{info\_gain}_t\) can be \(\mathrm{KL}\) between posterior/prior over model parameters or latent state; a lightweight proxy is **entropy drop** in the agent’s belief over local food dynamics or predator process.  
- \(\mathrm{pred\_error}_t\) can be NLL of \(o_t\) under the agent’s predictive sensor model \(p_\pi\).

#### 5.5 Baselines (to expose “dark-rooming”)

1. **Prediction-only (degenerate):** optimize \(-\beta\,\mathrm{pred\_error}\) alone ⇒ camps in shelter/self-stim loop (low entropy, early starvation).  
2. **Prediction + energy costs:** adds \(-\gamma C_{\text{act}}-\delta C_{\text{brain}}\) ⇒ reduces pointless loops but may still under-explore safe high-value frontiers.  
3. **Full objective (ours):** adds \(+\alpha\,\mathrm{info\_gain} + \rho\,\mathbf{1}\{s_t\in V\}\) ⇒ learns *structured exploration* + *efficient harvest*.

#### 5.6 Diagnostics (what to log)

- **Lifespan** (steps to termination) and **time-to-first-harvest**.  
- **Energy curve** \(E_t\) and **harvest/consumption balance**.  
- **Observation entropy** \(H(o_t)\) and **fraction of time in shelter** (detect dark-rooming).  
- **Information gain per energy** \(\mathrm{IG}/\Delta E\).  
- **Transfer tests:** performance after switching \(p_{\text{grow}}\) or predator intensity.  
- **Brittleness:** success under random perturbations (OOD competence).  
- **Compute audit:** \(\|\text{activations}\|_1\), updates per step (are neurons “lazy”?).

#### 5.7 Canonical ablations

- **Remove info-gain term** (\(\alpha=0\)): does exploration collapse?  
- **Zero brain cost** (\(\lambda_1=\lambda_2=0\)): do neurons spam activity?  
- **Free self-stim** (\(k_{\text{stim}}\!\downarrow\)): does the agent addiction-loop?  
- **No viability reward** (\(\rho=0\)): does it prefer predictable starvation?  
- **Short horizon planner:** does myopia re-introduce input-control hacks?

#### 5.8 Suggested hyperparameters (starting point)

| Symbol | Meaning | Safe value |
|---|---|---|
| \(k_{\text{step}}\) | move cost | 0.2 |
| \(k_{\text{for}}\) | forage cost | 0.5 |
| \(k_{\text{build}}\) | build shelter | 2.0 |
| \(k_{\text{stim}}\) | self-stim cost | 0.8 |
| \(\lambda_1\) | L1 activations | 0.01 |
| \(\lambda_2\) | update cost | 0.02 |
| \(\alpha\) | info-gain weight | 0.3 |
| \(\beta\) | pred-error weight | 1.0 |
| \(\gamma\) | action-energy weight | 1.0 |
| \(\delta\) | brain-energy weight | 1.0 |
| \(\rho\) | viability reward | 0.5 |
| \(p_{\text{safe}}\) | food regrowth (safe) | 0.02 |
| \(p_{\text{risk}}\) | food regrowth (risky) | 0.10 |
| \(p_{\text{death}}\) | predator lethality | 0.05 |
| \(F_{\max}\) | food cap per cell | 5 |

*(Tune so that “hide forever” starves, “rush risk” gets punished, and “explore–harvest” thrives.)*

#### 5.9 Minimal loop (pseudo-code)

```text
for episode in range(E):
  s = reset(); E = E0; alive = True
  while alive:
    o = observe(s)                  # local egocentric patch (noisy)
    a, brain_stats = policy(o)      # predicts next obs; pays brain cost
    s' = env_step(s, a)             # updates food field, predators, etc.
    pred_err = nll_predict(o | history, a)
    info_gain = posterior_update(...)
    E = E + harvest(s,a) - C_act(a) - C_brain(brain_stats)
    alive = (E > 0) and not lethal_predator(s')
    r = +alpha*info_gain - beta*pred_err - gamma*C_act(a) - delta*C_brain(...) + rho*viability(s')
    learn(policy, r)
    s = s'
```

## Positive patterns that can help

Computationally, some *extreme* cognitive styles can act like **beneficial hacks** when the environment and support match them. These are not diagnoses or prescriptions—just ways a system can lean on one lever of our objective (explore / learn/track / energy / viability) and come out ahead.

### 1) High novelty drive (ADHD-like exploration bias)
- **Mechanism:** elevated weight on the **exploration** term \(+\alpha\,\mathrm{info\_gain}\); lower inertia against switching tasks/contexts.
- **Upside:** rapid hypothesis sampling, broader state coverage, resilience to distribution shift; prevents “dark-rooming.”
- **Cost control:** needs scaffolds to bound **energy** waste \(C_{\text{act}}+C_{\text{brain}}\) and to convert novelty into **learn/track** gains \(-\beta\,\mathrm{pred\_error}\).
- **Best-fit environments:** rich, changing tasks with frequent feedback (early-stage research, product discovery, field ops).

### 2) Monotropism / deep focus (autistic-like stability bias)
- **Mechanism:** increased precision on chosen task priors; reduced switching → lower **brain cost** per unit progress; strong **learn/track** within a domain.
- **Upside:** exceptional pattern extraction, reliability, and long-horizon accumulation; builds tools/shelters that raise long-term **viability** \(\mathbf{1}\{s_t\!\in\!V\}\).
- **Guardrails:** periodic, lightweight **info\_gain** probes to avoid brittleness; social/environmental interfaces that reduce surprise overhead.
- **Best-fit environments:** systems engineering, data curation, safety-critical pipelines.

### 3) Conscientious ritualism (OCD-like precision on procedures)
- **Mechanism:** strong priors for “done-right” sequences; lowers variance in outcomes, compresses **pred\_error**, and prevents costly rework.
- **Upside:** dependable quality in high-stakes tasks; stabilizes the energy ledger by avoiding failure loops.
- **Guardrails:** cap ritual length via explicit **energy** prices \(C_{\text{act}},C_{\text{brain}}\); regular OOD checks to ensure procedures still match reality.
- **Best-fit environments:** checklists for surgery/aviation, infra reliability, compliance/security.

### 4) Threat-sensitivity (anxiety-like hazard detection)
- **Mechanism:** heightened precision on risk priors; earlier sampling of tail events; raises **viability** by avoiding ruin states.
- **Upside:** fewer catastrophic tails; better portfolio of **options** maintained under uncertainty.
- **Guardrails:** enforced **exploration** windows to falsify stale threat priors; energy-aware exposure so caution doesn’t starve learning.
- **Best-fit environments:** safety review, red-teaming, incident response.

### 5) Hypomanic energy bursts (action bias under opportunity)
- **Mechanism:** temporarily low perceived **action/brain costs** \(C_{\text{act}},C_{\text{brain}}\) coupled with optimistic priors → rapid hill-climbing and tool creation.
- **Upside:** unlocks new reachable states (increases option value); creates assets that later reduce costs for everyone.
- **Guardrails:** external pacing and budget caps to prevent burn; post-burst consolidation to convert action into **learn/track**.
- **Best-fit environments:** time-boxed sprints, early venture building, crisis mobilization.

### 6) Schizotypy-like associative looseness (creative hypothesis generation)
- **Mechanism:** wider proposal distribution for models; expands candidate explanations before **learn/track** filters prune.
- **Upside:** escapes local minima; seeds breakthroughs when combined with empirical selection (info-gain + pred-error).
- **Guardrails:** strong evidence filters and energy-priced validation; team roles that separate ideation from vetting.
- **Best-fit environments:** concept discovery, long-shot R&D, design studios.

---

### A simple rule-of-thumb for “helpful extremes”
A cognitive style is **adaptive** when it **raises long-run viability per total energy** while improving either **information gain** *or* **predictive tracking**:

$$
\text{Adaptive if}\quad
\frac{\Delta \mathrm{IG} + \kappa\,\Delta ( -\mathrm{pred\_error})}{\Delta E_{\text{total}}}
\;\uparrow
\quad \text{and} \quad
\mathbb{P}(s_t\in V)\;\uparrow
$$

- If novelty spikes burn energy but don’t lift IG or tracking → **harmful** in that context.  
- If focus narrows entropy yet increases harvest, tools, or transfer → **helpful** when periodically re-tuned.

{{< alert color="info" >}}
**Takeaway:** “Good hacks” exist. The trick is to **price energy**, **measure information and tracking**, and **audit viability**—so the same underlying mechanism can be channeled into strengths rather than traps.
{{< /alert >}}


---

**Closing thought:**  
If the world can hunt you, prediction can’t just be clean—it must be **cost-aware, exploratory, and survival-competent**. The interesting agent isn’t the calmest predictor; it’s the one that spends brain-energy where it compounds into *open futures*.
