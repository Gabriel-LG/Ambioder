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