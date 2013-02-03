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
pwm_step MACRO
    extern pwm_period, pwm_red, pwm_green, pwm_blue
    extern step_count, red_count, green_count, blue_count
    local pwm_loop
    ;decrease step_count and setup loop when 0 is reached
    decfsz step_count, F
    goto pwm_loop
    ;reset pwm step_count
    movfw pwm_period
    movwf step_count
    ;reset red counter
    incf pwm_red, W
    movwf red_count
    ;reset green counter
    incf pwm_green, W
    movwf green_count
    ;reset blue counter and set blue output
    incf pwm_blue, W
    movwf blue_count
    ;set the outputs
    movlw (1<<IO_RED) | (1<<IO_GREEN) | (1 << IO_BLUE)
    iorwf io_buffer, F
pwm_loop
    movlw ~((1<<IO_RED) | (1<<IO_GREEN) | (1 << IO_BLUE))
    ;decrease red_count and clear red if 0
    decfsz red_count, F
    iorlw 1<<IO_RED
    ;decrease green_count and clear green if 0
    decfsz green_count, F
    iorlw 1<<IO_GREEN
    ;decrease blue_count and clear blue if 0
    decfsz blue_count, F
    iorlw 1<<IO_BLUE

    andwf io_buffer, F
    ENDM