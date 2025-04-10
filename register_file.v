// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

//_inst input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

reg [31:0] reg_inst [31:0];
reg [31:0] data_1_out, data_2_out;

assign DATA_R1 = data_1_out;
assign DATA_R2 = data_2_out;

integer i; //for iteration

always @ (posedge CLK or negedge RST)
begin
// TBD: Code for the register file model
if (RST === 1'b0) //reset
begin
for(i=0; i<32; i = i + 1)
    reg_inst[i] = { 32{1'b0} };
	data_1_out = 32'bz;
	data_2_out = 32'bz;
end

else

begin
 if ((READ===1'b1)&&(WRITE===1'b0)) begin // read operation
	data_1_out =  reg_inst[ADDR_R1];
	data_2_out =  reg_inst[ADDR_R2]; end
 else if ((READ===1'b0)&&(WRITE===1'b1)) // write operation
	reg_inst[ADDR_W] = DATA_W;
end

end
endmodule
