module pcie_fifo(
    input clk,
    input rst,

    input  [31:0] in_data,
    input         in_valid,
    output        in_ready,

    output reg [31:0] out_data,
    output            out_valid,
    input             out_ready,

    output full,
    output empty,
    output reg [31:0] fifo_count
);

reg [31:0] mem [0:15];
reg [3:0] wr_ptr, rd_ptr;

assign full  = (fifo_count == 16);
assign empty = (fifo_count == 0);

assign in_ready  = !full;
assign out_valid = !empty;

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        fifo_count <= 0;
        out_data <= 0;
    end else begin

        // Ghi vào FIFO
        if (in_valid && in_ready) begin
            mem[wr_ptr] <= in_data;
            wr_ptr <= wr_ptr + 1;
        end

        // Đọc ra FIFO
        if (out_valid && out_ready) begin
            out_data <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        // Cập nhật số phần tử
        case ({in_valid && in_ready, out_valid && out_ready})
            2'b10: fifo_count <= fifo_count + 1;
            2'b01: fifo_count <= fifo_count - 1;
            default: fifo_count <= fifo_count;
        endcase
    end
end

endmodule