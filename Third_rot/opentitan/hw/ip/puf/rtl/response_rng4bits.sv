module response_rng4bits(
    input clk,
    input rst,
    input response_done_2bit,
    input [1:0] response2bit,
    input [3:0] challenge_low4bits,
    
    output reg rng4bits_done,
    output reg [3:0] rng4bits
);

reg [1:0] cnt_response = 0;
reg [1:0] response2bit_one = 0;
reg [1:0] response2bit_two = 0;

always @(posedge clk or negedge rst ) begin
    if (!rst)begin
        rng4bits <= 4'b0;
        rng4bits_done <= 0;
    end
    else begin
        if (response_done_2bit==1) begin
            response2bit_one <=response2bit;
            response2bit_two <=response2bit_one;
            cnt_response <= cnt_response + 1'b1;
            if (cnt_response==2'b00) begin
                rng4bits_done <=1;
                rng4bits <= {response2bit_two,response2bit_one}^challenge_low4bits;
            end
        end
        else begin
            rng4bits_done <=0;
        end
    end
end


/*
always @(posedge response_done_2bit) begin
    response2bit_one <=response2bit;
    response2bit_two <=response2bit_one;
    cnt_response <= cnt_response + 1'b1; 
end

always @(posedge response_done_2bit) begin
    if (cnt_response==0)begin
        rng4bits_done <=1;
        rng4bits <= {response2bit_two,response2bit_one}^challenge_low4bits;
    end
end

always @(negedge response_done_2bit) begin
    rng4bits_done <=0;
end
*/
endmodule
