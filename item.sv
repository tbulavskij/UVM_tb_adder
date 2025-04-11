class item extends uvm_sequence_item;
  `uvm_object_utils(item)
    rand logic [31:0] in1;
    rand logic [31:0] in2;
    logic [31:0]      out;
    logic             carry_bit_out;

  function new(string name = "item");
    super.new(name);
  endfunction

  virtual function string convert2string();
    return $sformatf("in1 = %0d, in2 = %0d, out = %0d, carrybit = %0d", in1, in2, out, carry_bit_out);
  endfunction
endclass
