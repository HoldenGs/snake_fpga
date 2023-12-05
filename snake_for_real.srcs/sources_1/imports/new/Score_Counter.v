`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 01:27:31
// Design Name: 
// Module Name: Score_Counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Score_Counter(
    input CLK,
    input RESET,
    input reached_target,
    input [1:0] master_state,
    output STROBE,
    output [4:0] SCORE
    );
    
    assign SCORE = {DecCount3, DecCount2[3:0]};
    
    wire Bit17TriggOut;
    
    Generic_counter # (
                        .COUNTER_WIDTH(17),
                        .COUNTER_MAX(99999)
                      )
                      Bit17Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE_IN(1'b1),
                        .TRIG_OUT(Bit17TriggOut)
                      );
                      
    Generic_counter # (
                          .COUNTER_WIDTH(1),
                          .COUNTER_MAX(1)
                        )
                        Bit2Counter (
                          .CLK(CLK),
                          .RESET(RESET),
                          .ENABLE_IN(Bit17TriggOut),
                          .COUNT(STROBE)
                      );
    
    wire [3:0] DecCount2;
    wire DecCount3;
    wire trig3;
    
    Generic_counter # (
                        .COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                      )
                      Bit4Counter2 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE_IN(reached_target),
                        .TRIG_OUT(trig3),
                        .COUNT(DecCount2)
                      );
                                                                                                                                  
    Generic_counter # (
                      .COUNTER_WIDTH(1),
                      .COUNTER_MAX(1)
                    )
                    Bit4Counter3 (
                      .CLK(CLK),
                      .RESET(RESET),
                      .ENABLE_IN(trig3),
                      .COUNT(DecCount3)
                    );
    
endmodule
