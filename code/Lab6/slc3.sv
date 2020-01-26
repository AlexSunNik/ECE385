//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;
/*
assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;
*/
sync button_sync[2:0] (Clk, {~Reset, ~Continue, ~Run}, {Reset_ah, Continue_ah, Run_ah});
//sync Din_sync[15:0] (Clk, Din, Din_S);

// Internal connections
logic BEN;
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [1:0 ]DRMUX, SR1MUX;
logic MIO_EN,SR2MUX, ADDR1MUX;

logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC, ALU, data_out;
logic [15:0] Data_from_SRAM, Data_to_SRAM;
logic [15:0] PC_Added;
// Signals being displayed on hex display
logic [3:0][3:0] hex_4;
/*
// For week 1, hexdrivers will display IR. Comment out these in week 2.
HexDriver hex_driver3 (.In0(IR[15:12]), .Out0(HEX3));
HexDriver hex_driver2 (.In0(IR[11:8]), .Out0(HEX2));
HexDriver hex_driver1 (.In0(IR[7:4]), .Out0(HEX1));
HexDriver hex_driver0 (.In0(IR[3:0]), .Out0(HEX0));
*/
// For week 2, hexdrivers will be mounted to Mem2IO
HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (.In0(PC[15:12]), .Out0(HEX7));
HexDriver hex_driver6 (.In0(PC[11:8]), .Out0(HEX6));
HexDriver hex_driver5 (.In0(PC[7:4]), .Out0(HEX5));
HexDriver hex_driver4 (.In0(PC[3:0]), .Out0(HEX4));

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
logic [15:0] ADDRMAR;
assign ADDR = { 4'b00, ADDRMAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;

// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low

//Datapath
datapath d0(.GatePC(GatePC), .GateMDR(GateMDR), .GateALU(GateALU), 
.GateMARMUX(GateMARMUX),.MAR(MAR), 
	.PC(PC), .ALU(ALU), .MDR(MDR), .data_out(data_out));
//MAR_Unit
MAR_Unit mar(.LD_MAR(LD_MAR), .Clk(Clk),.MAR_In(data_out),
.MAR_Out(ADDRMAR));
//PC
PC_Unit pc(.Ld_PC(LD_PC), .Clk(Clk),.Reset(Reset_ah),
.PC_Sel(PCMUX),.PC_Bus(data_out), .PC_Adr(PC_Added), .PC_Out(PC));
//MDR
MDR_Unit mdr(.MIO_EN(MIO_EN), .LD_MDR(LD_MDR), .Clk(Clk), 
.MD_Bus(data_out), .MD_Mem(MDR_In), .MDR_Out(MDR));
//IR
IR_Unit ir(.LD_IR(LD_IR), .Clk(Clk), .IR_In(data_out), .IR_Out(IR));

// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM));

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM),
	 .Data_read(Data_from_SRAM), .Data(Data));
//BEN
BEN_Unit ben(.IR(IR), .Bus(data_out), .Clk(Clk), .LD_BEN(LD_BEN), .LD_CC(LD_CC), .BEN_Out(BEN));
// State machine and control signals
ISDU state_controller(
    .*,.SR1MUX(SR1MUX), .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE));
//REG_FILE
logic[15:0] SR1_Out, SR2_Out;
RegFile regfile(.IR(IR),.D_in(data_out),.DRMUX(DRMUX),.SR1MUX(SR1MUX),.LD_REG(LD_REG),
.Clk(Clk),.Reset(Reset_ah),.SR1_Out(SR1_Out),.SR2_Out(SR2_Out));

ALUUnit alu(.A(SR1_Out),.B0(SR2_Out),.IR(IR),.ALUK(ALUK),.ALU_Out(ALU));
Addr_Adder addr_adder(.IR(IR), .SR1_In(SR1_Out), .PC_In(PC),.ADDR2MUX(ADDR2MUX),.ADDR1MUX(ADDR1MUX),
.Addr_AdderOut(PC_Added));

MARMUX_Unit marmux(.IR(IR), .Adder_Out(PC_Added),.MARMUX(1'b1),.MARMUX_Out(MAR));
	 
always_comb
begin
		if(LD_LED)
			LED = IR[11:0];
		else
			LED = 12'h000;
end

endmodule
