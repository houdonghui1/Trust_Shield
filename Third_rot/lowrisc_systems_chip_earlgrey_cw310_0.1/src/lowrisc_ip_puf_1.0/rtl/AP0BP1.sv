module AP0BP1 (
    input clk,
    input rst_n,
    input   A,
    input  B,
    output reg C
);
reg A_prev, B_prev;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        C <= 0;
    end else begin
        if (A && ~A_prev) begin
            C <= 0;
        end else if (B && ~B_prev) begin
            C <= 1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // 复位时，将A和B的前一个状态都设置为0
        A_prev <= 0;
        B_prev <= 0;
    end else begin
        // 在每个时钟上升沿，保存A和B的当前状态
        A_prev <= A;
        B_prev <= B;
    end
end

endmodule

