# Blackjack in Assembly

## Completion Plan

### Phase 1: Expand the bare skeleton safely

1. [x] Add section headers/comments for `.data` and `.code` layout.
2. [x] Add an empty `.data` section.
3. [x] Add constants for deck size, max hand size, and action values.
4. [x] Add base state variables (player/dealer totals, counts, flags).
5. [x] Add deck storage and hand storage arrays.
6. [x] Add string placeholders for title, prompts, and result messages.
7. [x] Add procedure prototypes for all game phases.
8. [x] Update `main` to call high-level phase procedures only.
9. [x] Add empty/stub procedures with `ret` for each prototype.
10. [x] Assemble and verify the scaffold still builds.

### Phase 2: Round state and reset flow

11. [x] Add a reset procedure outline to clear round state.
12. [x] Add placeholder steps in reset for hand counters.
13. [x] Add placeholder steps in reset for totals/flags.
14. [x] Add a call from `main` to reset at round start.
15. [x] Add a replay/continue round flag variable.
16. [x] Add a high-level game loop outline in `main`.
17. [x] Add a clean branch for exiting the loop.
18. [x] Add a placeholder call for replay prompt flow.
19. [x] Add a stub replay prompt procedure.
20. [x] Assemble and verify loop structure compiles.

### Phase 3: Deck lifecycle (structure first)

21. Add a deck-init procedure outline.
22. Add placeholder comments/labels for filling 52 cards.
23. Add a shuffle procedure outline.
24. Add placeholder loop structure for shuffle pass.
25. Add a deck index or draw pointer variable.
26. Add a draw-card procedure signature and return contract comment.
27. Add draw-card stub behavior (no full logic yet).
28. Add calls in round setup: init, shuffle, then deal.
29. Add an out-of-cards handling placeholder procedure.
30. Assemble and verify deck procedure wiring compiles.

### Phase 4: Dealing and hand accounting

31. Add procedure outline to deal opening hands.
32. Add placeholder call order for alternating player/dealer draws.
33. Add procedure outline to add a card to player hand.
34. Add procedure outline to add a card to dealer hand.
35. Add procedure outline to recalculate player total.
36. Add procedure outline to recalculate dealer total.
37. Add ace-handling placeholder plan in total procedures.
38. Add call points after each card draw to refresh totals.
39. Add sanity-check placeholders for max cards in hand.
40. Assemble and verify dealing flow compiles.

### Phase 5: Player turn flow

41. Add player turn procedure outline.
42. Add loop skeleton for repeated player action.
43. Add prompt/display placeholder for hit-or-stand input.
44. Add input validation branch skeleton.
45. Add hit branch placeholder (draw + recompute + bust check).
46. Add stand branch placeholder (exit loop).
47. Add immediate blackjack check placeholder at turn start.
48. Add bust end-turn branch placeholder.
49. Add return status flag from player turn.
50. Assemble and verify turn-control branches compile.

### Phase 6: Dealer turn and outcome resolution

51. Add dealer turn procedure outline.
52. Add dealer loop skeleton for "hit until 17+" rule.
53. Add dealer bust check placeholder.
54. Add procedure outline for round result resolution.
55. Add result-priority branch order placeholder comments.
56. Add result state variable (player win/dealer win/push).
57. Add blackjack-vs-blackjack tie placeholder handling.
58. Add hooks for balance/score update procedure.
59. Add score update procedure stub.
60. Assemble and verify dealer + resolve flow compiles.

### Phase 7: Rendering and user messaging

61. Add table-draw procedure outline.
62. Add player-hand render procedure outline.
63. Add dealer-hand render procedure outline.
64. Add hidden-hole-card placeholder branch for dealer render.
65. Add status-line render procedure outline.
66. Add startup screen/title procedure outline.
67. Add end-of-round summary render procedure outline.
68. Add call sequence for render points during round flow.
69. Add color/style placeholder calls (`SetTextColor`) where needed.
70. Assemble and verify UI procedure wiring compiles.

### Phase 8: Validation, polish, and final pass

71. Run manual test pass for immediate blackjack cases.
72. Run manual test pass for player bust paths.
73. Run manual test pass for dealer bust paths.
74. Run manual test pass for push/tie paths.
75. Run manual test pass for multiple-ace totals.
76. Run manual test pass for replay loop and clean reset.
77. Refactor duplicated call patterns into helper procedures.
78. Tighten comments so each procedure has purpose + inputs/outputs.
79. Remove dead placeholders once real logic replaces them.
80. Final assembly/build check and gameplay smoke test.

## Definition of Done

1. Program builds cleanly after each small edit batch.
2. Full round lifecycle works: deal, player turn, dealer turn, resolve, replay.
3. Blackjack rules are correctly enforced, including ace handling and pushes.
4. Console output is readable and stable across repeated rounds.
