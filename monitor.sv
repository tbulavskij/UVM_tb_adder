class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port  #(item) mon_analysis_port;
  virtual adder_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("MON", "Could not get vif")
      mon_analysis_port = new("mon_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    int prev_in1;
    int prev_in2;
    super.run_phase(phase);
    forever begin
      #1;
      if ((vif.sum_in1 != prev_in1) || (vif.sum_in2 != prev_in2)) begin
        item m_item = item::type_id::create("m_item");
        prev_in1 = vif.sum_in1;
        prev_in2 = vif.sum_in2;
        m_item.in1 = vif.sum_in1;
        m_item.in2 = vif.sum_in2;
        m_item.out = vif.sum_out;
        m_item.carry_bit_out = vif.carry_bit_out;
        `uvm_info("MOV",$sformatf("Detected xact\n%s", m_item.convert2string()), UVM_LOW);
        mon_analysis_port.write(m_item);
      end
	end
  endtask
endclass
