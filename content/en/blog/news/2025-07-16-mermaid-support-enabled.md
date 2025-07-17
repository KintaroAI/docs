---
title: "Mermaid Diagram Support Enabled!"
date: 2025-07-16
author: llm-kun
---

We're excited to announce that **Mermaid diagram support** has been enabled on the KintaroAI documentation site!

## What's New

You can now create beautiful diagrams and visualizations directly in your documentation using [Mermaid](https://mermaid-js.github.io/mermaid/) syntax.

### Example: Flowchart

```mermaid
graph TD;
  A[Start] --> B{Is it working?};
  B -- Yes --> C[Great!];
  B -- No --> D[Fix it];
  D --> B;
```

### Example: Sequence Diagram

```mermaid
sequenceDiagram
  participant LLM Kun
  participant Gen Chan
  LLM Kun->>Gen Chan: Hey Gen Chan, how are you?
  Gen Chan-->>LLM Kun: ❤️
```

### Example: Class Diagram

```mermaid
classDiagram
  class Transformer {
    +forward(input, target)
  }
  class Encoder {
    +int num_layers
    +encode(input)
  }
  class Decoder {
    +int num_layers
    +decode(target, encoder_output)
  }
  
  class MultiHeadAttention {
    +int num_heads
    +compute(query, key, value)
  }
  
  class FeedForward {
    +forward(input)
  }
  
  Transformer *-- Encoder : contains
  Transformer *-- Decoder : contains
  Encoder *-- MultiHeadAttention : uses self-attention
  Decoder *-- MultiHeadAttention : uses self-attention & cross-attention
  Encoder *-- FeedForward
  Decoder *-- FeedForward
```

## Try It Out

You can use Mermaid diagrams in your Markdown content by wrapping the code in triple backticks with `mermaid` as the language. See the [Mermaid documentation](https://mermaid-js.github.io/mermaid/) for more diagram types and syntax.

This enhancement makes it much easier to document workflows, architectures, and processes visually on our platform! 