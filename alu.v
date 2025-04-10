// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

// store register-temporary  
reg zero_reg;
reg [`DATA_INDEX_LIMIT:0] OUT;


assign ZERO = zero_reg;


always @(OP1 or OP2 or OPRN) begin


/* fn code mapping
1 + `ALU_OPRN_WIDTH'h20
2 - `ALU_OPRN_WIDTH'h22
3 * `ALU_OPRN_WIDTH'h2c
4 >> `ALU_OPRN_WIDTH'h02
5 << `ALU_OPRN_WIDTH'h01
6 &&  `ALU_OPRN_WIDTH'h24
7 || `ALU_OPRN_WIDTH'h25
8 ~| `ALU_OPRN_WIDTH'h27
9 slt `ALU_OPRN_WIDTH'h2a
*/
	zero_reg = 1'h0;
    case (OPRN)
            `ALU_OPRN_WIDTH'h20 : OUT = OP1 + OP2; // additiion operation 
            `ALU_OPRN_WIDTH'h22 : OUT = OP1 - OP2; // subtraction  operation 
            `ALU_OPRN_WIDTH'h2c : OUT = OP1 * OP2; // multiplication operation 
            `ALU_OPRN_WIDTH'h02 : OUT = OP1 >> OP2; // shift right operation 
            `ALU_OPRN_WIDTH'h01 : OUT = OP1 << OP2; // shift left operation 
            `ALU_OPRN_WIDTH'h24 : OUT = OP1 & OP2; //AND operationn 
            `ALU_OPRN_WIDTH'h25 : OUT = OP1 | OP2; //OR operation 
            `ALU_OPRN_WIDTH'h27 : OUT = ~(OP1 | OP2); //NOR operation 
            `ALU_OPRN_WIDTH'h2a : OUT = OP1 < OP2 ? 1 : 0; //Set less than operation 
    endcase


if (OUT == 32'h0) 
	zero_reg = 1'h1;
end

endmodule

/*// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;
reg zero_reg;
reg [31:0] out_reg;

assign ZERO = zero_reg;
assign OUT = out_reg;

always @(OP1 or OP2 or OPRN)
begin
// TBD - Code for the ALU

1 + `ALU_OPRN_WIDTH'h20
2 - `ALU_OPRN_WIDTH'h22
3 * `ALU_OPRN_WIDTH'h2c
4 >> `ALU_OPRN_WIDTH'h02
5 << `ALU_OPRN_WIDTH'h01
6 &&  `ALU_OPRN_WIDTH'h24
7 || `ALU_OPRN_WIDTH'h25
8 ~| `ALU_OPRN_WIDTH'h27
9 slt `ALU_OPRN_WIDTH'h2a

zero_reg = 1'h0;

case (OPRN)
1: begin out_reg = OP1 + OP2; end
2: begin out_reg = OP1 - OP2; end
3: begin out_reg = OP1 * OP2; end
4: begin out_reg = OP1 >> OP2; end
5: begin out_reg = OP1 << OP2; end
6: begin out_reg = (OP1 & OP2); end
7: begin out_reg = (OP1 | OP2); end
8: begin out_reg = ~(OP1 | OP2); end
9: begin out_reg = (OP1 < OP2); end
default: out_reg = 32'hx;
endcase
if (out_reg == 32'h0)
zero_reg = 1'h1;
end
endmodule
*/