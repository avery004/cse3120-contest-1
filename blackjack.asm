; blackjack.asm

INCLUDE Irvine32.inc

InitializeGame PROTO
ResetRound PROTO
RunGame PROTO
DeckInit PROTO
ShuffleDeck PROTO
DrawCard PROTO
HandleOutOfCards PROTO
DealOpeningHands PROTO
AddCardToPlayer PROTO
AddCardToDealer PROTO
RecalcPlayerTotal PROTO
RecalcDealerTotal PROTO
DrawTable PROTO
RenderPlayerHand PROTO
RenderDealerHand PROTO
RenderStatusLine PROTO
RenderStartupScreen PROTO
RenderRoundSummary PROTO
SetupRound PROTO
PlayerTurn PROTO
DealerTurn PROTO
ResolveRound PROTO
RenderRound PROTO
UpdateScore PROTO
PromptReplay PROTO
ShutdownGame PROTO
WriteCardRank PROTO

.data
DECK_SIZE = 52
MAX_HAND_SIZE = 12
ACTION_HIT = 1
ACTION_STAND = 2
TURN_RESULT_NONE = 0
TURN_RESULT_STAND = 1
TURN_RESULT_BUST = 2
TURN_RESULT_BLACKJACK = 3
ROUND_RESULT_NONE = 0
ROUND_RESULT_PLAYER_WIN = 1
ROUND_RESULT_DEALER_WIN = 2
ROUND_RESULT_PUSH = 3

titleText BYTE "BLACKJACK - MASM + Irvine32",0
subtitleText BYTE "Console blackjack with full game flow.",0
instructionsText BYTE "Use 1 for Hit and 2 for Stand.",0

tableTop BYTE "+--------------------------------------+",0
tableDealerRow BYTE "| Dealer Area                          |",0
tablePlayerRow BYTE "| Player Area                          |",0
tableBottom BYTE "+--------------------------------------+",0

dealerHandLabel BYTE "Dealer Hand: ",0
playerHandLabel BYTE "Player Hand: ",0
totalLabel BYTE "Total: ",0
hiddenCardMsg BYTE "[hidden]",0
hiddenTotalMsg BYTE "?",0
startPrompt BYTE "Press ENTER to start the first round.",0

statusPrefix BYTE "Status: ",0
statusPlayerTurn BYTE "Player turn.",0
statusDealerTurn BYTE "Dealer turn.",0
statusPlayerBust BYTE "Player busted.",0
statusPlayerBlackjack BYTE "Player has 21.",0
statusRoundComplete BYTE "Round complete.",0

summaryPrefix BYTE "Round Result: ",0
summaryPlayerWin BYTE "Player wins.",0
summaryDealerWin BYTE "Dealer wins.",0
summaryPush BYTE "Push.",0
summaryPending BYTE "In progress.",0

scorePrefix BYTE "Score - Player: ",0
scoreMiddle BYTE "  Dealer: ",0
cardsLeftPrefix BYTE "Cards left in deck: ",0

promptHitStand BYTE "Hit(1) or Stand(2): ",0
invalidActionMsg BYTE "Invalid input. Enter 1 or 2.",0
replayPrompt BYTE "Play another round? (1=Yes, 0=No): ",0
replayInvalid BYTE "Invalid input. Enter 1 or 0.",0
shutdownText BYTE "Thanks for playing Blackjack.",0
spaceText BYTE " ",0

rankA BYTE "A",0
rank2 BYTE "2",0
rank3 BYTE "3",0
rank4 BYTE "4",0
rank5 BYTE "5",0
rank6 BYTE "6",0
rank7 BYTE "7",0
rank8 BYTE "8",0
rank9 BYTE "9",0
rank10 BYTE "10",0
rankJ BYTE "J",0
rankQ BYTE "Q",0
rankK BYTE "K",0
rankNameTable DWORD OFFSET rankA, OFFSET rank2, OFFSET rank3, OFFSET rank4, OFFSET rank5, OFFSET rank6, OFFSET rank7, OFFSET rank8, OFFSET rank9, OFFSET rank10, OFFSET rankJ, OFFSET rankQ, OFFSET rankK

deck BYTE DECK_SIZE DUP(0)
playerHand BYTE MAX_HAND_SIZE DUP(0)
dealerHand BYTE MAX_HAND_SIZE DUP(0)

playerCount DWORD 0
dealerCount DWORD 0
playerTotal DWORD 0
dealerTotal DWORD 0
continueRound DWORD 1
deckIndex DWORD 0
actionChoice DWORD ACTION_STAND
playerTurnStatus DWORD TURN_RESULT_NONE
dealerTurnStatus DWORD TURN_RESULT_NONE
roundResult DWORD ROUND_RESULT_NONE
playerScore DWORD 0
dealerScore DWORD 0

.code
main PROC
    call InitializeGame
MainLoop:
    call ResetRound
    call RunGame
    call PromptReplay
    cmp continueRound, 1
    je MainLoop
    call ShutdownGame
    exit
main ENDP

InitializeGame PROC
    call Randomize
    mov continueRound, 1
    mov playerScore, 0
    mov dealerScore, 0
    call RenderStartupScreen
    ret
InitializeGame ENDP

ResetRound PROC
    mov playerCount, 0
    mov dealerCount, 0
    mov playerTotal, 0
    mov dealerTotal, 0
    mov actionChoice, ACTION_STAND
    mov playerTurnStatus, TURN_RESULT_NONE
    mov dealerTurnStatus, TURN_RESULT_NONE
    mov roundResult, ROUND_RESULT_NONE
    ret
ResetRound ENDP

RunGame PROC
    call SetupRound
    call PlayerTurn
    cmp playerTurnStatus, TURN_RESULT_BUST
    je SkipDealerTurn
    cmp playerTurnStatus, TURN_RESULT_BLACKJACK
    je SkipDealerTurn
    call DealerTurn
SkipDealerTurn:
    call ResolveRound
    call RenderRound
    ret
RunGame ENDP

DeckInit PROC
    mov ecx, 4
    xor esi, esi
DeckSuitLoop:
    xor ebx, ebx
DeckRankLoop:
    mov deck[esi], bl
    inc bl
    inc esi
    cmp bl, 13
    jb DeckRankLoop
    loop DeckSuitLoop
    mov deckIndex, 0
    ret
DeckInit ENDP

ShuffleDeck PROC
    mov esi, DECK_SIZE - 1
ShuffleLoop:
    cmp esi, 0
    jle ShuffleDone
    mov eax, esi
    inc eax
    call RandomRange
    mov bl, deck[esi]
    mov dl, deck[eax]
    mov deck[esi], dl
    mov deck[eax], bl
    dec esi
    jmp ShuffleLoop
ShuffleDone:
    ret
ShuffleDeck ENDP

DrawCard PROC
    mov eax, deckIndex
    cmp eax, DECK_SIZE
    jb DrawCardReady
    call HandleOutOfCards
    mov eax, deckIndex
    cmp eax, DECK_SIZE
    jae DrawCardFail
DrawCardReady:
    mov dl, deck[eax]
    inc eax
    mov deckIndex, eax
    mov al, dl
    ret
DrawCardFail:
    mov al, 0
    ret
DrawCard ENDP

HandleOutOfCards PROC
    call DeckInit
    call ShuffleDeck
    ret
HandleOutOfCards ENDP

DealOpeningHands PROC
    call AddCardToPlayer
    call AddCardToDealer
    call AddCardToPlayer
    call AddCardToDealer
    ret
DealOpeningHands ENDP

AddCardToPlayer PROC
    cmp playerCount, MAX_HAND_SIZE
    jae AddCardToPlayerDone
    call DrawCard
    mov ebx, playerCount
    mov playerHand[ebx], al
    inc playerCount
    call RecalcPlayerTotal
AddCardToPlayerDone:
    ret
AddCardToPlayer ENDP

AddCardToDealer PROC
    cmp dealerCount, MAX_HAND_SIZE
    jae AddCardToDealerDone
    call DrawCard
    mov ebx, dealerCount
    mov dealerHand[ebx], al
    inc dealerCount
    call RecalcDealerTotal
AddCardToDealerDone:
    ret
AddCardToDealer ENDP

RecalcPlayerTotal PROC
    mov ecx, playerCount
    xor esi, esi
    xor edi, edi
    xor ebx, ebx
RecalcPlayerLoop:
    cmp esi, ecx
    jae RecalcPlayerAdjust
    movzx eax, BYTE PTR playerHand[esi]
    cmp eax, 0
    je RecalcPlayerAce
    cmp eax, 10
    jae RecalcPlayerTen
    inc eax
    add edi, eax
    jmp RecalcPlayerNext
RecalcPlayerAce:
    add edi, 11
    inc ebx
    jmp RecalcPlayerNext
RecalcPlayerTen:
    add edi, 10
RecalcPlayerNext:
    inc esi
    jmp RecalcPlayerLoop
RecalcPlayerAdjust:
    cmp edi, 21
    jle RecalcPlayerStore
    cmp ebx, 0
    je RecalcPlayerStore
    sub edi, 10
    dec ebx
    jmp RecalcPlayerAdjust
RecalcPlayerStore:
    mov playerTotal, edi
    ret
RecalcPlayerTotal ENDP

RecalcDealerTotal PROC
    mov ecx, dealerCount
    xor esi, esi
    xor edi, edi
    xor ebx, ebx
RecalcDealerLoop:
    cmp esi, ecx
    jae RecalcDealerAdjust
    movzx eax, BYTE PTR dealerHand[esi]
    cmp eax, 0
    je RecalcDealerAce
    cmp eax, 10
    jae RecalcDealerTen
    inc eax
    add edi, eax
    jmp RecalcDealerNext
RecalcDealerAce:
    add edi, 11
    inc ebx
    jmp RecalcDealerNext
RecalcDealerTen:
    add edi, 10
RecalcDealerNext:
    inc esi
    jmp RecalcDealerLoop
RecalcDealerAdjust:
    cmp edi, 21
    jle RecalcDealerStore
    cmp ebx, 0
    je RecalcDealerStore
    sub edi, 10
    dec ebx
    jmp RecalcDealerAdjust
RecalcDealerStore:
    mov dealerTotal, edi
    ret
RecalcDealerTotal ENDP

DrawTable PROC
    call Clrscr
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov edx, OFFSET tableTop
    call WriteString
    call Crlf
    mov edx, OFFSET tableDealerRow
    call WriteString
    call Crlf
    mov edx, OFFSET tablePlayerRow
    call WriteString
    call Crlf
    mov edx, OFFSET tableBottom
    call WriteString
    call Crlf

    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET scorePrefix
    call WriteString
    mov eax, playerScore
    call WriteDec
    mov edx, OFFSET scoreMiddle
    call WriteString
    mov eax, dealerScore
    call WriteDec
    call Crlf

    mov edx, OFFSET cardsLeftPrefix
    call WriteString
    mov eax, DECK_SIZE
    sub eax, deckIndex
    call WriteDec
    call Crlf
    call Crlf
    ret
DrawTable ENDP

RenderPlayerHand PROC
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET playerHandLabel
    call WriteString
    xor esi, esi
RenderPlayerHandLoop:
    cmp esi, playerCount
    jae RenderPlayerHandDone
    mov al, playerHand[esi]
    call WriteCardRank
    inc esi
    jmp RenderPlayerHandLoop
RenderPlayerHandDone:
    call Crlf
    mov edx, OFFSET totalLabel
    call WriteString
    mov eax, playerTotal
    call WriteDec
    call Crlf
    call Crlf
    ret
RenderPlayerHand ENDP

RenderDealerHand PROC
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET dealerHandLabel
    call WriteString
    cmp roundResult, ROUND_RESULT_NONE
    jne RenderDealerReveal

    cmp dealerCount, 0
    je RenderDealerHiddenDone
    mov al, dealerHand[0]
    call WriteCardRank
    cmp dealerCount, 1
    jbe RenderDealerHiddenDone
    mov edx, OFFSET hiddenCardMsg
    call WriteString
RenderDealerHiddenDone:
    call Crlf
    mov edx, OFFSET totalLabel
    call WriteString
    mov edx, OFFSET hiddenTotalMsg
    call WriteString
    call Crlf
    call Crlf
    ret

RenderDealerReveal:
    xor esi, esi
RenderDealerRevealLoop:
    cmp esi, dealerCount
    jae RenderDealerRevealDone
    mov al, dealerHand[esi]
    call WriteCardRank
    inc esi
    jmp RenderDealerRevealLoop
RenderDealerRevealDone:
    call Crlf
    mov edx, OFFSET totalLabel
    call WriteString
    mov eax, dealerTotal
    call WriteDec
    call Crlf
    call Crlf
    ret
RenderDealerHand ENDP

RenderStatusLine PROC
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET statusPrefix
    call WriteString

    cmp roundResult, ROUND_RESULT_NONE
    jne StatusRoundFinished
    cmp playerTurnStatus, TURN_RESULT_BUST
    je StatusPlayerBusted
    cmp playerTurnStatus, TURN_RESULT_BLACKJACK
    je StatusPlayerHas21
    cmp playerTurnStatus, TURN_RESULT_STAND
    je StatusDealerPlaying
    mov edx, OFFSET statusPlayerTurn
    jmp StatusPrint

StatusRoundFinished:
    mov edx, OFFSET statusRoundComplete
    jmp StatusPrint
StatusPlayerBusted:
    mov edx, OFFSET statusPlayerBust
    jmp StatusPrint
StatusPlayerHas21:
    mov edx, OFFSET statusPlayerBlackjack
    jmp StatusPrint
StatusDealerPlaying:
    mov edx, OFFSET statusDealerTurn
StatusPrint:
    call WriteString
    call Crlf
    call Crlf
    ret
RenderStatusLine ENDP

RenderStartupScreen PROC
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET titleText
    call WriteString
    call Crlf
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov edx, OFFSET subtitleText
    call WriteString
    call Crlf
    mov edx, OFFSET instructionsText
    call WriteString
    call Crlf
    call Crlf
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET startPrompt
    call WriteString
    call Crlf
    call ReadChar
    ret
RenderStartupScreen ENDP

RenderRoundSummary PROC
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov edx, OFFSET summaryPrefix
    call WriteString

    cmp roundResult, ROUND_RESULT_PLAYER_WIN
    je SummaryPlayerWin
    cmp roundResult, ROUND_RESULT_DEALER_WIN
    je SummaryDealerWin
    cmp roundResult, ROUND_RESULT_PUSH
    je SummaryPush
    mov edx, OFFSET summaryPending
    jmp SummaryPrint
SummaryPlayerWin:
    mov edx, OFFSET summaryPlayerWin
    jmp SummaryPrint
SummaryDealerWin:
    mov edx, OFFSET summaryDealerWin
    jmp SummaryPrint
SummaryPush:
    mov edx, OFFSET summaryPush
SummaryPrint:
    call WriteString
    call Crlf
    call Crlf
    ret
RenderRoundSummary ENDP

SetupRound PROC
    call DeckInit
    call ShuffleDeck
    call DealOpeningHands
    ret
SetupRound ENDP

PlayerTurn PROC
    mov playerTurnStatus, TURN_RESULT_NONE
    cmp playerTotal, 21
    jne PlayerTurnLoop
    mov playerTurnStatus, TURN_RESULT_BLACKJACK
    mov eax, playerTurnStatus
    ret

PlayerTurnLoop:
    call DrawTable
    call RenderDealerHand
    call RenderPlayerHand
    call RenderStatusLine

    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET promptHitStand
    call WriteString
    call ReadInt
    mov actionChoice, eax

    cmp actionChoice, ACTION_HIT
    je PlayerTurnHit
    cmp actionChoice, ACTION_STAND
    je PlayerTurnStand
    mov edx, OFFSET invalidActionMsg
    call WriteString
    call Crlf
    call Crlf
    jmp PlayerTurnLoop

PlayerTurnHit:
    call AddCardToPlayer
    cmp playerTotal, 21
    ja PlayerTurnBust
    cmp playerTotal, 21
    je PlayerTurnBlackjack
    jmp PlayerTurnLoop

PlayerTurnStand:
    mov playerTurnStatus, TURN_RESULT_STAND
    mov eax, playerTurnStatus
    ret

PlayerTurnBust:
    mov playerTurnStatus, TURN_RESULT_BUST
    mov eax, playerTurnStatus
    ret
PlayerTurnBlackjack:
    mov playerTurnStatus, TURN_RESULT_BLACKJACK
    mov eax, playerTurnStatus
    ret
PlayerTurn ENDP

DealerTurn PROC
    mov dealerTurnStatus, TURN_RESULT_STAND
DealerTurnLoop:
    cmp dealerTotal, 17
    jae DealerTurnDone
    cmp dealerCount, MAX_HAND_SIZE
    jae DealerTurnDone
    call AddCardToDealer
    cmp dealerTotal, 21
    ja DealerTurnBust
    jmp DealerTurnLoop
DealerTurnBust:
    mov dealerTurnStatus, TURN_RESULT_BUST
DealerTurnDone:
    ret
DealerTurn ENDP

ResolveRound PROC
    mov roundResult, ROUND_RESULT_NONE

    cmp playerTurnStatus, TURN_RESULT_BUST
    je ResolveDealerWin
    cmp dealerTurnStatus, TURN_RESULT_BUST
    je ResolvePlayerWin

    xor esi, esi
    cmp playerCount, 2
    jne ResolvePlayerBlackjackDone
    cmp playerTotal, 21
    jne ResolvePlayerBlackjackDone
    mov esi, 1
ResolvePlayerBlackjackDone:

    xor edi, edi
    cmp dealerCount, 2
    jne ResolveDealerBlackjackDone
    cmp dealerTotal, 21
    jne ResolveDealerBlackjackDone
    mov edi, 1
ResolveDealerBlackjackDone:

    cmp esi, 1
    jne ResolveCheckDealerNatural
    cmp edi, 1
    je ResolvePush
    jmp ResolvePlayerWin
ResolveCheckDealerNatural:
    cmp edi, 1
    je ResolveDealerWin

    mov eax, playerTotal
    cmp eax, dealerTotal
    ja ResolvePlayerWin
    jb ResolveDealerWin
    jmp ResolvePush

ResolvePlayerWin:
    mov roundResult, ROUND_RESULT_PLAYER_WIN
    jmp ResolveApplyScore
ResolveDealerWin:
    mov roundResult, ROUND_RESULT_DEALER_WIN
    jmp ResolveApplyScore
ResolvePush:
    mov roundResult, ROUND_RESULT_PUSH
ResolveApplyScore:
    call UpdateScore
    ret
ResolveRound ENDP

RenderRound PROC
    call DrawTable
    call RenderDealerHand
    call RenderPlayerHand
    call RenderStatusLine
    call RenderRoundSummary
    ret
RenderRound ENDP

UpdateScore PROC
    cmp roundResult, ROUND_RESULT_PLAYER_WIN
    jne UpdateScoreDealerCheck
    inc playerScore
    ret
UpdateScoreDealerCheck:
    cmp roundResult, ROUND_RESULT_DEALER_WIN
    jne UpdateScoreDone
    inc dealerScore
UpdateScoreDone:
    ret
UpdateScore ENDP

PromptReplay PROC
PromptReplayLoop:
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET replayPrompt
    call WriteString
    call ReadInt
    cmp eax, 1
    je PromptReplayYes
    cmp eax, 0
    je PromptReplayNo
    mov edx, OFFSET replayInvalid
    call WriteString
    call Crlf
    jmp PromptReplayLoop

PromptReplayYes:
    mov continueRound, 1
    ret
PromptReplayNo:
    mov continueRound, 0
    ret
PromptReplay ENDP

ShutdownGame PROC
    call Crlf
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov edx, OFFSET shutdownText
    call WriteString
    call Crlf
    mov edx, OFFSET scorePrefix
    call WriteString
    mov eax, playerScore
    call WriteDec
    mov edx, OFFSET scoreMiddle
    call WriteString
    mov eax, dealerScore
    call WriteDec
    call Crlf
    ret
ShutdownGame ENDP

WriteCardRank PROC
    movzx eax, al
    cmp eax, 12
    jbe WriteCardRankIndexOk
    mov eax, 0
WriteCardRankIndexOk:
    mov edx, rankNameTable[eax*4]
    call WriteString
    mov edx, OFFSET spaceText
    call WriteString
    ret
WriteCardRank ENDP

END main
