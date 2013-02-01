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
; The interrupt service routine.
; This is the "IO-loop" implementation. It assumes the interrupt is only
; triggered by TMR2 and that bank0 is selected.
;*******************************************************************************
#include <P16F684.INC>
#include "iolatch.inc"
#include "pwm.inc"
    extern uart_rx_tick
    extern uart_tx_tick

;*******************************************************************************
isr_local_data UDATA_SHR
w_buf RES 1
s_buf RES 1

;*******************************************************************************
interrupt_vector CODE 0x04
; store the STATUS and W registers                                    ; 3
    movwf w_buf                                                       ; +1
    swapf STATUS, W                                                   ; +1
    movwf s_buf                                                       ; +1

; switch to bank0
    ;bcf STATUS, RP0 ;assuming main routine stays in bank0

; clear all interrupt flags
    ;movlw b'11111000' ; assuming only TMR2IF
    ;andwf INTCON, F ; assuming only TMR2IF
    bcf  PIR1, TMR2IF                                                 ; +1

; write outputs to PORTA and read inputs
    io_latch                                                          ; +4
; generate pwm signal                                                 ;min/typ/max
    pwm_step ;                                                        ;+11/11/20
; handle uart
    call uart_rx_tick                                                 ;+11/12/16
    ;call uart_tx_tick ;+12/12/15

; restore the STATUS and W registers
    swapf s_buf, W                                                    ; +1
    movwf STATUS                                                      ; +1
    swapf w_buf, F                                                    ; +1
    swapf w_buf, W                                                    ; +1
    retfie                                                            ; +2
                                           ;total cycles: min=43 typ=44 max=57
; never reached, added for convenient debugging
    movfw TMR2

    END