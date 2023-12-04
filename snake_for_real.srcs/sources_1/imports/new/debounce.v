`timescale 1ns / 1ps

module debounce(
        input CLK,
        input BTN_IN,
        output BTN_OUT
    );
    
    reg a, b, c;
    
    always @(posedge CLK) begin
        a <= BTN_IN;
        b <= a;
        c <= b;
    end
    
    assign BTN_OUT = c;
    
endmodule