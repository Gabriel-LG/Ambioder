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
    ;only for access by isr_enter/isr_exit macros:
    global w_buf
    ;global s_buf     ;assuming STATUS not used

#include <P16F684.INC>
#include "iolatch.inc"
#include "uart.inc"

    extern uart_rx_sample
    extern pwm_step

;*******************************************************************************
isr_local_data UDATA_SHR
w_buf RES 1
;s_buf RES 1  ;assuming STATUS not used

;*******************************************************************************
interrupt_vector CODE 0x04                                            ; 3
; enter interrupt service routine
    movwf w_buf        ; only storing W, discarding STATUS
    clrf  PIR1         ;assuming only TMR2IF

; write outputs to PORTA and read inputs
    io_latch                                                          ; +4
; generate pwm signal                                                 ;min/typ/max
    call pwm_step                                                     ;+15/15/24
; handle uart
    call uart_rx_sample                                               ;+9/10/14

; exit interrupt service routine
    movfw w_buf      ;assuming STATUS not used                        ; +1
    retfie                                                            ; +2


;                                            ;total cycles: min=34 typ=35 max=48
; never reached, added for convenient debugging
    movfw TMR2

    END