module gpu_sender(
    input clk,
    input rst,
    input enable,

    output reg [31:0] data,
    output reg valid,
    input ready
);

always @(posedge clk) begin
    if (rst) begin
        data <= 0;
        valid <= 0;
    end else begin
        valid <= enable;

        if (enable && ready) begin
            data <= data + 1;
        end
    end
end

endmodule