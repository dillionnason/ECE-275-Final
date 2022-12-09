onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /testball/ball_mod/clk
add wave -noupdate -color Gold /testball/ball_mod/reset
add wave -noupdate -color Gold /testball/ball_mod/score_right
add wave -noupdate -color Gold /testball/ball_mod/score_left
add wave -noupdate -color Gold /testball/ball_mod/left_collision
add wave -noupdate -color Gold /testball/ball_mod/right_collision
add wave -noupdate -color Gold /testball/ball_mod/paddle_collision
add wave -noupdate -radix decimal /testball/ball_mod/pos_x
add wave -noupdate -radix decimal /testball/ball_mod/pos_y
add wave -noupdate -radix decimal /testball/ball_mod/v_x
add wave -noupdate -radix decimal /testball/ball_mod/v_y
add wave -noupdate -radix decimal /testball/ball_mod/next_pos_x
add wave -noupdate -radix unsigned /testball/ball_mod/next_pos_y
add wave -noupdate -radix decimal /testball/ball_mod/next_v_x
add wave -noupdate -radix decimal /testball/ball_mod/next_v_y
add wave -noupdate -color Turquoise -radix decimal /testball/ball_mod/left_paddle_y
add wave -noupdate -color Turquoise -radix decimal -childformat {{{/testball/ball_mod/right_paddle_y[9]} -radix decimal} {{/testball/ball_mod/right_paddle_y[8]} -radix decimal} {{/testball/ball_mod/right_paddle_y[7]} -radix decimal} {{/testball/ball_mod/right_paddle_y[6]} -radix decimal} {{/testball/ball_mod/right_paddle_y[5]} -radix decimal} {{/testball/ball_mod/right_paddle_y[4]} -radix decimal} {{/testball/ball_mod/right_paddle_y[3]} -radix decimal} {{/testball/ball_mod/right_paddle_y[2]} -radix decimal} {{/testball/ball_mod/right_paddle_y[1]} -radix decimal} {{/testball/ball_mod/right_paddle_y[0]} -radix decimal}} -subitemconfig {{/testball/ball_mod/right_paddle_y[9]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[8]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[7]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[6]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[5]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[4]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[3]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[2]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[1]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_y[0]} {-color Turquoise -height 16 -radix decimal}} /testball/ball_mod/right_paddle_y
add wave -noupdate -color Turquoise -radix unsigned -childformat {{{/testball/ball_mod/left_paddle_pos_unsigned[10]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[9]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[8]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[7]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[6]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[5]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[4]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[3]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[2]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[1]} -radix unsigned} {{/testball/ball_mod/left_paddle_pos_unsigned[0]} -radix unsigned}} -subitemconfig {{/testball/ball_mod/left_paddle_pos_unsigned[10]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[9]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[8]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[7]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[6]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[5]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[4]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[3]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[2]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[1]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/left_paddle_pos_unsigned[0]} {-color Turquoise -height 16 -radix unsigned}} /testball/ball_mod/left_paddle_pos_unsigned
add wave -noupdate -color Turquoise -radix unsigned -childformat {{{/testball/ball_mod/right_paddle_pos_unsigned[10]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[9]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[8]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[7]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[6]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[5]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[4]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[3]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[2]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[1]} -radix unsigned} {{/testball/ball_mod/right_paddle_pos_unsigned[0]} -radix unsigned}} -subitemconfig {{/testball/ball_mod/right_paddle_pos_unsigned[10]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[9]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[8]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[7]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[6]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[5]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[4]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[3]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[2]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[1]} {-color Turquoise -height 16 -radix unsigned} {/testball/ball_mod/right_paddle_pos_unsigned[0]} {-color Turquoise -height 16 -radix unsigned}} /testball/ball_mod/right_paddle_pos_unsigned
add wave -noupdate -color Turquoise -radix decimal /testball/ball_mod/left_paddle_pos
add wave -noupdate -color Turquoise -radix decimal -childformat {{{/testball/ball_mod/right_paddle_pos[10]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[9]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[8]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[7]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[6]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[5]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[4]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[3]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[2]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[1]} -radix decimal} {{/testball/ball_mod/right_paddle_pos[0]} -radix decimal}} -subitemconfig {{/testball/ball_mod/right_paddle_pos[10]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[9]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[8]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[7]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[6]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[5]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[4]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[3]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[2]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[1]} {-color Turquoise -height 16 -radix decimal} {/testball/ball_mod/right_paddle_pos[0]} {-color Turquoise -height 16 -radix decimal}} /testball/ball_mod/right_paddle_pos
add wave -noupdate -color Coral /testball/ball_mod/BALL_SIZE
add wave -noupdate -color Coral /testball/ball_mod/RIGHT_BOUNDARY
add wave -noupdate -color Coral /testball/ball_mod/LEFT_BOUNDARY
add wave -noupdate -color Coral /testball/ball_mod/TOP_BOUNDARY
add wave -noupdate -color Coral /testball/ball_mod/BOTTOM_BOUNDARY
add wave -noupdate -color Coral /testball/ball_mod/PADDLE_HEIGHT
add wave -noupdate -color Coral /testball/ball_mod/PADDLE_WIDTH
add wave -noupdate -color Coral /testball/ball_mod/PLAYER_PADDLE_X
add wave -noupdate -color Coral /testball/ball_mod/AI_PADDLE_X
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {64167499 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 334
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {360519 ps}
