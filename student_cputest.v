`include "student_cpu.v"

  module cpu_tb;

	reg Reset;			  	// Reset signal
    reg [31:0] instrWord; 	// Instruction Register
    reg newInstr;         	// Used to signal a new instruction

    reg Clk;				// Clock Signal

	// CPU instantiation
	mipscpu myCPU(Reset, Clk, instrWord, newInstr);
    
    // Clock signal generator
    initial
        Clk = 0;

    always
        #1 Clk = ~Clk;
        
    // Waveform dump for waveform viewer application
	initial
	begin
		$dumpfile("cpu.vcd");
		$dumpvars;
	end
        
	// Test bench
    initial
    begin
    #1 Reset = 1;
    #1 Reset = 0;
    	// Add your testbench here
     myCPU.myDataMem.memory[0] = 10;
     myCPU.myDataMem.memory[1] = 22;
     myCPU.myDataMem.memory[2] = 6;
     instrWord = 10001100000000010000000000000000;
     newInstr = 0;
     #1 newInstr = 1;
     #1 newInstr = 0; 
     #10 
        $display("%d\n", myCPU.myReg.register[1]);
        $display("%d\n", myCPU.myDataMem.memory[0]);
        $display("%d\n",myCPU.ALUResult);
    end
    

endmodule
