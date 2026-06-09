`timescale 1ns / 100ps
module rs_encode_wrapper_tb;
    reg   clk;
    reg   rst_n;


    // reg clk;
    // reg rst_n;
    reg clrn = 1;
    reg encode_en;
    reg [8*168-1:0] datain;
    wire [8*200-1:0] encoded_data;
    wire valid;
    wire ready;

    wire valid_re;
    wire ready_re;
    wire [49:0] encoded_data_re;

    initial begin
        clk =0;
        rst_n =0;
        #20 rst_n =1;
    end
    // Instantiate the Unit Under Test (UUT)
    rs_encode_wrapper uut (
        .clk(clk),
        .rst_n(rst_n),
        .clrn(clrn),
        .encode_en(encode_en),
        .datain(datain),
        .encoded_data(encoded_data),
        .valid(valid),
        .ready(ready),
        .ready_re        (ready_re        ),
        .valid_re        (valid_re        ),
        .encoded_data_re (encoded_data_re )
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock

    reg [11:0] cnt;

	always @(posedge clk or posedge rst_n) begin
		if(~rst_n) begin
			cnt <= 12'd0;
		end else begin
		if (cnt == 5000) begin
		cnt <= cnt;
		end else begin
		cnt <= cnt + 1'd1;
		end
	end
	end

    localparam ref_encode_data = 1600'hd9dcbd68957d297e5aaf6807890de9d0d958528f8c43c11d04a9dd25624145fba8a7a6a5a4a3a2a1a09f9e9d9c9b9a999897969594939291908f8e8d8c8b8a898887868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a090807060504030201;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            encode_en <= 0;
            datain <= {168{8'd0}};
        end else if (cnt == 10) begin
            datain <= 1344'ha8a7a6a5a4a3a2a1a09f9e9d9c9b9a999897969594939291908f8e8d8c8b8a898887868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a090807060504030201;
        end else if (cnt == 20 && ready == 1) begin
            encode_en <= 1;
        end else if (cnt == 21) begin
            encode_en <= 0;
        end else if (valid) begin
            if(encoded_data == ref_encode_data) begin
                $display("Verify pass!");
            end else begin
                $display("Encoded data: %h",encoded_data);
            end
        end
    end

endmodule