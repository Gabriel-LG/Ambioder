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
; Generates a pwm signal for an RGB LED.
; * Call pwm_init to initialize the pwm. (assumes bank 0 is selected)
; * Call pwm_step on a regular interval (assumes bank 0 is selected)
; * Write to pwm_period to set the pwm_period
; * Write to pwm_red/green/blue to alter the ductycycles.
;*******************************************************************************
    global pwm_init
    global pwm_period, pwm_red, pwm_green, pwm_blue
    ;only for access by pwm_step macro:
    global step_count, red_count, green_count, blue_count
;*******************************************************************************
; Implementation
;*******************************************************************************
#include <P16F684.INC>
#include "iolatch.inc"
    extern io_buffer

;*******************************************************************************
pwm_global_data UDATA_SHR
pwm_red RES 1
pwm_green RES 1
pwm_blue RES 1
pwm_period RES 1

pwm_local_data UDATA
step_count RES 1
red_count RES 1
green_count RES 1
blue_count RES 1

;*******************************************************************************
    CODE
pwm_init
    ; make sure pwm_step gets setup when pwm_tick is called
    movlw 1
    movwf step_count
    ; set initial dutycycles
    movlw h'ff'
    movwf pwm_period
    clrf pwm_red
    clrf pwm_green
    clrf pwm_blue
    return

;*******************************************************************************
    END