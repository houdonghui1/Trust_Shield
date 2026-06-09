
module puf_rng_tb;
    reg  clk;
    reg  rst_n;

    // reg clk;
    // reg rst_n;
    reg enable;
    reg mode;
    reg ready_challenge;
    reg [127:0] challenge;
    wire response_done;
    wire [255:0] response;
    wire rng4bits_done;
    wire [3:0] rng4bits;

    always #5 clk = ~clk;

    initial begin
        clk =0;
        rst_n =0;
        #20 rst_n =1;
    end
    
    PUF_core uut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .mode(mode),
        .challenge(challenge),
        .ready_challenge(ready_challenge),
        .response_done(response_done),
        .response(response),
        .rng4bits_done(rng4bits_done),
        .rng4bits(rng4bits)    
    );


    reg [15:0] cnt;

	always @(posedge clk or posedge rst_n) begin
		if(~rst_n) begin
			cnt <= 16'd0;
		end else begin
		if (cnt == 30000) begin
		cnt <= cnt;
		end else begin
		cnt <= cnt + 1'd1;
		end
	end
	end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            enable <= 1'b0;
            mode <= 1'b0;
            ready_challenge <= 1'b0;
            challenge <= 128'b0;
        end else if (cnt == 10) begin
            mode <= 1'b0;
        end else if (cnt == 20) begin
            enable <= 1'b1;
        end
    end

    always @(posedge rng4bits_done ) begin
        $display("rng bit: %b",rng4bits);
    end
   
endmodule