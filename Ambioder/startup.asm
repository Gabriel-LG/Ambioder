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
; Documentation
;*******************************************************************************
    global startup

;*******************************************************************************
    extern pwm_period, pwm_red, pwm_green, pwm_blue

;*******************************************************************************
    UDATA
delay_count RES 1

;*******************************************************************************
color_to_max MACRO color, delay
    local loop,done
    movlw delay
    movwf delay_count
    movfw color
loop
    movwf color
    decfsz delay_count, F
    goto loop
    movlw delay
    movwf delay_count
    incfsz color, W
    goto loop
done
    ENDM

;*******************************************************************************
color_to_min MACRO color, delay
    local loop,done
    movlw delay
    movwf delay_count
loop
    nop
    decfsz delay_count, F
    goto loop
    movlw delay
    movwf delay_count
    decfsz color, F
    goto loop
done
    ENDM

;*******************************************************************************
    CODE
startup

    color_to_max pwm_red, d'96'
    color_to_max pwm_green, d'96'
    color_to_min pwm_red, d'96'
    color_to_max pwm_blue, d'96'
    color_to_min pwm_green, d'96'
    color_to_max pwm_red, d'96'
    color_to_min pwm_blue, d'96'
    color_to_min pwm_red, d'96'

    return

    END