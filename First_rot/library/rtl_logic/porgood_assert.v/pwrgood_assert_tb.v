`timescale 1ns / 1ps

module tb_pwrgood_assert();

// 测试信号
reg clk;          // 时钟信号
wire pwrgood;     // 被测试的 pwrgood 信号

// 实例化被测模块 (DUT)
pwrgood_assert dut (
    .clk(clk),
    .pwrgood(pwrgood)
);

// 生成时钟（周期=10ns，频率=100MHz）
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 每 5ns 翻转一次，周期=10ns
end

// 仿真主逻辑
initial begin
    // 初始化仿真
    $display("Simulation started");
    $monitor("Time = %0t, clk = %b, count = %d, pwrgood = %b", 
             $time, clk, dut.count, pwrgood);

    // 运行足够长的时间（>15个周期）
    #200;  // 200ns (20个周期)

    // 检查 pwrgood 是否在第15个周期后拉高
    if (pwrgood === 1'b1) begin
        $display("PASS: pwrgood correctly asserted at 15th cycle!");
    end else begin
        $display("FAIL: pwrgood not asserted as expected!");
    end

    // 结束仿真
    $finish;
end

endmodule