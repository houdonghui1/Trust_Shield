`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 14:54:40
// Design Name: 
// Module Name: PUF128_tb
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


`timescale 1ns/1ns

module PUF128_tb;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [127:0] challenge;
    reg tx_data_valid;
    reg ready_challenge;

    // Outputs
    wire request;
    wire response_done;
    wire [127:0] response;

    // Instantiate the unit under test (UUT)
    PUF128 dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .challenge(challenge),
        .tx_data_valid(tx_data_valid),
        .request(request),
        .ready_challenge(ready_challenge),
        .response_done(response_done),
        .response(response)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Stimulus generation
    initial begin
        // Reset inputs
        rst = 1;
        start = 0;
        clk = 0;
        challenge = 128'h0;
        tx_data_valid = 0;
        ready_challenge = 0;

        // Wait  to allow reset to complete
        #20 rst = 0;
        
        #20 rst = 1;
        
        #20 start = 1;
        
        
        #40 challenge = 128'h0123456789ABCDEF0123456789ABCDEF;
           
        
        #100 ready_challenge = 1'd1;

        #1000000
        
        // Print the response
        $display("Response: %h", response);

    end

endmodule
