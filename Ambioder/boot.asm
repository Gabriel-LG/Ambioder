; Copyright (c) 2013, Lambertus Gorter <l.gorter@gmail.com>
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
; 1. Redistributions of source code must retain the above copyright
; notice, this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
; notice, this list of conditions and the following disclaimer in the
; documentation and/or other materials provided with the distribution.
; 3. The names of its contributors may not be used to endorse or promote
; products derived from this software without specific prior written
; permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
; ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;*******************************************************************************
; The framework for the program
; * intializes the hardware
; * provides "transparent" interrupt handling
; * calls the main routine
;*******************************************************************************
    list p=16f684
    #include <P16F684.INC>
    __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _MCLRE_OFF & _PWRTE_OFF & _WDT_OFF & _INTRC_OSC_NOCLKOUT

    extern uart_rx_init
    extern uart_tx_init
    extern pwm_init


;*******************************************************************************
reset_vector CODE 0x00
    goto initialize


;*******************************************************************************
    CODE
initialize
;init oscillator
    bsf STATUS, RP0 ; bank1
    movlw b'01111001' ; 8Mhz internal oscillator
    movwf OSCCON
    bcf STATUS, RP0 ; bank0

;init PORTA
    clrf PORTA

;disable comparators
    movlw b'00000111'
    movwf CMCON0

;select analog/digital pins
    bsf STATUS, RP0 ; bank 1
    movlw b'11110000' ; AN4..6 are no care, configured as analog
    movwf ANSEL
    bcf STATUS, RP0 ; bank 0

;select input/output pins
    bsf STATUS, RP0 ; bank 1
    movlw b'11111000' ; RA2..0 are output
    movwf TRISA
    movlw b'00111111' ; RC5..0 are input
    movwf TRISC
    bcf STATUS, RP0 ; bank 0

;init Timer2
    bcf PIR1, TMR2IF
    bsf STATUS, RP0 ; bank1
    bsf PIE1, TMR2IE; enable timer1 interrupt
    movlw 0x45 ; 9600hz
    movwf PR2
    bcf STATUS, RP0 ; bank0
    movlw b'00000100' ; Finstr, 1:1, on
    movwf T2CON

; init pwm
    call pwm_init
; init uart
    call uart_rx_init
    ;call uart_tx_init

; enable interrupts
    bsf INTCON, PEIE; enable peripheral interrupts
    bsf INTCON, GIE; enable global interrupts

; jump to the main loop
    extern mainloop
    goto mainloop

    END


