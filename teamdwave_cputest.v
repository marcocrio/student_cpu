`include "teamdwave_cpu.v"

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
	//Reset to make sure all the inputs are set to 0.
    #1 Reset = 1;
    #1 Reset = 0;
    	
     myCPU.myDataMem.memory[0] = 7;    //a = 7
     myCPU.myDataMem.memory[1] = 83;   //b = 83
     myCPU.myDataMem.memory[2] = 21;   //c = 21
     instrWord = 32'b10001100000000010000000000000000; //Instruction to load the value of a.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b10001100000000100000000000000001; //Instruction to load the value of b.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b10001100000000110000000000000010; //Instruction to load the value of c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b00000000001000100010000000100000; //Instruction to add the value of a and b.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
     instrWord = 32'b00000000100000110010100000100010; //Instruction to substract the value of (a + b) and c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
     instrWord = 32'b10101100000001010000000000000011; //Instruction to store the value of a + b - c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
      
        $display("%d\n", myCPU.myDataMem.memory[3]); // Display the value that was stored in memory[3].
    
     #1 Reset = 1;
     #1 Reset = 0;
    	
     myCPU.myDataMem.memory[0] = 3;   //a = 3
     myCPU.myDataMem.memory[1] = 2;   //b = 2
     myCPU.myDataMem.memory[2] = 1;   //c = 1
     instrWord = 32'b10001100000000010000000000000000; //Instruction to load the value of a.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b10001100000000100000000000000001; //Instruction to load the value of b.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b10001100000000110000000000000010; //Instruction to load the value of c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b00000000001000100010000000100000; //Instruction to add the value of a and b.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
     instrWord = 32'b00000000100000110010100000100010; //Instruction to substract the value of (a + b) and c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
     instrWord = 32'b10101100000001010000000000000011; //Instruction to store the value of a + b - c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
      
        $display("%d\n", myCPU.myDataMem.memory[3]); // Display the value that was stored in memory[3].

     #1 Reset = 1;
     #1 Reset = 0;
    	
     myCPU.myDataMem.memory[0] = 65;    //a = 65
     myCPU.myDataMem.memory[1] = 77;   //b = 77
     myCPU.myDataMem.memory[2] = 33;   //c = 33
     instrWord = 32'b10001100000000010000000000000000; //Instruction to load the value of a.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b10001100000000100000000000000001; //Instruction to load the value of b.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b10001100000000110000000000000010; //Instruction to load the value of c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10 
     instrWord = 32'b00000000001000100010000000100000; //Instruction to add the value of a and b.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
     instrWord = 32'b00000000100000110010100000100010; //Instruction to substract the value of (a + b) and c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
     instrWord = 32'b10101100000001010000000000000011; //Instruction to store the value of a + b - c.
     newInstr = 0;
     #1 newInstr = 1;  //Change the value of newInstr to 1, so the instruction can be fetch.
     #1 newInstr = 0; 
     #10
      
        $display("%d\n", myCPU.myDataMem.memory[3]); // Display the value that was stored in memory[3].    
        #1 $finish;
    end
    

endmodule
