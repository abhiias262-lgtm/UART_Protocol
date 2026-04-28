module Baud_rate_genarator(
    input clk,
    input rst,
    output  tx_enb,
    output  rx_enb
);

reg [12:0] tx_counter;
reg [9:0]  rx_counter;

always @(posedge clk or posedge rst) begin
    if (rst || tx_counter == 5208) begin
        tx_counter = 0;
    end
    else begin
        tx_counter = tx_counter + 1'b1;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst || rx_counter == 325) begin
        rx_counter = 0;
    end
    else begin
        rx_counter = rx_counter + 1'b1;
    end
end

wire tx_enb = (tx_counter==5208);
wire rx_enb = (rx_counter==325);

endmodule