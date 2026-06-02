module ready_valid (
    input wire clk,
    input wire ready_out,
    input wire encdec_enable_in,
    output reg valid_out
);
always @(posedge clk) begin
    if (ready_out == 1) begin
        valid_out <= 1;
    end
    else if (encdec_enable_in == 0) begin
        valid_out <= 0;
    end
end
endmodule
