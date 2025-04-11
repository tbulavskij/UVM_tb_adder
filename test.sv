class adder_test extends uvm_test;
  `uvm_component_utils(adder_test)
  function new(string name = "adder_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  env  				e0;
  gen_item_seq 		seq;
  virtual  	adder_if 	vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    e0 = env::type_id::create("e0", this);


    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    uvm_config_db#(virtual adder_if)::set(this, "e0.a0.*", "adder_vif", vif);

    seq = gen_item_seq::type_id::create("seq");
    seq.randomize();
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(e0.a0.s0);
    #200;
    phase.drop_objection(this);
  endtask

endclass