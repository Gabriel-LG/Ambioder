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
; * Call uart_rx_init to initialize.
; * Call  uart_rx_tick at frequency of baudrate*3
; * uart_rx_flags indicates the uart rx status. These flags are set by this
;   this module, and cleared by the user.
;   - UART_RX_DATA indicates uart_rx_byte contains valid data. This flag must
;     be cleared after processing the byte.
;   - UART_RX_ERROR indicates an error on the RX line. No bytes will be received
;     until this flag is cleared.
;   - UART_RX_OVERFLOW inidcates a byte was received and lost because the
;     previous byte was not yet processed.
; * uart_rx_byte contains the last received byte if UART_RX_DATA is set.
;*******************************************************************************
    global uart_rx_flags, uart_rx_byte
    global uart_rx_init
    ;only for access by uart_rx_sample macro:
    global rx_start_0, rx_start_1, rx_start_2
    global rx_data_0, rx_data_1, rx_data_2
    global rx_stop_0, rx_stop_1
    global rx_stop_1_overflow, rx_error
    global rx_jump


;*******************************************************************************
; Implementation
;*******************************************************************************
#include <P16F684.INC>
#include "uart.inc"
#include "iolatch.inc"
#include "isr.inc"
    extern io_buffer

;*******************************************************************************
uart_rx_global_data UDATA_SHR
uart_rx_flags RES 1
uart_rx_byte RES 1

uart_rx_local_data UDATA
rx_jump RES 1
rx_buf RES 1

;*******************************************************************************
    CODE
uart_rx_init
    clrf rx_jump
    clrf uart_rx_flags
    clrf PCLATH
    return

;*******************************************************************************
rx_start_0
    btfsc io_buffer, IO_RX
    incf rx_jump, F
    isr_exit

rx_start_1
    btfss io_buffer, IO_RX
    goto rx_enter_error
    incf rx_jump, F
    isr_exit

rx_start_2
    incf rx_jump, F
    isr_exit

rx_data_0
    incf rx_jump, F
    rrf rx_buf, F
    bcf rx_buf, 7
    isr_exit

rx_data_1
    incf rx_jump, F
    btfss io_buffer, IO_RX ;set bit if pin is set
    bsf rx_buf, 7
    isr_exit

rx_data_2
    incf rx_jump, F
    isr_exit

rx_stop_0
    btfsc uart_rx_flags, UART_RX_DATA
    goto rx_enter_overflow
    incf rx_jump, F
    isr_exit

rx_stop_1
    btfsc io_buffer, IO_RX
    goto rx_enter_error
    clrf rx_jump
    movf rx_buf, W
    movwf uart_rx_byte
    bsf uart_rx_flags, UART_RX_DATA
    isr_exit

rx_stop_1_overflow
    btfsc io_buffer, IO_RX
    goto rx_enter_error
    clrf rx_jump
    isr_exit

rx_error
    btfss uart_rx_flags, UART_RX_ERROR
    clrf rx_jump
    isr_exit

; enter alternative flow: error
rx_enter_error
    bsf uart_rx_flags, UART_RX_ERROR
    movlw d'30' ;see uart_rx_sample macro
    movwf rx_jump
    isr_exit

; enter alternative flow: overflow
rx_enter_overflow
    bsf uart_rx_flags, UART_RX_OVERFLOW
    movlw d'29' ;see uart_rx_sample macro
    movwf rx_jump
    isr_exit

    END
