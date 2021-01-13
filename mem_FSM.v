module mem_FSM(
	rst,clk,start,fail,done,reset,preset, en,up_down,carry, read,write,data,is_equal
);

input wire rst,clk,start,is_equal,carry;
output reg fail,done,reset,preset,en,up_down,read,write,data;
parameter Idle = 3'b0;
parameter w0 = 3'd1;
parameter r0 = 3'd2;
parameter w1 = 3'd3;
parameter r1 = 3'd4;
reg [2:0] state ,next_state;
 
always @(posedge clk or posedge rst ) begin 
	if( rst ) begin
		state <= Idle; 
	end
	else  
		state <= next_state;

end

always @(*) begin 
	case (state) 
		Idle: 
			if(start == 1'b1) 
				next_state = w0;
			else begin 
				state = Idle;
				read = 1'b0;
				write = 1'b0;
				up_down = 1'b1;
				data = 1'b0;
				done = 1'b1;
			end
		w0:
			if(carry == 1'b1) 
				next_state = r0;
			else begin 
				state = w0;
				read  = 1'b0;
				write = 1'b1;
				up_down = 1'b1;
				data = 1'b0;
				done = 1'b0;
			end
		r0:
			if(carry == 1'b1) 
				next_state = w1;
			else begin 
				state = r0;
				read = 1'b1;
				write = 1'b0;
				up_down = 1'b0;
				data = 1'b0;
				done = 1'b0;
			end
		w1: 
			
			if(carry == 1'b1) 
				next_state = r1;
			else begin 
				state = w1;
				read = 1'b0;
				write = 1'b1;
				up_down = 1'b1;
				data = 1'b1;
				done = 1'b0;
			end
		r1:

			if(carry == 1'b1) 
				next_state = Idle;
			else begin 
				state = r1;
				read = 1'b1;
				write = 1'b0;
				up_down = 1'b1;
				data = 1'b1;
				done = 1'b0;
			end
		default: begin 
			state = Idle;
			read = 1'b0;
			write = 1'b0;
			up_down = 1'b1;
			data = 1'b0;
			done = 1'b0;
		end
	endcase
end
always @(posedge clk or posedge rst) begin 
	if(rst) begin 
		fail <= 1'b0;
	end
	else if(!is_equal) begin
                fail <= 1'b1;
        end
end

always @(*) begin 
	if(rst) begin 
		reset = 1'b0;
		preset = 1'b0;
		en = 1'b0;
	end
	else begin
	        en = ~carry;	
		if(up_down) begin 
			reset = carry;
			preset = 1'b0;
		end
		else begin 
			preset = carry;
			reset = 1'b0;
		end
	end
end

endmodule
