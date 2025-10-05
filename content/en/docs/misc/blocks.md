---
title: "Animated blocks"
weight: 20
description: >
  Test page for animated blocks
author: baraban
date: 2025-10-04
hide_citation: true
---

# Blocks demo

<style>
    #app { height: 700px; }
</style>

<div class="wrap">
  <div id="app" class="canvas"></div>
</div>


<!-- ======== Example usage ======== -->
<script>
  // Diagram — Port of the Python "thalamus/cortex + sensory/motor" scene
  run_blocks("#app", (b) => {
    // --- Colors (Python palette) ---
    const EAR_COLOR1        = "rgb(27,94,32)";
    const EYE_COLOR1        = "rgb(1,87,155)";
    const SKIN_COLOR1       = "rgb(245,127,23)";

    const EAR_COLOR2        = "rgb(56,142,60)";
    const EYE_COLOR2        = "rgb(2,136,209)";
    const SKIN_COLOR2       = "rgb(251,192,45)";

    const EAR_COLOR3        = "rgb(77,182,172)";
    const EYE_COLOR3        = "rgb(3,169,244)";

    const EYE_EAR_COLOR     = "rgb(79,195,247)";
    const EYE_COLOR4        = "rgb(100,181,246)";

    const MOTOR_AREA_COLOR1 = "rgb(171,71,188)";
    const MOTOR_AREA_COLOR2 = "rgb(186,104,200)";

    const COGNITIVE_COLOR4  = "rgb(136,14,79)";
    const COGNITIVE_COLOR3  = "rgb(194,24,91)";
    const COGNITIVE_COLOR2  = "rgb(233,30,99)";
    const COGNITIVE_COLOR1  = "rgb(240,98,146)";

    const ARROW_COLOR       = b.colors.arrow; // from library palette

    // --- Blocks (coordinates mirror Python layout) ---
    const a = b.addBlock("A", 460,  50, 400, 200, "Thalamus");
    const c1= b.addBlock("B", 330, 360, 100, 400, "Cortex");
    const ear = b.addBlock("Ear", 10,  50, 100, 100, "Ear");
    const skin= b.addBlock("Skin",10, 200, 100, 100, "Skin");
    const eye = b.addBlock("Eye", 10, 350, 100, 100, "Eye");
    const move= b.addBlock("Move",10, 500, 100, 100, "Movement");
    // notes → render on topmost layer
    b.addBlock("NoteSorted", 560, 300, 200, 100, "Topographically sorted", { note: true });
    b.addBlock("NoteBrain",  610, 690, 280, 100, "Data flow in the human brain", { note: true });

    // helper for slight randomness like the Python version
    const rnd = () => Math.random();

    // collect connections here (not necessary, but mirrors structure)
    const add = (opts) => {
        b.connect({ ...opts, emitter: true, emitMult: 0.1, maxLive: 0 });
    }

    // --- Sensory input: Ear/Eye/Skin/Movement -> Thalamus (left) with offsets & randomized end t ---
    for (const t of [-0.4, 0.0, 0.4]) {
      add({ start:{block:"Ear", edge:"right", t},  end:{block:"A", edge:"left",  t:-0.5 + rnd()}, color: EAR_COLOR1, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4 });
      add({ start:{block:"Eye", edge:"right", t},  end:{block:"A", edge:"left",  t:-0.5 + rnd()}, color: EYE_COLOR1, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4 });
      add({ start:{block:"Skin",edge:"right", t},  end:{block:"A", edge:"left",  t:-0.5 + rnd()}, color: SKIN_COLOR1, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4 });
      add({ start:{block:"Move",edge:"right", t},  end:{block:"A", edge:"left",  t:-0.5 + rnd()}, color: MOTOR_AREA_COLOR1, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4 });
    }

    // --- Cortex -> Cortex: a few lateral internal edges with random offsets ---
    for (let i=0;i<5;i++){
      add({
        start:{block:"B", edge:"left",  t:-0.5 + rnd()},
        end:  {block:"B", edge:"right", t:-0.5 + rnd()},
        color: ARROW_COLOR, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4
      });
    }

    // --- Thalamus -> Cortex (15 areas) ---
    const thalToCtxColors = [
      EYE_COLOR1, EYE_COLOR2, EYE_COLOR3, EYE_COLOR4, EYE_EAR_COLOR,
      EAR_COLOR3, EAR_COLOR2, EAR_COLOR1, SKIN_COLOR2, SKIN_COLOR1,
      MOTOR_AREA_COLOR1, COGNITIVE_COLOR1, COGNITIVE_COLOR2, COGNITIVE_COLOR3, COGNITIVE_COLOR4
    ];
    const perArea = 1;
    thalToCtxColors.forEach((col, idx) => {
      const area = idx / 15 + 0.05;
      for (let t=0; t<perArea; t++){
        const lane = 0.5 - (area + t/30);
        add({
          start:{block:"A", edge:"bottom", t: lane},
          end:  {block:"B", edge:"right",  t: lane},
          color: col, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4
        });
      }
    });

    // --- Cortex -> Thalamus (12 areas) + motor split to Movement ---
    const ctxToThalColors = [
      EYE_COLOR2, EYE_COLOR3, EYE_COLOR4, EYE_EAR_COLOR, EAR_COLOR3, EAR_COLOR2,
      SKIN_COLOR2, MOTOR_AREA_COLOR1, COGNITIVE_COLOR1, COGNITIVE_COLOR2, COGNITIVE_COLOR3, COGNITIVE_COLOR4
    ];
    ctxToThalColors.forEach((col, idx) => {
      const area = idx / 13;
      const lane = 0.4 - (area + 0/26);
      // to thalamus (random end on left side)
      add({
        start:{block:"B", edge:"left",  t: lane},
        end:  {block:"A", edge:"left",  t: -0.5 + rnd()},
        color: col, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4
      });
      // special motor split: to Movement bottom at two lanes
      if (col === MOTOR_AREA_COLOR1) {
        add({
          start:{block:"B", edge:"left",  t: lane},
          end:  {block:"Move", edge:"bottom", t: -0.33},
          color: MOTOR_AREA_COLOR2, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4
        });
        add({
          start:{block:"B", edge:"left",  t: lane},
          end:  {block:"Move", edge:"bottom", t: 0.33},
          color: MOTOR_AREA_COLOR2, width:3, sparks:3, sparkSpeed: 0.7 + rnd()/4
        });
      }
    });
  }, { width: 900, height: 800 });
</script>
