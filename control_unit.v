// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register fileir_reg[25:0] RF_ADDR_W
//         RF_ADDR_W  : Register fileir_reg[25:0] of the memory location to be written
//         RF_ADDR_R1 : Register fileir_reg[25:0] of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere fileir_reg[25:0] of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memoryir_reg[25:0] to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1ir_reg[25:0]
//         RF_DATA_R2 : Data at ADDR_R1ir_reg[25:0]
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Verion	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014    Kaushik Patra   kpatra@sjsu.edu     Added ZERO status output
//--------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
    		    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
    		    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

// Input signals
input [31:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
inout [31:0] MEM_DATA;

// State nets
wire [2:0] proc_state;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

//regs driveir_reg[25:21]

reg mem_read_reg, mem_write_reg, rf_write_reg, rf_read_reg, zero_reg;
reg [5:0] 	alu_oprn_reg;
reg [31:0] 	mem_addr_reg, mem_data_in_cu_reg, mem_data_cu_out_reg,  
			alu_op1_reg, alu_op2_reg, 
			rf_w_data;
			
reg [4:0] 	rf_w_address, rf_address_1, rf_address_2;

//regs non-driver
reg [31:0] 	pc_reg, sp_reg, ir_reg, rf_data_in_1, rf_data_in_2, alu_result;
reg [31:0] 	sign_extd_reg;
reg [31:0] 	zero_extd_reg;
reg [31:0] 	lui_reg;
reg [31:0] 	j_direct_addr_reg;

//output buffering
//memory related
assign MEM_READ = mem_read_reg;
assign MEM_WRITE = mem_write_reg;
assign MEM_ADDR = mem_addr_reg;

//ALU related
assign ALU_OPRN = alu_oprn_reg;
assign ALU_OP1 = alu_op1_reg;
assign ALU_OP2 = alu_op2_reg;


//register File related
assign RF_READ = rf_read_reg;
assign RF_WRITE = rf_write_reg;
assign RF_DATA_W = rf_w_data;
assign RF_ADDR_W = rf_w_address;
assign RF_ADDR_R1 = rf_address_1;
assign RF_ADDR_R2 = rf_address_2;


// detach when in read mode
always @(*) begin
    if (mem_read_reg == 1'h1 && mem_write_reg == 1'h0) begin
        mem_data_cu_out_reg = {`DATA_WIDTH{1'hz}}; //read mode
    end
end
assign MEM_DATA = mem_data_cu_out_reg; //always drive the mem_data unless read



task display_inst; begin
	
	case(proc_state)
	`PROC_FETCH: //begin
		$displayh("now in state IF");
	`PROC_DECODE: //begin
		$displayh("now in state ID/RF");
	`PROC_EXE: //begin
		$displayh("now in state EXE");
	`PROC_MEM: //begin
		$displayh("now in state MEM");
	`PROC_WB:
		$displayh("now in state WB");
	endcase
	
	$displayh("Instruction: ", ir_reg);
	$display("-------------------");
end
endtask

always @(posedge CLK or negedge RST) begin 
	if (!RST) begin
    		pc_reg <= `INST_START_ADDR;
    		sp_reg <= `INIT_STACK_POINTER;
  	end
end

always @ (proc_state) begin

case (proc_state) 

`PROC_FETCH: begin //same for every instruction
	display_inst;
	
	mem_read_reg = 1'h1; mem_write_reg = 1'h0;
	
	mem_addr_reg = pc_reg;
	
	rf_read_reg = 1'h0; rf_write_reg = 1'h0;
	display_inst;
end

`PROC_DECODE: begin //distribute the value to the reg that might be needed
	//same for every instruction
	
	ir_reg = MEM_DATA; //load instruction
	display_inst;
	zero_extd_reg = {16'h0, ir_reg[15:0]};
	sign_extd_reg = (ir_reg[15] == 1'h1) ? {16'hFFFF, ir_reg[15:0]} : {16'h000, ir_reg[15:0]};
	lui_reg = {ir_reg[15:0], 16'h0};
	
	j_direct_addr_reg = {6'b0,ir_reg[25:0]};
	
	rf_address_1 = ir_reg[25:21];
	rf_address_2 = ir_reg[20:16];
	rf_read_reg = 1'h1;
end
`PROC_EXE: begin 
	display_inst;

end
`PROC_MEM: begin
	display_inst;
	mem_read_reg = 1'h0;
	mem_write_reg = 1'h0;

end
`PROC_WB: begin
	display_inst;
	pc_reg = pc_reg + 1; //update pc
	rf_read_reg = 1'h0; rf_write_reg = 1'h0;
	mem_read_reg = 1'h0; mem_write_reg = 1'h0;
	
end
endcase //end case for general tasks

//individual assignments
case (ir_reg[31:26])
	6'h0 : begin //R-Type 
	case(proc_state)
		`PROC_EXE: begin
		display_inst;
		if(ir_reg[5:0] == 6'h08) begin
				pc_reg = RF_DATA_R1; 
		end else
		
		//shift
		if(ir_reg[5:0] == 6'h1 || ir_reg[5:0] == 6'h2) begin
				alu_oprn_reg = ir_reg[5:0];
				alu_op1_reg = RF_DATA_R1;
				alu_op2_reg = ir_reg[10:6];
		end else 
		//typical R-type
		begin
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = RF_DATA_R2;
			alu_oprn_reg = ir_reg[5:0];
				
		end //end if
		end //endthis state
	
		`PROC_MEM: begin
			display_inst;
			//nothing
		end

		`PROC_WB: begin
			display_inst;
		if(ir_reg[5:0] == 6'h08)
				pc_reg = RF_DATA_R1;
		else begin
				rf_w_address = ir_reg[15:11];
				rf_w_data = ALU_RESULT; 
				rf_write_reg = 1'h1;
		end//end if
		end //end this state
	endcase //endcase for this instruction	
	end //end this instruction
		
	
	//I-type
	6'h08: begin //R[rt] <= R[rs] + SignExtImm //works 
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_oprn_reg = `ALU_OPRN_WIDTH'h20;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = sign_extd_reg;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = ALU_RESULT;
			rf_write_reg = 1'h1;
		end //end this state
	
	endcase //endcase for this instruction
	end //end this instruction
		
	
	
	6'h0C: begin //Logical AND immediate andi I R[rt] <= R[rs] & ZeroExtImm 
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_oprn_reg = `ALU_OPRN_WIDTH'h24;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = zero_extd_reg;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = ALU_RESULT;
			rf_write_reg = 1'h1;
		end //end this state
	
	endcase //endcase for this instruction
	end //end this instruction
		
	
	6'h0D: begin //Logical OR immediate ori I R[rt] <= R[rs] | ZeroExtImm   
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = zero_extd_reg;
			alu_oprn_reg = `ALU_OPRN_WIDTH'h25;	
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
			
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = ALU_RESULT;
			rf_write_reg = 1'h1;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
		
		
	
	6'h1D: begin //R[rt] <= R[rs] * SignExtImm  
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_oprn_reg =`ALU_OPRN_WIDTH'h2c;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = sign_extd_reg;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = ALU_RESULT;
			rf_write_reg = 1'h1;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
		
	
	6'h0A: begin //Set less than immediate slti I R[rt] <= (R[rs] < SignExtImm)?1:0 
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = sign_extd_reg;
			alu_oprn_reg = `ALU_OPRN_WIDTH'h2a;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = ALU_RESULT;
			rf_write_reg = 1'h1;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
		
		
	
	6'h23: begin //Load word lw I R[rt] <= M[R[rs]+SignExtImm] 
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_oprn_reg = `ALU_OPRN_WIDTH'h20;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = sign_extd_reg;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			mem_addr_reg = ALU_RESULT;
			mem_read_reg = 1'h1;
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = MEM_DATA;
			rf_write_reg = 1'h1;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
		
	
	6'h2B: begin //Store word sw I M[R[rs]+SignExtImm] <= R[rt] //works 
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			alu_oprn_reg =`ALU_OPRN_WIDTH'h20;
			alu_op1_reg = RF_DATA_R1;
			alu_op2_reg = sign_extd_reg;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			mem_addr_reg = ALU_RESULT;
			mem_data_cu_out_reg = RF_DATA_R2;
			mem_write_reg = 1'h1;
		end //end this state

		`PROC_WB: begin
			display_inst;
			//nothing
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
		
	

	6'h1B: begin //push //works
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			rf_address_1 = 0;
		end //end this state

		`PROC_MEM: begin
			display_inst;
			mem_addr_reg = sp_reg;
			mem_data_cu_out_reg = RF_DATA_R1;
			mem_write_reg = 1'h1;
			sp_reg = sp_reg - 1;
		end //end this state

		`PROC_WB: begin
			display_inst;
		
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
	6'h1C: begin //pop
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_MEM: begin
			display_inst;
			sp_reg = sp_reg + 1;
			mem_addr_reg = sp_reg;
			mem_read_reg = 1'h1;
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = 0;
			rf_w_data = MEM_DATA;
			rf_write_reg = 1'h1;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
	
	6'h0f : begin
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = ir_reg[20:16];
			rf_w_data = lui_reg;
			rf_write_reg = 1'h1;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
	
		// beq 
	6'h04 : begin
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			if(RF_DATA_R1 == RF_DATA_R2)
			pc_reg = pc_reg + sign_extd_reg; //reassign pc
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
	
		// bne 
	6'h05 : begin
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			if(RF_DATA_R1 != RF_DATA_R2)
				pc_reg = pc_reg + sign_extd_reg; //reassign pc
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
	
	6'h02 : begin
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			pc_reg = j_direct_addr_reg;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
	
	6'h03 : begin
	case(proc_state)
		`PROC_EXE: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_MEM: begin
			display_inst;
			//nothing
		end //end this state

		`PROC_WB: begin
			display_inst;
			rf_w_address = 31;
			rf_w_data = pc_reg;
			rf_write_reg = 1'h1;
			pc_reg = j_direct_addr_reg;
		end //end this state
	endcase //endcase for this instruction
	end //end this instruction
endcase

end

task print_instruction;
input [`DATA_INDEX_LIMIT:0] inst;

reg [5:0]   opcode;
reg [4:0]   rs;
reg [4:0]   rt;
reg [4:0]   rd;
reg [4:0]   shamt;
reg [5:0]   funct;
reg [15:0]  immediate;
reg [25:0]  address;

begin
// parse the instruction
// R-type 
{opcode, rs, rt, rd, shamt, funct} = inst;
// I-type
{opcode, rs, rt, immediate } = inst;
// J-type
{opcode, address} = inst;

$write("@ %6dns -> [0X%08h] ", $time, inst);

case(opcode)
// R-Type
6'h0 : begin
            case(funct)
                6'h20: $write("add  r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h22: $write("sub  r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h2c: $write("mul  r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h24: $write("and  r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h25: $write("or   r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h27: $write("nor  r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h2a: $write("slt  r%02d, r%02d, r%02d;", rd, rs, rt);
                6'h01: $write("sll  r%02d, r%02d, 0X%02h;", rd, rs, shamt);
                6'h02: $write("srl  r%02d, r%02d, 0X%02h;", rd, rs, shamt);
                6'h08: $write("jr   r%02d;", rs);
                default: $write("");
            endcase
        end
// I-type
6'h08 : $write("addi  r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h1d : $write("muli  r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h0c : $write("andi  r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h0d : $write("ori   r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h0f : $write("lui   r%02d, 0X%04h;", rt, immediate);
6'h0a : $write("slti  r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h04 : $write("beq   r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h05 : $write("bne   r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h23 : $write("lw    r%02d, r%02d, 0X%04h;", rt, rs, immediate);
6'h2b : $write("sw    r%02d, r%02d, 0X%04h;", rt, rs, immediate);
// J-Type
6'h02 : $write("jmp   0X%07h;", address);
6'h03 : $write("jal   0X%07h;", address);
6'h1b : $write("push;");
6'h1c : $write("pop;");
default: $write("");
endcase
$write("\n");
end
endtask

endmodule

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Veir_reg[25:21]ion	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

reg [2:0] Current_State;

assign STATE = Current_State;

initial	

	Current_State = `PROC_FETCH; 

	
	always @ (negedge RST) begin
		$display("******Reset hit******");
		 //when reset signal is active (reset on 0)
		Current_State = 2'hx;
		
	end	
	
	always @ (posedge CLK) begin //when reset signal is NOT active (reset on 1)
		case (Current_State)
		`PROC_FETCH: //begin
			 Current_State = `PROC_DECODE;

		`PROC_DECODE: //begin
			 Current_State = `PROC_EXE;

		`PROC_EXE: //begin
			 Current_State = `PROC_MEM;

		`PROC_MEM: //begin
			Current_State = `PROC_WB;

		`PROC_WB: //begin
			 Current_State = `PROC_FETCH;

		2'hx: //after reset
			Current_State = `PROC_FETCH;
		endcase
	end
endmodule