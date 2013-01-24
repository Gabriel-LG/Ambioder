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
; Receive bytes over UART (8 databits, no flow control, 1 stop bit).
; * Call uart_tx_init to initialize.
; * Call  uart_tx_tick at frequency of baudrate*3
; * uart_tx_flags indicates the uart tx status. These flags are set by this
;   this module, and cleared by the user.
;   and cleared by this module.
;   - UART_TX_READY indicates uart_tx_byte can be written. Clear this flag after
;     writing uart_tx_byte, to transmit the byte.
; * uart_tx_byte becomes undefined after clearing UART_TX_READY.
;*******************************************************************************
    global uart_tx_flags, uart_tx_byte
    global uart_tx_init
    global uart_tx_tick

;*******************************************************************************
; Implementation
;*******************************************************************************
#include <p16f684.inc>
#include "uart.inc"
#include "iolatch.inc"
    extern io_buffer

;*******************************************************************************
uart_tx_global_data UDATA_SHR
uart_tx_flags RES 1
uart_tx_byte RES 1

uart_tx_local_data UDATA
tx_jump RES 1

;*******************************************************************************
    CODE
uart_tx_init
    clrf tx_jump
    clrf uart_tx_flags
    bsf uart_tx_flags, UART_TX_READY
    return

;*******************************************************************************
tx_idle
    ; clear output
    bcf io_buffer, IO_TX
    ; do nothing while UART_TX_READY is set
    btfsc uart_tx_flags, UART_TX_READY
    return
    ; increase jumptable entry
    incf tx_jump, F
    ; set start bit
    bsf io_buffer, IO_TX
    return
tx_start
    ; increase jumptable entry
    incf tx_jump, F
    ; set start bit
    bsf io_buffer, IO_TX
    return
tx_edge
    ; increase jumptable entry
    incf tx_jump, F
    ; shift out 1 bit; high on 0 and low on 1
    bsf io_buffer, IO_TX
    btfsc uart_tx_byte, 0
    bcf io_buffer, IO_TX
    rrf uart_tx_byte, F
    return
tx_level
    ; increase jumptable entry
    incf tx_jump, F
    ; set output; high on 0 and low on 1
    bsf io_buffer, IO_TX
    btfsc uart_tx_byte, 0
    bcf io_buffer, IO_TX
    return
tx_stop
    ; increase jumptable entry
    incf tx_jump, F
    ; set stop bit
    bcf io_buffer, IO_TX
    return
tx_done
    ; set jumptable entry to idle
    clrf tx_jump
    ; set stop bit
    bcf io_buffer, IO_TX
    ; set UART_TX_READY flag
    bsf uart_tx_flags, UART_TX_READY
    return

;*******************************************************************************
uart_tx_jumptable CODE 0x780
uart_tx_tick
    movlw HIGH($)
    movwf PCLATH
    movfw tx_jump
    addwf PCL, F
    ;uart tx_jump table
    ;start bit
    goto tx_idle
    goto tx_start
    goto tx_start
    ;bit 0
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 1
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 2
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 3
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 4
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 5
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 6
    goto tx_level
    goto tx_level
    goto tx_edge
    ;bit 7
    goto tx_level
    goto tx_level
    goto tx_level
    ;stop bit
    goto tx_stop
    goto tx_stop
    goto tx_done

    END