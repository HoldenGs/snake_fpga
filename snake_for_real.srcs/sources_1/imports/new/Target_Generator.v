`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 01:26:22
// Design Name: 
// Module Name: Target_Generator
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


module Target_Generator(
        input CLK,
        input RESET,
        input reached_target,
        output [14:0] rand_target_address
    );
    
    reg [7:0] horizontal_shift_reg;
    reg [6:0] vertical_shift_reg;
    
    assign rand_target_address = {horizontal_shift_reg, vertical_shift_reg};   

    // 8-bit LFSR for horizontal_shift_reg (range 12 to 145)
    reg [7:0] lfsr_h;
    wire [7:0] random_num_h;
    assign random_num_h = (lfsr_h % 134) + 12; // Scaling and offsetting

    // 7-bit LFSR for vertical_shift_reg (range 15 to 105)
    reg [6:0] lfsr_v;
    wire [6:0] random_num_v;
    assign random_num_v = (lfsr_v % 91) + 15; // Scaling and offsetting

    // Linear Feedback Shift Register (LFSR) Logic
    always @(posedge clk or posedge RESET) begin
        if (reached_target || RESET) begin
            lfsr_h <= 8'b00000001; // Non-zero initial value
            lfsr_v <= 7'b0000001;  // Non-zero initial value
        end else begin
            lfsr_h <= {lfsr_h[6:0], lfsr_h[7] ^ lfsr_h[5]}; // Polynomial: x^8 + x^6 + 1
            lfsr_v <= {lfsr_v[5:0], lfsr_v[6] ^ lfsr_v[5]}; // Polynomial: x^7 + x^6 + 1
        end
    end

    // Assigning the scaled and offset random numbers to output registers
    always @(posedge clk) begin
        vertical_shift_reg <= random_num_v;
        horizontal_shift_reg <= random_num_h;
    end
    
endmodule
