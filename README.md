# Blackjack (MASM + Irvine32)

Console Blackjack implemented in x86 assembly using MASM and the Irvine32 library.

## Overview

This project implements a playable Blackjack game loop with:

- deck creation and shuffle
- player turn (`Hit` / `Stand`) with input validation
- dealer turn (hit until 17 or higher)
- hand scoring with Ace adjustment (11 -> 1 when needed)
- round result resolution (win / lose / push)
- running scoreboard across rounds
- replay prompt for continuous play

## Requirements

- MASM toolchain
- Irvine32 library and include files
- Windows console environment

## Build And Run

Use either of the following methods:

1. Visual Studio project flow  
   Put `blackjack.asm` into your MASM/Irvine32 Visual Studio project and build/run from Visual Studio.

2. Batch script flow  
   Run the course build script directly:

```bat
asm_CSE3120.bat blackjack.asm
```

## How To Play

1. Start the program.
2. Press Enter at the startup prompt.
3. Each player turn, enter:
   - `1` for `Hit`
   - `2` for `Stand`
4. At round end, enter:
   - `1` to play again
   - `0` to quit

## Rules Implemented

- Standard total calculation:
  - `2-10` are face value
  - `J/Q/K` are 10
  - `A` is 11 unless busting, then reduced to 1
- Player busts above 21.
- Dealer hits until total is at least 17.
- Natural blackjack logic:
  - if first two cards equal 21, it is treated as blackjack
  - player/dealer natural blackjack tie resolves as push
- Push occurs when totals match without busts.

## Project Structure

- `blackjack.asm`: complete game source
- `README.md`: project documentation

## Main Procedure Flow

- `main`
  - `InitializeGame`
  - loop:
    - `ResetRound`
    - `RunGame`
    - `PromptReplay`
  - `ShutdownGame`

- `RunGame`
  - `SetupRound`
  - `PlayerTurn`
  - `DealerTurn` (skipped if player already busts/blackjacks)
  - `ResolveRound`
  - `RenderRound`

## Rendering Notes

- Console rendering uses Irvine32 routines (`Clrscr`, `SetTextColor`, `WriteString`, etc.).
- Dealer second card/total are hidden until round resolution.
- Score and cards remaining are shown each round.
