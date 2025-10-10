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
    correctValues: {
      // Pre-filled puzzle (classic sudoku)
      'R1C1': 5, 'R1C2': 3, 'R1C5': 7,
      'R2C1': 6, 'R2C4': 1, 'R2C5': 9, 'R2C6': 5,
      'R3C2': 9, 'R3C3': 8, 'R3C8': 6,
      'R4C1': 8, 'R4C5': 6, 'R4C9': 3,
      'R5C1': 4, 'R5C4': 8, 'R5C6': 3, 'R5C9': 1,
      'R6C1': 7, 'R6C5': 2, 'R6C9': 6,
      'R7C2': 6, 'R7C7': 2, 'R7C8': 8,
      'R8C4': 4, 'R8C5': 1, 'R8C6': 9, 'R8C9': 5,
      'R9C5': 8, 'R9C8': 7, 'R9C9': 9
    }
  });
</script>
