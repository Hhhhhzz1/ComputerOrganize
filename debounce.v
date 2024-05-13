`timescale 1ns / 1ps

module debounce(
    input    clk,
    input    in_signal,
    output   out_signal
    );
    
    reg state1 = 0, state2 = 0;
    
    always@(posedge clk) begin
        state1 <= in_signal;
        state2 <= state1;
    end
    
    assign out_signal = state1 && state2;
    
endmodule
