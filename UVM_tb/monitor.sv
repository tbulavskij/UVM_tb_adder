class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port  #(item) mon_analysis_port_in;
  uvm_analysis_port  #(item) mon_analysis_port_out;
  virtual adder_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("MON", "Could not get vif")
      mon_analysis_port_in = new("mon_analysis_port_in", this);
      mon_analysis_port_out = new("mon_analysis_port_out", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.clk)
      if (vif.sum_in_en && vif.arst) begin
        item m_item = item::type_id::create("m_item");
        m_item.sum_in1 = vif.sum_in1;
        m_item.sum_in2 = vif.sum_in2;
        mon_analysis_port_in.write(m_item);
        //`uvm_info("MON",$sformatf("Detected xact\n%s", m_item.convert2string()), UVM_LOW);
      end
      if (vif.sum_out_en) begin
        item m_item = item::type_id::create("m_item");
        m_item.sum_out = vif.sum_out;
        m_item.carry_bit_out = vif.carry_bit_out;
        mon_analysis_port_out.write(m_item);
        //`uvm_info("MON",$sformatf("Detected xact\n%s", m_item.convert2string()), UVM_LOW);
      end
	end
  endtask
endclass
