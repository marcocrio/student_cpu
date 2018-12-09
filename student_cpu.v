// Sign extender
module signextend(input wire [15:0] inputVal, output wire [31:0] outputVal);

    assign outputVal = { {16{inputVal[15]}}, inputVal };

endmodule

// 32-bit 2 to 1 Multiplexer
module twotoonemux(input wire [31:0] input1, input wire [31:0] input2, input wire sel, output wire [31:0] outputval);

    assign outputval = (sel == 0) ? input1 : input2;

endmodule

// 5-bit 2 to 1 Multiplexer
module twotoonemux_5bit(input wire [4:0] input1, input wire [4:0] input2, input wire sel, output wire [4:0] outputval);

    assign outputval = (sel == 0) ? input1 : input2;

endmodule

// Arithmetic Logic Unit
module alu(input wire [31:0] op1,input wire [31:0] op2,input wire [3:0] ctrl,output wire [31:0] result);

	assign result = (ctrl == 4'b0000) ? (op1 & op2) : ((ctrl == 4'b0001) ? (op1 | op2) : 
		((ctrl == 4'b0010) ? (op1 + op2) : ((ctrl == 4'b0110) ? (op1 - op2) : 
		((ctrl == 4'b0111) ? ((op1 < op2) ? 1 : 0) : ((ctrl == 4'b1100) ? (~(op1 | op2)) : (op1 + op2)) ) ) ) );

endmodule

// ALU Control
module alucontrol(input wire [5:0] func, input wire [1:0] aluOp, output wire [3:0] aluctrl);
    reg[3:0] Aluctrl;   
    always @(*)
    begin
    case(func)
    32: Aluctrl = 2;    //Add
    34: Aluctrl = 6;    //Sub
    36: Aluctrl = 0;    //AND
    37: Aluctrl = 1;    //OR
    default: Aluctrl = 2;
    endcase
    end
assign aluctrl = Aluctrl;

                   
endmodule

// Register File
module registerfile(input wire rst, input wire [4:0] readReg1, input wire [4:0] readReg2, input wire [4:0] writeReg, 
    input wire [31:0] writeData, input wire regWrite, output reg [31:0] readData1, output reg [31:0] readData2);

    // Register file
    reg [31:0] register[31:0];

    integer i;

    always @(posedge rst)
    begin
        for(i=0;i<32;i=i+1)
        begin
            register[i] = 0;
        end
    end

    always @(readReg1)
    begin
        readData1 = register[readReg1];
    end

    always @(readReg2)
    begin
        readData2 = register[readReg2];
    end

    always @(posedge regWrite)
    begin
    	if(writeReg != 0)
        	register[writeReg] = writeData;
    end

endmodule

// Data Memory
module datamem(input wire rst, input wire [6:0] memAddr, input wire memRead, input wire memWrite, 
    input wire [31:0] writeData, output reg [31:0] readData);

    // Memory
    reg [31:0] memory[127:0];

    integer i;

    always @(posedge rst)
    begin
        for(i=0;i<128;i=i+1)
        begin
            memory[i] = 0;
        end
    end

    always @(posedge memRead)
    begin
        readData = memory[memAddr];
    end

    always @(posedge memWrite)
    begin
        memory[memAddr] = writeData;
    end

endmodule

// FSM portion of Control Path (RegWrite, MemRead, MemWrite)
module controlpathfsm(input wire rst, input wire clk, input wire newInstruction, input wire [5:0] opcode, 
                        output reg _RegWrite, output reg _MemRead, output reg _MemWrite);

                 always @(posedge newInstruction)
						begin
						 case(opcode)
						 0:begin
                            #3 _MemRead = 0;
                            #3 _RegWrite = 1;
                            #1 _MemWrite = 0;
                               _MemRead = 0;
						       _RegWrite = 0;
                               _MemWrite = 0;                           
                            end
						 35: begin
						 #3 _MemRead = 1;
						 #3 _RegWrite =1;
                         #1 _MemWrite = 0;
                            _MemRead = 0;
						    _RegWrite = 0;
                            _MemWrite = 0;                            
						 end
						 43: begin
                         #3 _MemRead = 0;
						 #3 _RegWrite =0;
                         #1 _MemWrite = 1;
                            _MemRead = 0;
						    _RegWrite = 0;
                            _MemWrite = 0;
                            end
                         endcase
						 end
						 
						 always @(rst)
						 begin
						 _RegWrite = 0;
						 _MemWrite = 0;
						 _MemWrite = 0;
						 end
                      

endmodule

// Combinational logic portion of Control Path (MemToReg, RegDst, ALUSrc, ALUOp)
module controlpathcomb(input wire [5:0] opcode, output wire _MemToReg, 
                    output wire _RegDst, output wire _ALUSrc, output wire [1:0] _ALUOp);
  
    reg MemToReg;
    reg RegDst = 1;
    reg ALUSrc;
    reg [1:0] ALUOp;

    always @(opcode)
    begin 
        case(opcode)
        0: begin
            MemToReg = 0;
            RegDst = 1;
            ALUSrc = 0; 
            ALUOp = 2;
           end
        35:
           begin
            MemToReg = 1; 
            RegDst = 0;
            ALUSrc = 1; 
            ALUOp = 2;
           end
        43:
        begin
            MemToReg = 1; 
            RegDst = 0;
            ALUSrc = 1; 
            ALUOp = 2;
           end
        default : begin
        MemToReg = 0;   
        RegDst = 0;
        ALUSrc = 1; 
        ALUOp = 2;
        end
       endcase
    end
    assign _MemToReg = MemToReg;
    assign _RegDst = RegDst;
    assign _ALUSrc = ALUSrc;
    assign _ALUOp = ALUOp;

                    
endmodule

// The entire CPU without PC, instruction memory, and branch circuit
module mipscpu(input wire reset, input wire clock, input wire [31:0] instrword, input wire newinstr);
    wire MemToReg;
    wire RegDst;
    wire ALUSrc;
    wire [1:0] ALUOp;   
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire [31:0] SignExtended; //Output of SignExtender
    wire [4:0]  WriteReg;     //Output of 5bit Mux
    wire [31:0] WriteData;
    wire [31:0] Read1;
    wire [31:0] Read2;
    wire [31:0] Alu2;
    wire [3:0]  ALUCtrl;
    wire [31:0] ALUResult;
    wire [31:0] DataRead;
    wire [31:0]  MemAddr;
        
        datamem         myDataMem(reset, ALUResult, MemRead, MemWrite, Read2, DataRead);
        controlpathcomb myCPC(instrword[31:26], MemToReg, RegDst, ALUSrc, ALUOp);
        controlpathfsm  myCPF(reset, clock, newinstr, instrword[31:26], RegWrite, MemRead, MemWrite);
        signextend      myExtender(instrword[15:0], SignExtended);
        twotoonemux_5bit my5Mux(instrword[20:16], instrword[15:11], RegDst, WriteReg);
        registerfile    myReg(reset, instrword[25:21], instrword[20:16], WriteReg, WriteData, RegWrite, Read1, Read2);
        twotoonemux     my32Mux(Read2, SignExtended, ALUSrc, Alu2);
        alucontrol      myALUC(instrword[5:0], ALUOp, ALUCtrl);
        alu             myALU(Read1, Alu2, ALUCtrl, ALUResult);
        twotoonemux     my32Mux2(ALUResult, DataRead, MemToReg, WriteData);
        
endmodule

