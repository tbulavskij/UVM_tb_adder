class item extends uvm_sequence_item;
  `uvm_object_utils(item)
    rand logic [BUS_WIDTH - 1:0] sum_in1;
    rand logic [BUS_WIDTH - 1:0] sum_in2;
    logic      [BUS_WIDTH - 1:0] sum_out;
    logic                        carry_bit_out;
    rand int                     xact_delay;

  function new(string name = "item");
    super.new(name);
  endfunction

  constraint item_c{
    xact_delay     dist {0:=20, [1:10]:/80};
  }

  virtual function string convert2string();
    return $sformatf("in1 = %0d, in2 = %0d, out = %0d, carrybit = %0d", sum_in1, sum_in2, sum_out, carry_bit_out);
  endfunction
endclass
