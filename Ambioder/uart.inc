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
; the flags for uart_rx_state
;*******************************************************************************
UART_RX_DATA equ 0
UART_RX_ERROR equ 1
UART_RX_OVERFLOW equ 2

;*******************************************************************************
; the flags for uart_tx_state
;*******************************************************************************
UART_TX_READY equ 0


uart_rx_sample MACRO
    extern rx_start_0, rx_start_1, rx_start_2
    extern rx_data_0, rx_data_1, rx_data_2
    extern rx_stop_0, rx_stop_1 
    extern rx_stop_1_overflow, rx_error
    extern rx_jump

    ;movlw HIGH($) ;assuming PCLATH is always 0
    ;movwf PCLATH  ;assuming PCLATH is always 0
    movfw rx_jump
    ;jump
    addwf PCL, F
uart_rx_jumptable_entry_0
    ;start bit
    goto rx_start_0                                                ;rx_jump == 0
    goto rx_start_1                                                ;rx_jump == 1
    goto rx_start_2                                                ;rx_jump == 2
    ;bit 0
    goto rx_data_0                                                 ;rx_jump == 3
    goto rx_data_1                                                 ;rx_jump == 4
    goto rx_data_2                                                 ;rx_jump == 5
    ;bit 1
    goto rx_data_0                                                 ;rx_jump == 6
    goto rx_data_1                                                 ;rx_jump == 7
    goto rx_data_2                                                 ;rx_jump == 8
    ;bit 2
    goto rx_data_0                                                 ;rx_jump == 9
    goto rx_data_1                                                ;rx_jump == 10
    goto rx_data_2                                                ;rx_jump == 11
    ;bit 3
    goto rx_data_0                                                ;rx_jump == 12
    goto rx_data_1                                                ;rx_jump == 13
    goto rx_data_2                                                ;rx_jump == 14
    ;bit 4
    goto rx_data_0                                                ;rx_jump == 15
    goto rx_data_1                                                ;rx_jump == 16
    goto rx_data_2                                                ;rx_jump == 17
    ;bit 5
    goto rx_data_0                                                ;rx_jump == 18
    goto rx_data_1                                                ;rx_jump == 19
    goto rx_data_2                                                ;rx_jump == 20
    ;bit 6
    goto rx_data_0                                                ;rx_jump == 21
    goto rx_data_1                                                ;rx_jump == 22
    goto rx_data_2                                                ;rx_jump == 23
    ;bit 7
    goto rx_data_0                                                ;rx_jump == 24
    goto rx_data_1                                                ;rx_jump == 25
    goto rx_data_2                                                ;rx_jump == 26
    ;stop bit
    goto rx_stop_0                                                ;rx_jump == 27
    goto rx_stop_1                                                ;rx_jump == 28
    ;stop bit on overflow
    goto rx_stop_1_overflow                                       ;rx_jump == 29
    ;error
    goto rx_error                                                 ;rx_jump == 30

    ENDM