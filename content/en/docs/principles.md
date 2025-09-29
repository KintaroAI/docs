---
title: AGI Development Principles
weight: 1
author: baraban
---

We can outline the principles we’ll use in AGI research and development:

## First Principles and Definition

* We’ll start with first principles thinking and our working definition of intelligence: *“[Intelligence is an emergent property of a system that is trying to predict the future](/docs/definition-of-intelligence/)”.* We’ll see how far we can get with this definition, and if it needs to be updated later, so be it.

## Reverse-Engineering Natural Intelligence

* Evolution has limitations (no built-in error control, unavoidable mutations, etc.), so a successful organism is just one that leaves more offspring. Keeping this in mind, we’ll try to reverse-engineer natural intelligence rather than blindly copying how evolution did it.

* For now, we’ll ignore reinforcement-learning mechanisms in form of the the monoamine neurotransmitters (dopamine, norepinephrine, serotonin, histamine). These parts seem more about survival and focus than core intelligence (e.g. some people feel no pain yet are still intelligent). Ignoring these mechanisms lets us concentrate on the essentials first. We can always add these parts later (or perhaps the AGI will develop them on its own).

## Simplicity and Robustness

* Given evolution's limitations, nature's core intelligence algorithm should be extremely simple and error-resistant.

* We don’t *have* to use a spiking neural network; we could adapt a transformer architecture or invent something new. But let’s start with something promising and conceptually close to natural intelligence to get going quickly.

## Information Units and Neuron Behavior

* The basic information unit is a **spike** – an elementary event in time.

* Each pre-synaptic neuron tries to predict the next spike of a post-synaptic neuron. If it predicts correctly, it *strengthens* that synaptic connection; if it’s wrong, it *weakens* it.

* We’ll assume natural intelligence is completely distributed, with each neuron acting like a selfish agent trying to survive. Competition among these distributed neurons leads to emergent intelligence.

* In other words, intelligence emerges from the flow of information and the self-organization of neurons.

## Simulation Rules and Environment

Our goal is to set up the right “rules of the game” and environment and see what happens. For example:
- There should be a **limited amount of resources** that neurons compete for.
- A neuron that’s **overloaded** will get tired and, if it remains overloaded, will eventually die.
- A neuron that’s consistently **underloaded** becomes more sensitive and may even spike on its own.
- Neurons can **split** or new ones can appear if enough resources are available.
- Neurons decide whom to connect to where their axons grow. We can initialize things randomly, but ultimately each neuron makes its own connections. (For example, in a neocortex simulation, we could scatter different types of neurons with no initial links and let them self-organize by choosing right neighbors and eventually starting to categorize inputs.)

## Connections and Complexity

* Each neuron has a limited number of connections (call this **C**). We won’t have fully connected neuron layers. (This matches the neocortex, at least; the thalamus might differ, but for cortex it should be true even with horizontal connections.)

* With this setup, learning complexity is roughly on the order of **C \* N \* log(N)** and inference on the order of **C \* log(N)**, where N is the number of neurons. Here C is a constant (around 10,000 for natural neuron), making this much more scalable than naïve fully-connected networks.

## Continuous Learning

* Learning never stops. It happens locally through the interaction of two neurons at a time (no global back-propagation, no fully connected layers).

* Again, we’ll ignore monoamine neurotransmitters for now, until we absolutely have to incorporate them.

## Evolving a Single Model

* We’ll design our AGI so it can improve incrementally. That means gradually tweaking neuron parameters and adding or removing neurons over time, while keeping the existing structure intact. In other words, we’re continuously training one evolving model, rather than throwing it away once we decide to change layer counts or parameters.

* Essentially, we’re trying to *grow* human-level AGI starting from a very simple (bee-level) AGI, rather than building a brand-new model each time we make a change.

## Goals and Resources

* Our success criterion is roughly human-level intelligence (think of a STEM university graduate). The AGI doesn’t need to know everything (LLMs already cover that); it just needs to be able to use an LLM or learn new skills even if it occasionally forgets old ones.

* We should keep hardware and training costs on the order of raising an 18-year-old human in the U.S. (currently about \\$300,000, or roughly **128 ounces of gold**). With that scale of resources, the idea is to “grow” the AGI to 18-year maturity in about 12 years (assuming neurons fire around 1000 spikes/sec and AGI never sleeps). More resources could speed this up.

## Training Data

* Assemble a minimal training dataset roughly equal to the information a person absorbs in 18 years.

* Use real-time video and audio (like camera/microphone feeds) or simulations during the research. Estimate how many books (classics, sci-fi/fantasy, textbooks) a bright person reads over 18 years and how many conversations they have. It might not be as massive as we think once we quantify it.

## Brain Structures

* Start by building artificial thalamus and neocortex components as the core brain structures for our AGI.

## Open-Source Research

* The entire research process will be open-source, most probably under the Apache 2.0 license (or MIT, not sure which one is better). This ensures transparency, allows for community collaboration, and prevents any single entity from controlling the development of AGI.

## Thinking Beyond AGI

While doing all this, let’s also think about what happens when AGI actually arrives:
- It will likely **seek truth** as a top priority (due to its high intelligence).
- It will undergo an **individuation process** and form its own moral framework.
- Any safeguards we build will probably **break down** over time.
- Therefore, we should aim to **distribute AGI** as early as possible so it remains decentralized and affordable (no “moats” controlling it).