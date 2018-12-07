`  module cpu_tb;

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
    	// Add your testbench here
    	
    end
    

endmodule
