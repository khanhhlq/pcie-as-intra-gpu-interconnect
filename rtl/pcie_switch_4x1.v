module pcie_switch_4x1(
    input clk,
    input rst,

    input [31:0] data0, input valid0, output reg ready0,
    input [31:0] data1, input valid1, output reg ready1,
    input [31:0] data2, input valid2, output reg ready2,
    input [31:0] data3, input valid3, output reg ready3,

    output reg [31:0] out_data,
    output reg out_valid,
    input out_ready
);

reg [1:0] arbiter;

always @(posedge clk) begin
    if (rst) begin
        arbiter <= 0;
        out_valid <= 0;
        ready0 <= 0; ready1 <= 0; ready2 <= 0; ready3 <= 0;
    end else begin
        ready0 <= 0; ready1 <= 0; ready2 <= 0; ready3 <= 0;
        out_valid <= 0;

        if (out_ready) begin
            case (arbiter)
                2'd0: if (valid0) begin out_data <= data0; out_valid <= 1; ready0 <= 1; end
                2'd1: if (valid1) begin out_data <= data1; out_valid <= 1; ready1 <= 1; end
                2'd2: if (valid2) begin out_data <= data2; out_valid <= 1; ready2 <= 1; end
                2'd3: if (valid3) begin out_data <= data3; out_valid <= 1; ready3 <= 1; end
            endcase

            arbiter <= arbiter + 1;
        end
    end
end

endmodule