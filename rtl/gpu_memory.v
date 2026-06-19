module gpu_memory(
    input clk,
    input rst,

    input [31:0] data_in,
    input valid,
    output reg ready,

    output reg [31:0] received_count
);

reg [3:0] delay_cnt;

always @(posedge clk) begin
    if (rst) begin
        delay_cnt <= 0;
        ready <= 0;
        received_count <= 0;
    end else begin
        delay_cnt <= delay_cnt + 1;

        if (delay_cnt == 15) begin
            ready <= 1;
            delay_cnt <= 0;

            if (valid)
                received_count <= received_count + 1;
        end else begin
            ready <= 0;
        end
    end
end

endmodule