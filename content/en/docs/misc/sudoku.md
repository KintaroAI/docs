---
title: "Sudoku"
weight: 20
description: >
  Test page for Sudoku
author: baraban
date: 2025-10-09
hide_citation: true
---

{{ partial "sudoku.html" . }}

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
      // Add correct values as needed
    }
  });
</script>
