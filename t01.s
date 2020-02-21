        .text
        .globl main

print:
        li      $t0, 0                  #x = 0;
        li      $t1, 0                  #y = 0;

        for_y_board_loop:
            bge $t1, $s1, for_y_board_exit      #if ($t1 >= $s1) goto for_y_board_exit;

            li  $t0, 0                          #$t0 = 0
            for_x_bar_loop:         
                bge $t0, $s1, for_x_bar_exit    #if ($t0 >= $s1) goto for_x_bar_exit;

                #print "+-"
                la  $a0, PLUSDASH               #std::cout << "+-";
                li  $v0, 4
                syscall

                #increment x
                addi    $t0, $t0, 1             #++y;
                j       for_x_bar_loop         
            for_x_bar_exit:

            la  $a0, PLUSNLINE                  #std::cout << "+\n";
            li  $v0, 4
            syscall

            li  $t0, 0          #x = 0
            for_x_board_loop:
                bge $t0, $s1, for_x_board_exit
                li  $t3, 0                      #pos = 0
                #create current index
                mul $t3, $s1, $t1               #n * y
                add $t3, $t3, $t0               #pos = n * y + x
                add $t3, $t3, $t3               # 2pos
                add $t3, $t3, $t3               # 4pos
                la  $s0, BOARD                  # $s0 = &BOARD(0)
                add $s0, $s0, $t3               # $s0 = &BOARD[pos]
                
                lw  $t3, 0($s0)                 # $t3 = *BOARD[pos]

                #print '|O' if integer value is 0
                bne $t3, 0, if_print_O_exit
                la  $a0, O
                li  $v0, 4
                syscall
                if_print_O_exit:

                #print '|X' if integer value is 1
                bne $t3, 1, if_print_X_exit
                la  $a0, X
                li  $v0, 4
                syscall
                if_print_X_exit:

                #print '| ' if integer value is -1
                bne $t3, -1, if_print_space_exit
                la  $a0, BARSPACE
                li  $v0, 4
                syscall
                if_print_space_exit:

                addi $t0, $t0, 1 #++x
                j   for_x_board_loop
            for_x_board_exit:

            la  $a0, BARNLINE               #std::cout << "|\n";
            li  $v0, 4
            syscall

            addi $t1, $t1, 1                #++y;
            j   for_y_board_loop
        for_y_board_exit:

        li  $t1, 0
        for_y_bar_loop:
            bge $t1, $s1, for_y_bar_exit    
            la  $a0, PLUSDASH               #std::cout << "+-";
            li  $v0, 4
            syscall

            addi    $t1, $t1, 1             #++y;
            j       for_y_bar_loop
        for_y_bar_exit:

        la  $a0, PLUSNLINE                  #std::cout << "+\n";
        li  $v0, 4
        syscall

        jr      $ra

main:
        la      $a0, PLAY_GAME          #std::cout << PLAY_GAME;
        li      $v0, 4
        syscall

        li      $v0, 5
        syscall
        move    $s1, $v0                #std::cin >> n;

        la      $a0, NEWLINE           #std::cout << '\n';
        li      $v0, 4
        syscall

        mul     $s2, $s1, $s1           # int nsqr = n * n;
        div     $t0, $s1, 2             # n / 2
        mul     $s3, $s1, $t0           # n * (n / 2)
        add     $s3, $s3, $t0           # n * (n / 2) + n / 2

        li      $t9, -1;
        li      $t8,  0;
        li      $t7,  0;
        li      $t6,  0;
        li      $t5,  0;
        li      $t4, -1;
        li      $t3,  0;                
        li      $t1,  0;                # int y = 0;
        li      $t0,  0;                # int x = 0;

        la      $s0, BOARD
        li      $t2, -1
    FOR_INITIALIZE_BOARD_LOOP:
        bge     $t0, $s2, FOR_INITIALIZE_BOARD_EXIT
            sw      $t2, 0($s0)
            addi    $s0, $s0, 4
            addi    $t0, $t0, 1
            j       FOR_INITIALIZE_BOARD_LOOP
    FOR_INITIALIZE_BOARD_EXIT:


WhileLoop:
    bne $t8, 1, ai_turn

        li  $t5, 0
        li  $t1, 0
        for_draw_y_loop_player:
        bge $t1, $s1, for_draw_y_exit_player

            li  $t0, 0
            for_draw_x_loop_player:
                bge $t0, $s1, for_draw_x_exit_player
                mul $t3, $t1, $s1
                add $t3, $t3, $t0   # pos
                add $t3, $t3, $t3   # 2pos
                add $t3, $t3, $t3   # 4pos

                la  $s0, BOARD      #$s0 = &BOARD[0]
                add $s0, $s0, $t3   #$s0 = &BOARD[pos]
                lw  $s4, 0($s0)     #$t3 = *BOARD[pos]

                beq $s4, -1, dont_add_piece_counter
                addi $t5, $t5, 1           # count number of pieces
                dont_add_piece_counter:

                addi    $t0, $t0, 1
                j       for_draw_x_loop_player
            for_draw_x_exit_player:

            addi    $t1, $t1, 1
            j       for_draw_y_loop_player
        for_draw_y_exit_player:

        beq     $t5, $s2, win_state

        la      $a0, ROWPROMPT      #std::cout << "Enter row: ";
        li      $v0, 4
        syscall

        li      $v0, 5
        syscall
        move    $t1, $v0            #std::cin >> y;

        la      $a0, NEWLINE        #std::cout << '\n';
        li      $v0, 4
        syscall

        la      $a0, COLPROMPT      #std::cout << "Enter column: "
        li      $v0, 4
        syscall

        li      $v0, 5
        syscall
        move    $t0, $v0            #std::cin >> x;        

        la      $a0, NEWLINE        #std::cout << '\n';
        li      $v0, 4
        syscall

        mul     $t3, $s1, $t1
        add     $t3, $t3, $t0 #pos
        add     $t3, $t3, $t3 #2pos
        add     $t3, $t3, $t3 #4pos

        la      $s0, BOARD      #$s0 = &BOARD[0]
        add     $s0, $s0, $t3   #$s0 = &BOARD[pos]
        lw      $s4, 0($s0)     #$t3 = *BOARD[pos]

        bne     $s4, -1, if_notspace_player_exit
            li      $t2, 1
            sw      $t2, 0($s0)     #BOARD[pos] = 1
            li      $t8, 0
        if_notspace_player_exit:

        li  $t1, 0
        for_row_y_loop_player:
        bge $t1, $s1, for_row_y_exit_player
            li  $t7, 0

            li  $t0, 0
            for_row_x_loop_player:
            bge $t0, $s1, for_row_x_exit_player
                mul $t3, $t1, $s1
                add $t3, $t3, $t0
                add $t3, $t3, $t3
                add $t3, $t3, $t3   # 4pos

                la      $s0, BOARD
                add     $s0, $s0, $t3
                lw      $s4, 0($s0)

                bne     $s4, 1, if_row_player_piece_exit
                    add     $t7, $t7, 1
                if_row_player_piece_exit:

                bne     $t7, $s1, if_row_wc_exit_player
                    li  $t9, 1
                    j   win_state
                if_row_wc_exit_player:

                addi    $t0, $t0, 1
                j       for_row_x_loop_player
            for_row_x_exit_player:

            addi    $t1, $t1, 1
            j       for_row_y_loop_player
        for_row_y_exit_player:


        move $t0, $s1
        for_col_x_loop_player:
        ble     $t0, 0, for_col_x_exit_player
            li  $t7, 0

            li  $t1, 0
            for_col_y_loop_player:
            bge $t1, $s1, for_col_y_exit_player
                mul     $t3, $t1, $s1
                add     $t3, $t3, $s1
                sub     $t3, $t3, $t0
                add     $t3, $t3, $t3
                add     $t3, $t3, $t3   # 4pos

                la      $s0, BOARD
                add     $s0, $s0, $t3
                lw      $s4, 0($s0)

                bne     $s4, 1, if_col_player_piece_exit
                    addi    $t7, $t7, 1
                if_col_player_piece_exit:

                bne     $t7, $s1, if_col_wc_player_exit
                    li  $t9, 1
                    j   win_state
                if_col_wc_player_exit:

                addi    $t1, $t1, 1
                j       for_col_y_loop_player
            for_col_y_exit_player:

            addi    $t0, $t0, -1
            j       for_col_x_loop_player
        for_col_x_exit_player:

        li  $t7, 0
        li  $t0, 0
        for_ldiag_loop_player:
        bge     $t0, $s1, for_ldiag_exit_player
            addi    $t3, $s1, 1
            mul     $t3, $t3, $t0
            add     $t3, $t3, $t3
            add     $t3, $t3, $t3   # 4pos

            la      $s0, BOARD
            add     $s0, $s0, $t3
            lw      $s4, 0($s0)
            
            bne     $s4, 1, if_ldiag_player_piece_exit
                addi    $t7, $t7, 1
            if_ldiag_player_piece_exit:

            bne     $t7, $s1, if_ldiag_wc_player_exit
                li  $t9, 1
                j   win_state
            if_ldiag_wc_player_exit:

            addi    $t0, $t0, 1
            j       for_ldiag_loop_player
        for_ldiag_exit_player:

        li  $t7, 0
        li  $t0, 1
        for_rdiag_loop_player:
        bge     $t0, $s1, for_rdiag_exit_player
            addi    $t3, $s1, -1
            mul     $t3, $t3, $t0
            add     $t3, $t3, $t3
            add     $t3, $t3, $t3   # 4pos

            la      $s0, BOARD
            add     $s0, $s0, $t3
            lw      $s4, 0($s0)
            
            bne     $s4, 1, if_rdiag_player_piece_exit
                addi    $t7, $t7, 1
            if_rdiag_player_piece_exit:

            bne     $t7, $s1, if_rdiag_wc_player_exit
                li  $t9, 1
                j   win_state
            if_rdiag_wc_player_exit:

            addi    $t0, $t0, 1
            j       for_rdiag_loop_player
        for_rdiag_exit_player:

        j   WhileLoop

    ai_turn:
        ################################################################
        # Row Computation
        ################################################################
        li  $t1, 0
        for_row_y_loop_ai:
            bge $t1, $s1, for_row_y_exit_ai

            
            li  $t7, 0
            li  $t6, 0
            li  $t4, -1
            li  $t3, 0
            li  $t2, 0

            li  $t0, 0
            for_row_x_loop_ai:
                bge     $t0, $s1, for_row_x_exit_ai

                mul     $t3, $t1, $s1
                add     $t3, $t3, $t0
                add     $t3, $t3, $t3
                add     $t3, $t3, $t3   # 4pos

                la      $s0, BOARD
                add     $s0, $s0, $t3
                lw      $s4, 0($s0)
        

                bne     $s4, -1, if_row_ai_space_exit
                    move    $t4, $t3
                if_row_ai_space_exit:


                
                bne     $s4, 0, if_row_ai_piece_exit
                    addi    $t7, $t7, 1  
                if_row_ai_piece_exit:

                bne     $s4, 1, if_row_ai_enemy_exit
                    addi    $t6, $t6, 1
                if_row_ai_enemy_exit:

                bne     $t7, $s1, if_row_wc_exit
                    li  $t9, 0
                    j   win_state
                if_row_wc_exit:

                bne     $t6, $s1, if_row_ewc_exit
                    li  $t9, 1
                    j   win_state
                if_row_ewc_exit:

                addi    $t2, $s1, -1
                bne     $t7, $t2, if_row_wc_and_pob_exit
                beq     $t4, -1,  if_row_wc_and_pob_exit
                    la  $s0, BOARD
                    add $s0, $s0, $t4
                    li  $t2, 0
                    sw  $t2, 0($s0)
                    li  $t9, 0
                    jal     print
                    j   win_state
                if_row_wc_and_pob_exit:

                addi    $t2, $s1, -1
                bne     $t6, $t2, if_row_ewc_and_pob_exit
                beq     $t4, -1,  if_row_ewc_and_pob_exit
                    la  $s0, BOARD
                    add $s0, $s0, $t4
                    li  $t2, 0
                    sw  $t2, 0($s0)
                    li  $t8, 1
                    jal print
                    j   WhileLoop
                if_row_ewc_and_pob_exit:

                addi    $t0, $t0, 1
                j   for_row_x_loop_ai
            for_row_x_exit_ai:

            addi    $t1, $t1, 1
            j   for_row_y_loop_ai
        for_row_y_exit_ai:
        
        ###############################################################
        # Column Computation
        ###############################################################
        move $t0, $s1
        for_col_x_loop_ai:
            ble $t0, 0, for_col_x_exit_ai
            li  $t7, 0
            li  $t6, 0
            li  $t4, -1

            li  $t0, 0
            for_col_y_loop_ai:
                bge     $t1, $s1, for_col_y_exit_ai
                mul     $t3, $t1, $s1
                sub     $t2, $s1, $t0
                add     $t3, $t3, $t2

                add     $t3, $t3, $t3
                add     $t3, $t3, $t3   # 4pos

                la      $s0, BOARD
                add     $s0, $s0, $t3
                lw      $s4, 0($s0)

                bne     $s4, 0, if_col_ai_piece_exit
                    addi    $t7, $t7, 1
                if_col_ai_piece_exit:

                bne     $s4, -1, if_col_ai_space_exit
                    move    $t4, $t3
                if_col_ai_space_exit:

                bne     $s4, 1, if_col_ai_enemy_exit
                    addi    $t6, $t6, 1
                if_col_ai_enemy_exit:

                bne     $t6, $s1, if_col_ewc_exit
                    li  $t9, 1
                    j   win_state
                if_col_ewc_exit:

                bne     $t7, $s1, if_col_wc_exit
                    li  $t9, 0
                    j   win_state
                if_col_wc_exit:

                addi    $t2, $s1, -1
                bne     $t7, $t2, if_col_wc_and_pob_exit
                beq     $t4, -1,  if_col_wc_and_pob_exit
                    la  $s0, BOARD
                    add $s0, $s0, $t4
                    li  $t2, 0
                    sw  $t2, 0($s0)
                    li  $t9, 0
                    j   win_state
                if_col_wc_and_pob_exit:

                addi    $t2, $s1, -1
                bne     $t6, $t2, if_col_ewc_and_pob_exit
                beq     $t4, -1,  if_col_ewc_and_pob_exit
                    la  $s0, BOARD
                    add $s0, $s0, $t4
                    li  $t2, 0
                    sw  $t2, 0($s0)
                    li  $t8, 1
                    jal print
                    j   WhileLoop
                if_col_ewc_and_pob_exit:

                addi    $t1, $t1, 1
                j   for_col_y_loop_ai
            for_col_y_exit_ai:

            addi    $t0, $t0, -1
            j   for_col_x_loop_ai
        for_col_x_exit_ai:

        ###############################################################
        # Left Diagonal Computation
        ###############################################################
        li  $t7, 0
        li  $t6, 0
        li  $t4, -1

        li  $t0, 0
        for_ldiag_loop_ai:
            bge     $t0, $s1, for_ldiag_exit_ai
            addi    $t3, $s1, 1
            mul     $t3, $t3, $t0
            add     $t3, $t3, $t3
            add     $t3, $t3, $t3   # 4pos

            la      $s0, BOARD
            add     $s0, $s0, $t3
            lw      $s4, 0($s0)

            bne     $s4, 0, if_ldiag_ai_piece_exit
                addi    $t7, $t7, 1
            if_ldiag_ai_piece_exit:

            bne     $s4, -1, if_ldiag_ai_space_exit
                move    $t4, $t3
            if_ldiag_ai_space_exit:

            bne     $s4, 1, if_ldiag_ai_enemy_exit
                addi    $t6, $t6, 1
            if_ldiag_ai_enemy_exit:

            bne     $t6, $s1, if_ldiag_ai_ewc_exit
                li  $t9, 1
                j   win_state
            if_ldiag_ai_ewc_exit:

            bne     $t7, $s1, if_ldiag_ai_wc_exit
                li  $t9, 0
                j   win_state
            if_ldiag_ai_wc_exit:

            addi    $t2, $s1, -1
            bne     $t7, $t2, if_ldiag_ai_wc_and_pob_exit
            beq     $t4, -1,  if_ldiag_ai_wc_and_pob_exit
                la  $s0, BOARD
                add $s0, $s0, $t4
                li  $t2, 0
                sw  $t2, 0($s0)
                li  $t9, 0
                j   win_state
            if_ldiag_ai_wc_and_pob_exit:

            addi    $t2, $s1, -1
            bne     $t6, $t2, if_ldiag_ai_ewc_and_pob_exit
            beq     $t4, -1,  if_ldiag_ai_ewc_and_pob_exit
                la  $s0, BOARD
                add $s0, $s0, $t4
                li  $t2, 0
                sw  $t2, 0($s0)
                li  $t8, 1
            jal print
            j   WhileLoop
        if_ldiag_ai_ewc_and_pob_exit:

            addi    $t0, $t0, 1
            j   for_ldiag_loop_ai
        for_ldiag_exit_ai:

        ###############################################################
        # Right Diagonal Computation
        ###############################################################
        li  $t7, 0
        li  $t6, 0
        li  $t4, -1

        li  $t0, 1
        for_rdiag_loop_ai:
            bgt     $t0, $s1, for_rdiag_exit_ai
            addi    $t3, $s1, -1
            mul     $t3, $t3, $t0
            add     $t3, $t3, $t3
            add     $t3, $t3, $t3   # 4pos

            la      $s0, BOARD
            add     $s0, $s0, $t3
            lw      $s4, 0($s0)

            bne     $s4, 0, if_rdiag_ai_piece_exit
                addi    $t7, $t7, 1
            if_rdiag_ai_piece_exit:

            bne     $s4, -1, if_rdiag_ai_space_exit
                move    $t4, $t3
            if_rdiag_ai_space_exit:

            bne     $s4, 1, if_rdiag_ai_enemy_exit
                addi    $t6, $t6, 1
            if_rdiag_ai_enemy_exit:

            bne     $t6, $s1, if_rdiag_ai_ewc_exit
                li  $t9, 1
                j   win_state
            if_rdiag_ai_ewc_exit:

            bne     $t7, $s1, if_rdiag_ai_wc_exit
                li  $t9, 0
                j   win_state
            if_rdiag_ai_wc_exit:

            addi    $t2, $s1, -1
            bne     $t7, $t2, if_rdiag_ai_wc_and_pob_exit
            beq     $t4, -1,  if_rdiag_ai_wc_and_pob_exit
                la  $s0, BOARD
                add $s0, $s0, $t4
                li  $t2, 0
                sw  $t2, 0($s0)
                li  $t9, 0
                j   win_state
            if_rdiag_ai_wc_and_pob_exit:

            addi    $t2, $s1, -1
            bne     $t6, $t2, if_rdiag_ai_ewc_and_pob_exit
            beq     $t4, -1,  if_rdiag_ai_ewc_and_pob_exit
                la  $s0, BOARD
                add $s0, $s0, $t4
                li  $t2, 0
                sw  $t2, 0($s0)
                li  $t8, 1
            jal print
            j   WhileLoop
        if_rdiag_ai_ewc_and_pob_exit:

        addi    $t0, $t0, 1
        j   for_rdiag_loop_ai
    for_rdiag_exit_ai:

        ###############################################################
        # Maker General Move
        ###############################################################
        add     $t3, $s3, $s3
        add     $t3, $t3, $t3

        la      $s0, BOARD
        add     $s0, $s0, $t3
        lw      $s4, 0($s0)

        bne     $s4, -1, if_ai_move_exit
            la      $a0, FIRSTMOVE
            li      $v0, 4
            syscall

            li      $t2, 0
            sw      $t2, 0($s0)
            li      $t8, 1
            jal     print
            j       WhileLoop
        if_ai_move_exit:

        li      $t5, 0
        li      $t0, 0
        for_space_x_loop_ai:
            bge     $t0, $s1, for_space_x_exit_ai
            li  $t1, 0
            for_space_y_loop_ai:
                bge $t1, $s1, for_space_y_exit_ai
                    mul $t3, $s1, $t1
                    add $t3, $t3, $t0
                    add $t3, $t3, $t3
                    add $t3, $t3, $t3

                    la      $s0, BOARD
                    add     $s0, $s0, $t3
                    lw      $s4, 0($s0)

                    bne     $s4, -1, if_space_ai_exit
                        li  $t2, 0
                        sw  $t2, 0($s0)
                        li  $t8, 1
                        jal print
                        j   WhileLoop
                    if_space_ai_exit:

                    addi    $t5, $t5, 1
                    addi    $t1, $t1, 1
                    j   for_space_y_loop_ai
                for_space_y_exit_ai:

                addi    $t0, $t0, 1
                j   for_space_x_loop_ai
            for_space_x_exit_ai:

            beq $t5, $s2, win_state

win_state:
        jal     print

        bne     $t9, 0, ws_1
        la      $a0, WINNERME
        li      $v0, 4
        syscall
        j   end
        ws_1:

        bne     $t9, 1, ws_2
        la      $a0, WINNERYOU
        li      $v0, 4
        syscall
        j   end
        ws_2:

        la      $a0, WINNERNONE
        li      $v0, 4
        syscall
test:
        move    $a0, $t0
        li      $v0, 1


end:
        li      $v0, 10                 #terminate program
        syscall    

        .data
BOARD:      .word   0
PLAY_GAME:  .asciiz "Let's play a game of tic-tac-toe.\nEnter n: "
ROWPROMPT:  .asciiz "Enter row: "
COLPROMPT:  .asciiz "Enter column: "
FIRSTMOVE:  .asciiz "I'll go first\n"
PLUSDASH:   .asciiz "+-"
PLUSNLINE:  .asciiz "+\n"
BARSPACE:   .asciiz "| "
BARNLINE:   .asciiz "|\n"
X:          .asciiz "|X"
O:          .asciiz "|O"
NEWLINE:    .asciiz "\n"
WINNERME:   .asciiz "I'm the winner!\n"
WINNERYOU:  .asciiz "You are the winner!\n"
WINNERNONE: .asciiz "We have a draw!\n"
space:      .asciiz " "