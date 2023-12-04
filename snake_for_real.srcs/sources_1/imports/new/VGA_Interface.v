`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 01:23:11
// Design Name: 
// Module Name: VGA_Interface
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


module VGA_Interface(
    input CLK,
//    input [1:0] master_state,
    input [11:0] COLOR_IN,
    output [11:0] COLOR_OUT,
    output [18:0] ADDR,
    output HS,
    output VS
    );
    
    //Declaration of bus to allocate space in memory for color, horizontal address and vertial address
    wire [9:0] addrh;
    wire [8:0] addrv;
    
    assign ADDR = {addrh[9:0], addrv[8:0]};
    
    //VGA Controller to select pixel color on the screen according to the position
    VGA_Driver #() vga(
                        .CLK(CLK),
                        .COLOR_IN(COLOR_IN),
                        .COLOR_OUT(COLOR_OUT),
                        .HS(HS),
                        .VS(VS),
                        .ADDRV(addrv),
                        .ADDRH(addrh)
                    );
    
endmodule
