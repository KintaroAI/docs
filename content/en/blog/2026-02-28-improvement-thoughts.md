---
title: "Improvement Thoughts: Ideas on Architecture and AGI"
linkTitle: "Improvement Thoughts"
date: 2026-02-28T00:00:02Z
authors:
  - baraban
---

Short-form ideas on improving transformer architectures or building something beyond them. No guarantees — some of these are experiments, some are dead ends.

---

## Banded Sparsity in MLP Layers

The fully-connected MLP in a transformer connects every input channel to every output channel. But do they all need to talk to each other? The locality hypothesis says adjacent input features naturally map to nearby hidden features — so you can use a diagonal/banded connection pattern instead. With bandwidth=256 on a 128→512 expansion you get ~44% sparsity, which means ~50% compute reduction for that layer, potentially with minimal loss degradation.

The bet is that information can spread gradually across the diagonal rather than needing to jump everywhere at once. If true, this is free efficiency.

[Research →](https://github.com/KintaroAI/research/tree/master/llm-fundamentals/00007-banded-sparsity)

---

## Sort Layer: Local Blending on the Residual Stream

After each transformer block, instead of just passing the residual forward, compute cosine similarity between adjacent token positions in a local window and softly blend them using a learned temperature. The idea is that nearby tokens often carry related information and this blending acts as soft routing — letting the model decide how much to share between neighbors.

Results on TinyStories: ~1.1% relative validation loss improvement, with the gap growing throughout training. The overhead is 25-40% for small models, which is too much — but at larger scale the relative cost drops. Worth revisiting on bigger architectures. Combining with banded sparsity hurt performance, likely due to capacity constraints at small scale.

[Research →](https://github.com/KintaroAI/research/tree/master/llm-fundamentals/00011-sort-layer)

---

## Hebbian Embedding Pull (Negative Result)

Pull token embeddings of co-occurring tokens toward each other before each forward pass — the intuition being that backprop already does this implicitly, so a Hebbian nudge might accelerate it early in training.

It didn't work. Validation loss was consistently ~0.066 worse than baseline throughout training. The problem: the pull is non-learnable, so the model can't turn it off when it becomes harmful. It over-smooths embeddings and prevents fine-grained token distinctions. The lesson: if you're going to inject a bias into the learning process, make sure it has learnable parameters so gradient descent can compensate or disable it.

[Research →](https://github.com/KintaroAI/research/tree/master/llm-fundamentals/00018-hebbian-embedding-pull)
