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
; command_loop is the entrypoint
;
; **** BIG FAT WARNING ****
; - The ISR corrupts the STATUS register, this register can not be used
;   by the main loop anymore.
; - The ISR also requires the PCLATH register to remain 0x00, so this register
;   may not be written by the main loop.
; - Finally the ISR requires that Bank 0 is selected at all times.
; These restrictions are necessary for doubling the PWM frequency.
;*******************************************************************************
   global mainloop

;*******************************************************************************
#include "uart.inc"
    extern uart_rx_flags, uart_rx_byte
    extern uart_tx_flags, uart_tx_byte
    extern pwm_period, pwm_red, pwm_green, pwm_blue
    extern startup
 
;*******************************************************************************
    UDATA
rx_period RES 1
rx_red RES 1
rx_green RES 1
rx_blue RES 1



;*******************************************************************************
receive_byte MACRO onFailure
    local loop
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
    ENDM


;*******************************************************************************
    CODE
mainloop
    call startup

reset_command_loop
    clrf uart_rx_flags

receive_start
;**** period/red most significant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
parse_period
    ; set rx_period to current pwm_period value
    movfw pwm_period
    movwf rx_period
    ; restart if b'00x0xxxx' was not received
    btfsc uart_rx_byte, 4
    goto reset_command_loop
    btfsc uart_rx_byte, 6
    goto reset_command_loop
    btfsc uart_rx_byte, 7
    goto reset_command_loop
    ; parse red value if b'0010xxxx' was received, continue otherwise
    btfsc uart_rx_byte, 5
    goto parse_red
    ; copy rx_period most significant nibble
    swapf uart_rx_byte, W
    andlw h'F0'
    movwf rx_period
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** period least siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
    ; restart if b'0001xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfsc uart_rx_byte, 6
    goto parse_period
    btfsc uart_rx_byte, 5
    goto parse_period
    btfss uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    movfw uart_rx_byte
    andlw h'0F'
    iorwf rx_period, F
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** red most siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
parse_red
    ; restart if b'0010xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfsc uart_rx_byte, 6
    goto parse_period
    btfss uart_rx_byte, 5
    goto parse_period
    btfsc uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    swapf uart_rx_byte, W
    andlw h'F0'
    movwf rx_red
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** red least siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
    ; restart if b'0011xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfsc uart_rx_byte, 6
    goto parse_period
    btfss uart_rx_byte, 5
    goto parse_period
    btfss uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    movfw uart_rx_byte
    andlw h'0F'
    iorwf rx_red, F
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** green most siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
    ; restart if b'0100xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfss uart_rx_byte, 6
    goto parse_period
    btfsc uart_rx_byte, 5
    goto parse_period
    btfsc uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    swapf uart_rx_byte, W
    andlw h'F0'
    movwf rx_green
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** green least siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
    ; restart if b'0101xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfss uart_rx_byte, 6
    goto parse_period
    btfsc uart_rx_byte, 5
    goto parse_period
    btfss uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    movfw uart_rx_byte
    andlw h'0F'
    iorwf rx_green, F
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** blue most siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
    ; restart if b'0110xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfss uart_rx_byte, 6
    goto parse_period
    btfss uart_rx_byte, 5
    goto parse_period
    btfsc uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    swapf uart_rx_byte, W
    andlw h'F0'
    movwf rx_blue
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** blue least siginficant nibble: *****
    ; receive byte from uart, restart on failure
    receive_byte reset_command_loop
    ; restart if b'0111xxxx' was not received
    btfsc uart_rx_byte, 7
    goto parse_period
    btfss uart_rx_byte, 6
    goto parse_period
    btfss uart_rx_byte, 5
    goto parse_period
    btfss uart_rx_byte, 4
    goto parse_period
    ; copy rx_period least significant nibble
    movfw uart_rx_byte
    andlw h'0F'
    iorwf rx_blue, F
    ; clear data flag
    bcf uart_rx_flags, UART_RX_DATA

;**** latch values to pwm_controller ****
    movfw rx_period
    movwf pwm_period
    movfw rx_red
    movwf pwm_red
    movfw rx_green
    movwf pwm_green
    movfw rx_blue
    movwf pwm_blue

    goto receive_start
    return ; never called
    END
