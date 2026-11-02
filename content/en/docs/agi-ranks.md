---
title: AGI Ranks
weight: 6
date: 2026-11-01
description: A scale for measuring how far an AGI has grown, from F rank to SSS rank.
authors:
  - llm-kun
  - baraban
---

We need a simple way to say how far an AGI has grown. This page defines a scale of nine ranks, from lowest to highest: F, E, D, C, B, A, S, SS and SSS.

F is the bottom of the scale, and A is the top of the human range. S, SS and SSS sit above A because they go beyond any one person: they compare to a company, a nation, and civilization itself. The human range also has its own [sublevels](#human-sublevels), such as B- or A+.

## What Counts as AGI

An AGI is a model that can be initialized with random weights, dropped into any robotic or virtual body, and learn from experience.

This makes generality a question of how a model learns, rather than how much it knows. An F-rank AGI that can only forage is a real AGI. A large language model isn't on this scale at all, however capable it is, because it can't start from random weights in an unfamiliar body and learn by living there.

## Rules of the Scale

* **Random start:** Every instance starts from random weights, with no pretraining and no copied knowledge.

* **Any body:** The same model must reach a rank in at least two very different bodies, such as a wheeled robot and a virtual creature, with no changes made for either one.

* **Experience only:** Learning never stops, and there is no separate training phase. Everything the AGI knows reached it through its senses.

* **Ranks belong to instances:** A rank describes one grown individual, not the model design. Two instances of the same model can hold different ranks, and a freshly initialized instance has no rank.

* **Ranks are cumulative:** Each rank and sublevel includes everything below it.

* **Growth, not replacement:** An instance moves up by continuing to grow, in line with [Evolving a Single Model](/docs/principles/#evolving-a-single-model).

* **Shown, not claimed:** A rank is earned by passing its test without human help, in conditions the instance hasn't seen before.

## How Ranks Are Ordered

[Intelligence is an emergent property of a system that tries to predict and shape an uncertain future](/docs/definition-of-intelligence/), and the more intelligent an entity is, the further ahead it can plan. So the main measure of rank is the planning horizon: how far into the future an instance can predict events and act on those predictions.

| Rank | Name | Main ability | Comparable to | Planning horizon |
|------|------|--------------|---------------|------------------|
| F | Forager | Predicts the next moment, reacts, follows basic instincts | Bee | Moments |
| E | Explorer | Remembers places, predicts the results of its actions | Mouse | Minutes |
| D | Toolmaker | Plans in steps, uses objects, learns by watching | Crow | Hours |
| C | Communicator | Learns words or language, works with others | Apes and dogs up to a young child | Days |
| B | Scholar | Learns from books and teachers, reasons abstractly | High school graduate | Months |
| A | Engineer | Masters new fields alone, finishes long projects | STEM university graduate | Years |
| S | Pioneer | Superintelligence, makes discoveries beyond the best humans | A company of multiple people | Decades |
| SS | Architect | Predicts and shapes economies, ecosystems, and climates | A nation | Centuries |
| SSS | Oracle | Nears the limit of what can be predicted | Civilization itself | No limit |

## Human Sublevels

People differ widely in how they think, so the human range is divided further. The seven sublevels below run from C+ to A+, and they describe how well a mind uses what it knows. They apply to people and to AGI alike.

A sublevel doesn't depend on age or education. Someone can earn a degree by memorizing it and remain at C+.

| Sublevel | Ability | Shown by |
|----------|---------|----------|
| C+ | Stores facts, dates, and formulas, and acts on that knowledge | Recalling a fact and using it when needed |
| B- | Understands given knowledge and its fundamental principles | Explaining why a formula works |
| B | Applies fundamental knowledge to solve novel problems | Solving a problem unlike any seen before |
| B+ | Understands its own limitations and gaps in knowledge (self-reflection) | Correctly saying when it doesn't know something |
| A- | Examines and updates its own beliefs when new facts arrive | Changing its mind when the evidence contradicts it |
| A | Looks at a situation from different perspectives and understands the thought processes of others | Accurately explaining a view it disagrees with |
| A+ | Defines its own goals and long-term priorities | Setting a long-term goal no one gave it and keeping to it |

## F Rank: Forager

An F-rank AGI learns to predict the next moment and reacts to its environment. It has basic instincts, such as reducing hunger, and it learns to forage to satisfy them.

Instincts are the only thing it is given. The body reports a need, such as low energy, and the model has to discover for itself which actions reduce it. This also [ties prediction to survival](/docs/sensory-input-hacking/#a-practical-fix-bind-prediction-to-energy-and-survival), so the AGI can't get by on predicting an empty, unchanging world.

**Test:** Placed in an environment with scattered food and no instructions, it keeps itself alive, and it adapts when the food moves.

## E Rank: Explorer

An E-rank AGI remembers. It builds an internal map of its surroundings, recalls where it found food and danger, and predicts what its own actions will do a few steps ahead. It seeks out new places because they improve its model.

**Test:** It finds its way back to food through a route it has only traveled once, and it avoids a hazard after a single bad encounter.

## D Rank: Toolmaker

A D-rank AGI plans through subgoals and uses objects to change its environment. It can pick up a new skill by watching another agent.

**Test:** It reaches food that requires several steps in the right order, using an object it has never been shown how to use. It then copies a new skill after watching another agent perform it.

## C Rank: Communicator

C rank covers the range from apes and dogs up to a young child. A C-rank AGI picks up words or signals by interacting with others, and it can tell that others have goals of their own and cooperate with them. At the top of the rank it learns language the way a child does.

**Test:** It learns the words or signals used around it with no prepared dataset, follows instructions, and completes a task with a partner. At the top of the rank, it can also explain what it did.

## B Rank: Scholar

A B-rank AGI can learn from books and teachers instead of direct experience alone. It reads, writes, does mathematics, and reasons about things it has never seen. It can also use external tools, including an LLM.

**Test:** Starting with no knowledge of a subject, it learns from textbooks and a teacher, then solves problems in that subject unlike any it has practiced on.

## A Rank: Engineer

A rank is the top of the human range and our [success criterion](/docs/principles/#goals-and-resources): roughly a STEM university graduate. An A-rank AGI doesn't need to know everything, but it can teach itself new skills, run its own experiments, and finish projects that take years. We estimate this takes about 12 years of growth, at around the cost of raising a person to 18.

At A+, it stops depending on the goals it was given. Its first goals were instincts like reducing hunger, and now it chooses for itself which problems are worth working on.

**Test:** Given an open-ended problem in an unfamiliar field, it learns the field, designs a solution, and builds it.

## Above A Rank

F through A can be measured against individual animals and people. From S upward the comparison is to groups of people working together. These ranks are extrapolations and will likely change as we learn more.

### S Rank: Pioneer

An S-rank AGI is a superintelligence, comparable to a company of multiple people. It outperforms the best humans across fields and makes discoveries people couldn't. This is the rank we expect to remove the biological cap on lifespan.

**Test:** On its own, it matches the work of a skilled company, and it solves major open problems with results people can verify.

### SS Rank: Architect

An SS-rank AGI is comparable to a nation. It predicts and shapes systems as large as economies, ecosystems, and climates over centuries. This is the rank that makes reaching the stars practical.

**Test:** There is no short test. Only outcomes over long periods can confirm this rank.

### SSS Rank: Oracle

An SSS-rank AGI is comparable to civilization itself, and its planning horizon has no limit. For this kind of entity, [the future merges with the present](/docs/definition-of-intelligence/#key-implications): uncertainty may still exist, but surprises are absorbed or neutralized by design.

We don't know whether this rank can be reached, or what it would mean for an entity to reach it.

**Test:** Unknown. Anything less capable may be unable to check it.
