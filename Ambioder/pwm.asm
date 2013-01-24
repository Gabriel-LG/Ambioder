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
    global pwm_step
    global pwm_period, pwm_red, pwm_green, pwm_blue

;*******************************************************************************
; Implementation
;*******************************************************************************
#include <p16f684.inc>
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
    movlw d'63'
    movwf pwm_period
    movlw d'1'
    movwf pwm_red
    movlw d'32'
    movwf pwm_green
    movlw d'62'
    movwf pwm_blue
    return

;*******************************************************************************
pwm_step
    ;decrease step_count and setup loop when 0 is reached
    decfsz step_count, F
    goto pwm_loop
    ;reset pwm step_count
    movfw pwm_period
    movwf step_count
    ;reset color counters
    incf pwm_red, W
    movwf red_count
    incf pwm_green, W
    movwf green_count
    incf pwm_blue, W
    movwf blue_count
    ;set the outputs
    movlw b'00000111'
    iorwf io_buffer, F
pwm_loop
    ;decrease red_count and clear red output when 0 is reached
    decfsz red_count, F
    goto $+2
    bcf io_buffer, IO_RED
    ;decrease green_count and clear green output when 0 is reached
    decfsz green_count, F
    goto $+2
    bcf io_buffer, IO_GREEN
    ;decrease blue_count and clear blue output when 0 is reached
    decfsz blue_count, F
    goto $+2
    bcf io_buffer, IO_BLUE
    return

    END