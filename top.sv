`include "adder_if.sv"
//`include "sum.sv"
`include "uvm_macros.svh"

module tb_top;
  import uvm_pkg::*;
  import adder_pkg::*;

  adder_if _if();

	sum u0 	( .sum_in1(_if.sum_in1),
            .sum_in2(_if.sum_in2),
            .sum_out(_if.sum_out),
            .carry_bit_out(_if.carry_bit_out));

  initial begin
    uvm_config_db #(virtual adder_if)::set(null, "uvm_test_top", "adder_vif", _if);
    run_test("adder_test");
  end
endmodule