`timescale 1ns / 1ps

module rng4bits (
    input wire clk,          // 时钟
    input wire rst_n,        // 异步复位（低有效）
    input wire en,           // 使能信号（1=允许更新LFSR）
    output wire valid,        // 输出有效标志（1=随机数稳定)
    output wire [3:0] random // 4位随机输出
);

// 256位 LFSR 寄存器（初始种子非全零）
reg [255:0] lfsr_reg = 256'h8A7B6C5D4E3F2A1B0C9D8E7F6A5B4C3D2E1F0A9B8C7D6E5F4A3B2C1D0E9F8A7B;

// 选择 LFSR 抽头（基于本原多项式，确保最大周期）
wire feedback = lfsr_reg[255] ^ lfsr_reg[253] ^ lfsr_reg[252] ^ lfsr_reg[250];

// 输出有效信号（可选：延迟1周期以同步）
reg valid_reg = 0;
assign valid = valid_reg;
// 连续生成随机数
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lfsr_reg <= 256'h8A7B6C5D4E3F2A1B0C9D8E7F6A5B4C3D2E1F0A9B8C7D6E5F4A3B2C1D0E9F8A7B;
        valid_reg <= 0;
    end else if(en) begin
        lfsr_reg <= {lfsr_reg[254:0], feedback};  // 左移并插入反馈位
        valid_reg <= 1;  // 输出有效
    end else begin
        valid_reg <= 0;  // 使能关闭时输出无效
    end
end

// 从 LFSR 中提取4位熵源（可选高位或分散位以提高随机性）
assign random = {lfsr_reg[255], lfsr_reg[127], lfsr_reg[63], lfsr_reg[0]} ^ {lfsr_reg[127], lfsr_reg[63], lfsr_reg[31], lfsr_reg[15]};

endmodule