`timescale 1ns / 1ps

module debounce(
    input    clk,
    input    in_signal,
    input rst,
    output   out_signal
    );
    
    reg state1 = 0, state2 = 0,state3 = 0;
    
    always@(posedge clk) begin
     if(rst == 1'b1)
                begin
                    state1<=in_signal;
                    state2<=in_signal;
                    state3<=in_signal;
                end
            else begin
                state1 <= in_signal;
                state2 <= state1;
                state3 <= state2;
            end
    end
    
    assign out_signal = state1 && state2 && state3;
    
endmodule
