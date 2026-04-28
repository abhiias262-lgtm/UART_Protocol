module transmit_data(
    input clk,
    input wr_enb,
    input enb,
    input rst,
    input [7:0] data_in,
    output reg tx,
    output busy
);
    reg [1:0] present_state;
    reg [1:0] next_state;
    reg [7:0] data_stream;
    reg [7:0] index;

// ============== States =================

    parameter   IDLE = 2'b00,
                START = 2'b01,
                DATA = 2'b10,
                STOP = 2'b11;


always @(posedge clk or posedge rst ) begin
    if (rst) begin 
        present_state <= IDLE;
    end 
    else begin
        present_state <= next_state;
    end
end


always @(*) begin
    next_state = present_state;

    case (present_state)

        IDLE:begin
            if (wr_enb) begin
                data_stream = data_in;
                next_state = START;
            end
            else begin
                next_state = IDLE;
            end
        end

        START:begin
            if (enb) begin
                tx = 1'b0;
                next_state = DATA;
            end
            else begin
                next_state = START;
            end
        end

        DATA: begin
            if (enb) begin
                if (index == 3'h7) begin
                    next_state = STOP;
                end
                else begin
                    index = index + 3'b1;
                    tx = data_stream[index];
                end
            end
        end

        STOP:begin
            if (enb)begin
                tx = 1'b1;
                next_state = IDLE;
            end
        end

        default:begin
            tx = 1'b1;
            next_state = IDLE;
        end
        
    endcase
end

    assign busy = (present_state != IDLE);

endmodule