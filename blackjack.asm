; blackjack.asm

INCLUDE Irvine32.inc

.data ; constants and game state
DECK_SIZE = 52
MAX_HAND_SIZE = 12
ACTION_HIT = 1
ACTION_STAND = 2
gameState DWORD 5 DUP(0) ; player/dealer totals, counts, flags
deck BYTE DECK_SIZE DUP(0)
playerHand BYTE MAX_HAND_SIZE DUP(0)
dealerHand BYTE MAX_HAND_SIZE DUP(0)
uiText BYTE "Blackjack",0,"Hit/Stand?",0,"Result: TBD",0
.code ; procedures and flow
main PROC
    exit
main ENDP
END main
