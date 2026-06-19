module tb_pcie_intra_gpu;

reg clk = 0;
reg rst = 1;
reg en0, en1, en2, en3;

wire [31:0] d0, d1, d2, d3;
wire v0, v1, v2, v3;
wire r0, r1, r2, r3;

wire fifo_in_ready;
wire fifo_out_valid;
wire [31:0] fifo_out_data;
wire fifo_full, fifo_empty;
wire [31:0] fifo_count;

wire [31:0] sw_data;
wire sw_valid;
wire mem_ready;
wire [31:0] received_count;

reg [31:0] stall0, stall1, stall2, stall3;
reg [31:0] throughput;
reg [31:0] cycle_count;
reg [31:0] fifo_max;

always #5 clk = ~clk;

always @(posedge clk) begin
    if (rst) begin
        stall0 <= 0;
        stall1 <= 0;
        stall2 <= 0;
        stall3 <= 0;
        throughput <= 0;
        cycle_count <= 0;
        fifo_max <= 0;
    end else begin
        cycle_count <= cycle_count + 1;

        if (v0 && !r0) stall0 <= stall0 + 1;
        if (v1 && !r1) stall1 <= stall1 + 1;
        if (v2 && !r2) stall2 <= stall2 + 1;
        if (v3 && !r3) stall3 <= stall3 + 1;

        if (fifo_out_valid && mem_ready)
            throughput <= throughput + 1;

        if (fifo_count > fifo_max)
            fifo_max <= fifo_count;
    end
end

gpu_sender gpu0(clk, rst, en0, d0, v0, r0);
gpu_sender gpu1(clk, rst, en1, d1, v1, r1);
gpu_sender gpu2(clk, rst, en2, d2, v2, r2);
gpu_sender gpu3(clk, rst, en3, d3, v3, r3);

pcie_switch_4x1 sw(
    clk, rst,
    d0, v0, r0,
    d1, v1, r1,
    d2, v2, r2,
    d3, v3, r3,
    sw_data, sw_valid, fifo_in_ready
);

pcie_fifo fifo_inst(
    .clk(clk),
    .rst(rst),
    .in_data(sw_data),
    .in_valid(sw_valid),
    .in_ready(fifo_in_ready),
    .out_data(fifo_out_data),
    .out_valid(fifo_out_valid),
    .out_ready(mem_ready),
    .full(fifo_full),
    .empty(fifo_empty),
    .fifo_count(fifo_count)
);

gpu_memory mem(
    clk, rst,
    fifo_out_data, fifo_out_valid, mem_ready,
    received_count
);

initial begin
    en0 = 0; en1 = 0; en2 = 0; en3 = 0;

    #20 rst = 0;

    // Test 1: 1 GPU truyền
    en0 = 1; en1 = 0; en2 = 0; en3 = 0;
    #500;

    $display("===== TEST 1: 1 GPU =====");
    $display("Cycle count = %d", cycle_count);
    $display("Throughput  = %d packets", throughput);
    $display("FIFO max    = %d", fifo_max);
    $display("Stall GPU0  = %d", stall0);
    $display("Stall GPU1  = %d", stall1);
    $display("Stall GPU2  = %d", stall2);
    $display("Stall GPU3  = %d", stall3);

    // Test 2: 2 GPU truyền
    en0 = 1; en1 = 1; en2 = 0; en3 = 0;
    #500;

    $display("===== TEST 2: 2 GPU =====");
    $display("Cycle count = %d", cycle_count);
    $display("Throughput  = %d packets", throughput);
    $display("FIFO max    = %d", fifo_max);
    $display("Stall GPU0  = %d", stall0);
    $display("Stall GPU1  = %d", stall1);
    $display("Stall GPU2  = %d", stall2);
    $display("Stall GPU3  = %d", stall3);

    // Test 3: 4 GPU truyền
    en0 = 1; en1 = 1; en2 = 1; en3 = 1;
    #500;

    $display("===== TEST 3: 4 GPU =====");
    $display("Cycle count = %d", cycle_count);
    $display("Throughput  = %d packets", throughput);
    $display("FIFO max    = %d", fifo_max);
    $display("Stall GPU0  = %d", stall0);
    $display("Stall GPU1  = %d", stall1);
    $display("Stall GPU2  = %d", stall2);
    $display("Stall GPU3  = %d", stall3);

    $finish;
end

endmodule