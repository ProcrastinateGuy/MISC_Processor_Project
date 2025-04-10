onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/MEM_DATA
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_DATA_W
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_ADDR_W
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_READ
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_WRITE
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/MEM_ADDR
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/MEM_READ
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/MEM_WRITE
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/ZERO
add wave -noupdate -color Magenta -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/mem_read_reg
add wave -noupdate -color Magenta -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/mem_write_reg
add wave -noupdate -color Magenta -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/mem_addr_reg
add wave -noupdate -color Magenta -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/mem_data_in_cu_reg
add wave -noupdate -color Magenta -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/mem_data_cu_out_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RST
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/CLK
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/ir_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/proc_state
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_read_reg
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_write_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_ADDR_R1
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_address_1
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_ADDR_R2
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_address_2
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/data_1_out
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_DATA_R1
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_data_in_1
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/data_2_out
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/RF_DATA_R2
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_data_in_2
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/ALU_RESULT
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/alu_result
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/ALU_OP1
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/alu_op1_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/ALU_OP2
add wave -noupdate -color Yellow -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/alu_op2_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/ALU_OPRN
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/alu_oprn_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_w_data
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/rf_w_address
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/pc_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/cu_inst/sp_reg
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/READ
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/WRITE
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/CLK
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/RST
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/DATA_W
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/ADDR_R1
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/ADDR_R2
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/ADDR_W
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/DATA_R1
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/DATA_R2
add wave -noupdate -radix hexadecimal /DA_VINCI_TB/da_vinci_inst/processor_inst/rf_inst/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 394
configure wave -valuecolwidth 72
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
WaveRestoreZoom {0 ps} {196630 ps}
