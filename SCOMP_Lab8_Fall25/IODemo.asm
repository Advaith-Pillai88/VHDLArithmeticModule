; Produces a "bouncing" animation on the LEDs.
; The LED pattern is initialized with the switch state.

ORG 0

	; Get and store the switch values
	IN     Switches
	OUT    LEDs

  ;Store Random = 4
  LOADI 4
  STORE random
  OUT Hex0

  ;Store Score = 0 and display
  LOADI 0
  STORE score
  OUT Hex1


 ;Code should only start when two or less switches are raised
 WaitForTwoSwitches:

    IN Switches
 	STORE SwitchPattern
    AND Bit0
    STORE SW0
    LOAD SwitchPattern
    SHIFT -1
    AND Bit0
    STORE SW1
    LOAD SwitchPattern
    SHIFT -2
    AND Bit0
    STORE SW2
    LOAD SwitchPattern
    SHIFT -3
    AND Bit0
    STORE SW3
    LOAD SwitchPattern
    SHIFT -4
    AND Bit0
    STORE SW4
    LOAD SwitchPattern
    SHIFT -5
    AND Bit0
    STORE SW5
    LOAD SwitchPattern
    SHIFT -6
    AND Bit0
    STORE SW6
    LOAD SwitchPattern
    SHIFT -7
    AND Bit0
    STORE SW7
    LOAD SwitchPattern
    SHIFT -8
    AND Bit0
    STORE SW8
    LOAD SwitchPattern
    SHIFT -9
    AND Bit0
    STORE SW9
    LOAD SwitchPattern

    LOAD SW0
    ADD SW1
    ADD SW2
    ADD SW3
    ADD SW4
    ADD SW5
    ADD SW6
    ADD SW7
    ADD SW8
    ADD SW9


    ;Check if all switches are down
    JZERO Round

    ;Otherwise, Loop back to the beginning
    JUMP WaitForTwoSwitches


;Beginning of Round
Round:

	;Check if all switches are down again
	; Get and store the switch values
	IN     Switches
	OUT    LEDs

 ;Check if all switches are down

    ;Store Switch Pattern
    IN Switches
    OUT LEDs
 	  STORE SwitchPattern

    AND Bit0
    STORE SW0
    LOAD SwitchPattern
    SHIFT -1
    AND Bit0
    STORE SW1
    LOAD SwitchPattern
    SHIFT -2
    AND Bit0
    STORE SW2
    LOAD SwitchPattern
    SHIFT -3
    AND Bit0
    STORE SW3
    LOAD SwitchPattern
    SHIFT -4
    AND Bit0
    STORE SW4
    LOAD SwitchPattern
    SHIFT -5
    AND Bit0
    STORE SW5
    LOAD SwitchPattern
    SHIFT -6
    AND Bit0
    STORE SW6
    LOAD SwitchPattern
    SHIFT -7
    AND Bit0
    STORE SW7
    LOAD SwitchPattern
    SHIFT -8
    AND Bit0
    STORE SW8
    LOAD SwitchPattern
    SHIFT -9
    AND Bit0
    STORE SW9
    LOAD SwitchPattern

    LOAD SW0
    ADD SW1
    ADD SW2
    ADD SW3
    ADD SW4
    ADD SW5
    ADD SW6
    ADD SW7
    ADD SW8
    ADD SW9

  ;If a switch is pressed, go to part 2
  JNZ RoundPartTwo
  
  
  ;If not, go to LFSR Loop
  CALL LFSRLoop
  JUMP Round








;LFSR Loop
LFSRLoop:

  ;Update Switches
  IN Switches
  OUT LEDs

  ;Load random value
  LOAD random

  ;Run LFSR on random
  CALL LFSR

  ;Mask Lower 10 Bits
  AND LowTenBits

  ;Store in random
  STORE random

  ;Return to switch check
  RETURN









RoundPartTwo:

  ;Update Switch State and score
  IN Switches
  OUT LEDs
  LOAD score
  OUT Hex1


  ;Reset the timer

    ;Load 1
    LOADI 1

    ;Reset timer by writing to it
    OUT Timer

  ;Load Random Number
  LOAD random

  ;Display on right side 7 segment display
  OUT Hex0


  ;Delay for 5 seconds (call delay)
  CALL Delay

  ;Get Switch Number
  IN Switches
  OUT LEDs

  ;Subtract by random
  SUB random

  ;If value is not zero, jump to round beginning
  JNZ WaitForTwoSwitches


  ;Otherwise, add one to score and jump to round

    ;Update Score
    LOAD score
    ADDI 1
    STORE score

    ;Update display
    OUT Hex1

    ;Jump to round beginning
    JUMP WaitForTwoSwitches





; To make things happen on a human timescale, the timer is
; used to delay for five seconds.
Delay:

  ;Update switch state
  IN Switches
  OUT LEDs
  LOAD score
  OUT Hex1


  ;Reset Timer
	OUT    Timer

  ;Wait 5 seconds
WaitingLoop:
	IN Switches
    OUT LEDs
	IN     Timer
	ADDI   -50
	JNEG   WaitingLoop

  ;Return
	RETURN






;LFSR Subroutine
LFSR: STORE ACValue

;Store the value of bit 4
SHIFT -4
AND One
STORE Bit4

;Get the value of Bit 9
LOAD ACValue
SHIFT -9
AND One

;XOR the values
XOR Bit4
STORE XORValue

;Load Original Value and Shift Left
LOAD ACValue
SHIFT 1

;Add XORed bit to bit 0
ADD XORValue

;Return
RETURN




;LFSR Variables
One: DW 1
ACValue: DW 0
Bit4: DW 0
XORValue: DW 0
Storage: DW 0

; Variables
Pattern:   DW 0

; Useful values
Bit0:      DW &B0000000001
Bit9:      DW &B1000000000
LowTenBits: DW &B01111111111


; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005

;Random Number
random: DW 0

;Score
score: DW 0

;Switch Bits
SwitchPattern: DW 0
SW0: DW 0
SW1: DW 0
SW2: DW 0
SW3: DW 0
SW4: DW 0
SW5: DW 0
SW6: DW 0
SW7: DW 0
SW8: DW 0
SW9: DW 0