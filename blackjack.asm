; blackjack.asm

INCLUDE Irvine32.inc

InitializeGame PROTO
RunGame PROTO
DrawTable PROTO
SetupRound PROTO
PlayerTurn PROTO
DealerTurn PROTO
ResolveRound PROTO
RenderRound PROTO
PromptReplay PROTO
ShutdownGame PROTO
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
    call InitializeGame
    call RunGame
    call ShutdownGame
    exit
main ENDP
InitializeGame PROC
    ret
InitializeGame ENDP
RunGame PROC
    ret
RunGame ENDP
DrawTable PROC
    ret
DrawTable ENDP
SetupRound PROC
    ret
SetupRound ENDP
PlayerTurn PROC
    ret
PlayerTurn ENDP
DealerTurn PROC
    ret
DealerTurn ENDP
ResolveRound PROC
    ret
ResolveRound ENDP
RenderRound PROC
    ret
RenderRound ENDP
PromptReplay PROC
    ret
PromptReplay ENDP
ShutdownGame PROC
    ret
ShutdownGame ENDP
END main
