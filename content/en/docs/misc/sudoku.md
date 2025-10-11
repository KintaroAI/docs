---
title: "Sudoku"
weight: 20
description: >
  Test page for Sudoku
author: baraban
date: 2025-10-09
hide_citation: true
---

# Sudoku demo

<style>
    #sudoku { height: 600px; }
</style>

<div class="wrap">
  <div id="sudoku" class="canvas"></div>
</div>

<script>
  // Initialize the Sudoku game
  window.sudoku = initSudoku("#sudoku", {
    subRows: 2,
    subCols: 2,
    singleSection: false,
    cellSize: 110,
    gap: 32,
    margin: 36,
    hintShake: true,
    autosolver: true,
    clickToSetAnswer: true,
    autoHints: true,
    correctValues: {
      'R1C1': 1
    }
  });
</script>

---

## Standard 9x9 Sudoku Example (TODO: text scaling needed)

<style>
    #sudoku9x9 { height: 600px; }
</style>

<div class="wrap">
  <h3>Standard 9x9 Sudoku with Solution</h3>
  <div id="sudoku9x9" class="canvas"></div>
</div>

<script>
  // Initialize the 9x9 Sudoku game
  window.sudoku9x9 = initSudoku("#sudoku9x9", {
    subRows: 3,
    subCols: 3,
    singleSection: false,
    cellSize: 50,
    gap: 4,
    margin: 20,
    hintShake: true,
    autosolver: false,
    clickToSetAnswer: true,
    autoHints: true,
    correctValues: {}
  });
</script>
