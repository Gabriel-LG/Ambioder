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
; the main program
; mainloop is the entrypoint
;*******************************************************************************
   global mainloop

;*******************************************************************************
#include "uart.inc"
    extern uart_rx_flags, uart_rx_byte
    extern uart_tx_flags, uart_tx_byte
    extern pwm_period, pwm_red, pwm_green, pwm_blue

 
;*******************************************************************************
    UDATA
rx_period RES 1
rx_red RES 1
rx_green RES 1
rx_blue RES 1


;*******************************************************************************
; This macro attempts to receive a data nibble from the uart. On success the
; address nibble is cleared from uart_rx_byte. On failure uart_rx_byte is not
; modified.
; - expectedAddress must be the value of the most significant (address) nibble
; - onFailure must be the label to jump to on failure. This is done if the
;   address nibble does not match the expected address, or if the uart
;   encounters an error or overflow.
;*******************************************************************************
receive macro expectAddress, onFailure
    local loop, fail
loop
    ; failure on rx error
    btfsc uart_rx_flags, UART_RX_ERROR
    goto onFailure
    ; failure on overflow
    btfsc uart_rx_flags, UART_RX_OVERFLOW
    goto onFailure
    ; loop until received
    btfss uart_rx_flags, UART_RX_DATA
    goto loop

    movlw expectAddress << 4
    xorwf uart_rx_byte, F
    btfsc uart_rx_byte, 4
    goto fail
    btfsc uart_rx_byte, 5
    goto fail
    btfsc uart_rx_byte, 6
    goto fail
    btfsc uart_rx_byte, 7
    goto fail
    goto $+3
fail
    xorwf uart_rx_byte, F
    goto onFailure
    endm

;*******************************************************************************
    CODE
mainloop
    clrf uart_rx_flags

receive_start
    movf pwm_period, W
    movwf rx_period
    receive 2, receive_period
    goto parse_red
receive_period
    nop ; for debugging, because mplabx cannot set breakpoints in macros
    receive 0, mainloop
    swapf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    movwf rx_period
    receive 1, receive_start
    movf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    iorwf rx_period, F

    receive 2, receive_start
parse_red
    swapf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    movwf rx_red
    receive 3, receive_start
    movf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    iorwf rx_red, F

    receive 4, receive_start
    swapf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    movwf rx_green
    receive 5, receive_start
    movf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    iorwf rx_green, F

    receive 6, receive_start
    swapf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    movwf rx_blue
    receive 7, receive_start
    movf uart_rx_byte, W
    bcf uart_rx_flags, UART_RX_DATA
    iorwf rx_blue, F

    ;set colors
    movfw rx_period
    movwf pwm_period
    movfw rx_red
    movwf pwm_red
    movfw rx_green
    movwf pwm_green
    movfw rx_blue
    movwf pwm_blue

    goto receive_period
    END
