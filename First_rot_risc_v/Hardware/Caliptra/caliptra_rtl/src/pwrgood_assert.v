module pwrgood_assert (
    input wire clk,          // 时钟信号
    output reg pwrgood = 1'b0  // 上电默认低电平，15个周期后拉高
);

reg [3:0] count = 4'b0;      // 4-bit 计数器（0-15），初始为0

always @(posedge clk) begin
    if (!pwrgood) begin      // 如果 pwrgood 还没拉高
        if (count < 4'b1111) // 15 个周期（0-14 计数）
            count <= count + 1'b1;
        else
            pwrgood <= 1'b1; // 第 15 个周期后拉高
    end
    // 一旦 pwrgood 拉高，就永远保持高电平
end

endmodule