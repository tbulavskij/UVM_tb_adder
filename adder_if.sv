interface adder_if(input clk);
  logic [31:0] sum_in1;
  logic [31:0] sum_in2;
  logic        sum_in_en;
  logic [31:0] sum_out;
  logic        sum_out_en;
  logic        carry_bit_out;
  bit          arst;
endinterface
