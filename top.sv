//`include "adder_if.sv"
//`include "sum.sv"
module tb_top;

  import adder_pkg::*;
  import uvm_pkg::*;

  bit clk = 0;
  always #10 clk = ~clk;

  adder_if _if(clk);

	sum u0 	( .sum_in1(_if.sum_in1),
            .sum_in2(_if.sum_in2),
            .sum_in_en(_if.sum_in_en),
            .sum_out(_if.sum_out),
            .sum_out_en(_if.sum_out_en),
            .carry_bit_out(_if.carry_bit_out),
            .clk(_if.clk),
            .arst(_if.arst)
            );

  initial begin
    uvm_config_db #(virtual adder_if)::set(null, "uvm_test_top*", "adder_vif", _if);
    run_test();
  end
endmodule