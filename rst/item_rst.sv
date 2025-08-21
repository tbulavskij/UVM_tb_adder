class item_rst extends uvm_sequence_item;
  `uvm_object_utils(item_rst)

    bit      arst;

    rand int arst_delay;
    rand int arst_duration;

  function new(string name = "item_rst");
    super.new(name);
  endfunction

  constraint item_c{
    arst_delay      inside {[50: 100]};
    arst_duration   inside {[0: 50]};
  }

  virtual function string convert2string();
    return $sformatf("delay = %0d, duration = %0d", arst_delay, arst_duration);
  endfunction
endclass
