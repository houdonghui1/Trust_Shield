`timescale 1ns / 100ps

module puf_puf_tb;
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
    reg [15:0] cnt_response_done_p = 0;
    reg [127:0] challenge_buf;
	
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
            mode <= 1'b1;
        end else if (cnt == 20) begin
            enable <= 1'b1;
        end else if (cnt == 30) begin
            challenge <= challenge_buf;
        end else if (cnt == 40) begin
            ready_challenge <= 1'b1;
        end else if (cnt == 50) begin
            ready_challenge <= 1'b0;
        end
    end
    
    always @(posedge response_done) begin
        if(response_done) begin
           #1000 enable <= 1'b0;
                 mode <= 1'b0;
                 ready_challenge <= 1'b0;
                 challenge <= 128'b0;  
           #100 mode <= 1'b1;
           #100 enable <= 1'b1;
           #100 challenge <= challenge_buf;
           #100 ready_challenge <= 1'b1;
           #100 ready_challenge <= 1'b0;
        end      
    end
 

    always @(posedge response_done) begin
        cnt_response_done_p <= cnt_response_done_p + 1'd1;
    end

    always @(posedge clk) begin
        case (cnt_response_done_p)
            0: challenge_buf <= 128'hABC9F99D6C9F99D6C9F99D6C9F99D6CD;
            1: challenge_buf <= 128'h9D6C9F99D6C9F99D6CDABC9F99D6C9F9;
            2: challenge_buf <= 128'hABC9F99D6C9F99D6C9F99D6C9F99D6CD;
            3: challenge_buf <= 128'h9D6C9F99D6C9F99D6CDABC9F99D6C9F9;
            default: challenge_buf <= 128'hABC9F99D6C9F99D6C9F99D6C9F99D6CD;
        endcase
    end

    always @(posedge response_done ) begin
        $display("response bit: %h",response);
    end
   
endmodule