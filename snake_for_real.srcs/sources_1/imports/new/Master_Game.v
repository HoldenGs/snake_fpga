`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 03:44:16
// Design Name: 
// Module Name: Master_Game
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


module Master_Game(
        input CLK,
        input BTNU,
        input BTND,
        input BTNL,
        input BTNR,
        input BTNC,
        output [11:0] RGB,
        output HS,
        output VS,
        output [3:0] SEG_SELECT,
        output [7:0] HEX_OUT
    );
    
    wire [4:0] score;
    wire [1:0] state_master;
    wire [1:0] state_navigation;
    wire [14:0] target_address;
    wire [18:0] address;
    wire [11:0] color;
    wire strobe;
    wire fail;
    wire reached_target;
    wire BTNU_D;
    wire BTND_D;
    wire BTNL_D;
    wire BTNR_D;
    wire BTNC_D;

    always @(*) begin
        $monitor("BTNU = %b, BTND = %b, BTNL = %b, BTNR = %b, BTNC = %b, score = %b, state_master = %b, state_navigation = %b, target_address = %b, address = %b, color = %b, strobe = %b, fail = %b, reached_target = %b, BTNU_D = %b, BTND_D = %b, BTNL_D = %b, BTNR_D = %b, BTNC_D = %b", BTNU, BTND, BTNL, BTNR, BTNC, score, state_master, state_navigation, target_address, address, color, strobe, fail, reached_target, BTNU_D, BTND_D, BTNL_D, BTNR_D, BTNC_D);
    end

    debounce du(
                        .CLK(CLK),
                        .BTN_IN(BTNU),
                        .BTN_OUT(BTNU_D)
    );

    debounce dd(
                        .CLK(CLK),
                        .BTN_IN(BTND),
                        .BTN_OUT(BTND_D)
    );

    debounce dl(
                        .CLK(CLK),
                        .BTN_IN(BTNL),
                        .BTN_OUT(BTNL_D)
    );

    debounce dr(
                        .CLK(CLK),
                        .BTN_IN(BTNR),
                        .BTN_OUT(BTNR_D)
    );

    debounce dc(
                        .CLK(CLK),
                        .BTN_IN(BTNC),
                        .BTN_OUT(BTNC_D)
    );
    
    Master_State_Machine msm(
                        .CLK(CLK),
                        .BTNU(BTNU_D),
                        .BTND(BTND_D),
                        .BTNL(BTNL_D),
                        .BTNR(BTNR_D),
                        .BTNC(BTNC_D),
                        .SCORE(score),
                        .fail(fail),
                        .STATE(state_master)
                    );
    
    Navigation_State_Machine nsm(
                        .CLK(CLK),
                        .BTNU(BTNU_D),
                        .BTND(BTND_D),
                        .BTNL(BTNL_D),
                        .BTNR(BTNR_D),
                        .BTNC(BTNC_D),
                        .STATE(state_navigation)
                    );
    
    Snake_control s(
                        .CLK(CLK),
                        .RESET(BTNC_D),
                        .score(score),
                        .state_master(state_master),
                        .state_navigation(state_navigation),
                        .target_address(target_address),
                        .pixel_address(address),
                        .COLOR_OUT(color),
                        .reached_target(reached_target),
                        .fail(fail)
                    );
    
    Target_Generator tg(
                        .CLK(CLK),
                        .RESET(BTNC_D),
                        .reached_target(reached_target),
                        .rand_target_address(target_address)
                    );
    
    VGA_Interface vgai(
                        .CLK(CLK),
                        .COLOR_IN(color),
                        .COLOR_OUT(RGB),
                        .ADDR(address),
                        .HS(HS),
                        .VS(VS)
                    );
    
    Score_Counter sc(
                        .CLK(CLK),
                        .RESET(BTNC_D),
                        .reached_target(reached_target),
                        .master_state(state_master),
                        .STROBE(strobe),
                        .SCORE(score)
                    );
    
    wire [4:0] DecCountAndDOT0;
    wire [4:0] DecCountAndDOT1;
    wire [4:0] DecCountAndDOT2;
    wire [4:0] DecCountAndDOT3;
    
    wire [4:0] MuxOut;
    
    assign DecCountAndDOT0 = {4'b0, score[4]};
    assign DecCountAndDOT1 = {1'b0, score[3:0]};
    assign DecCountAndDOT2 = {5'b0};
    assign DecCountAndDOT3 = {5'b0};
    
    Multiplexer_4way Mux4(
                        .CONTROL({1'b0, strobe}),
                        .IN0(DecCountAndDOT0),
                        .IN1(DecCountAndDOT1),
                        .IN2(DecCountAndDOT2),
                        .IN3(DecCountAndDOT3),
                        .OUT(MuxOut)
                        );
    
    
    Segment_Display_Interface sdi(
                        .SEG_SELECT_IN({1'b0, strobe}),
                        .BIN_IN(MuxOut[3:0]),
                        .DOT_IN(1'b0),
                        .SEG_SELECT_OUT(SEG_SELECT),
                        .HEX_OUT(HEX_OUT)
                    );
    
endmodule
