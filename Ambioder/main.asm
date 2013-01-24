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
    CODE
mainloop
    clrf uart_rx_flags

receive_period
    ; restart on rx error
    btfsc uart_rx_flags, UART_RX_ERROR
    goto mainloop
    ; restart on overflow
    btfsc uart_rx_flags, UART_RX_OVERFLOW
    goto mainloop
    ; check for received bytes
    btfss uart_rx_flags, UART_RX_DATA
    goto receive_period
    ; check if received is b'00xxxxxx'
    btfsc uart_rx_byte, 7
    goto mainloop
    btfsc uart_rx_byte, 6
    goto mainloop
    movlw b'00111111'
    andwf uart_rx_byte, W
    movwf rx_period
    ; clear UART_RX_DATA
    bcf uart_rx_flags, UART_RX_DATA

receive_red
    ; restart on rx error
    btfsc uart_rx_flags, UART_RX_ERROR
    goto mainloop
    ; restart on overflow
    btfsc uart_rx_flags, UART_RX_OVERFLOW
    goto mainloop
    ; check for received bytes
    btfss uart_rx_flags, UART_RX_DATA
    goto receive_red
    ; check if received is b'01xxxxxx'
    btfsc uart_rx_byte, 7
    goto receive_period
    btfss uart_rx_byte, 6
    goto receive_period
    ;move 6 least significant bytes to rx_red
    movlw b'00111111'
    andwf uart_rx_byte, W
    movwf rx_red
    ; clear UART_RX_DATA
    bcf uart_rx_flags, UART_RX_DATA

receive_green
    ; restart on rx error
    btfsc uart_rx_flags, UART_RX_ERROR
    goto mainloop
    ; restart on overflow
    btfsc uart_rx_flags, UART_RX_OVERFLOW
    goto mainloop
    ; check for received bytes
    btfss uart_rx_flags, UART_RX_DATA
    goto receive_green
    ; check if received is b'10xxxxxx'
    btfss uart_rx_byte, 7
    goto receive_period
    btfsc uart_rx_byte, 6
    goto receive_period
    ;move 6 least significant bytes to rx_green
    movlw b'00111111'
    andwf uart_rx_byte, W
    movwf rx_green
    ; clear UART_RX_DATA
    bcf uart_rx_flags, UART_RX_DATA

receive_blue
    ; restart on rx error
    btfsc uart_rx_flags, UART_RX_ERROR
    goto mainloop
    ; restart on overflow
    btfsc uart_rx_flags, UART_RX_OVERFLOW
    goto mainloop
    ; check for received bytes
    btfss uart_rx_flags, UART_RX_DATA
    goto receive_blue
    ; check if received is b'11xxxxxx'
    btfss uart_rx_byte, 7
    goto receive_period
    btfss uart_rx_byte, 6
    goto receive_period
    ;move 6 least significant bytes to rx_blue
    movlw b'00111111'
    andwf uart_rx_byte, W
    movwf rx_blue
    ; clear UART_RX_DATA
    bcf uart_rx_flags, UART_RX_DATA

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
