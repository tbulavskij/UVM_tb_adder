class monitor_rst extends uvm_monitor;
  `uvm_component_utils(monitor_rst)
  function new(string name="monitor_rst", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port  #(item_rst) mon_rst_analysis_port;
  virtual adder_if vif;

  bit prev_rst_val = 0;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("MON_R", "Could not get vif")
    mon_rst_analysis_port = new("mon_rst_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      #1;
      if (prev_rst_val != vif.arst) begin
        item_rst m_item = item_rst::type_id::create("m_item");
        m_item.arst_val = vif.arst;
        mon_rst_analysis_port.write(m_item);
        prev_rst_val = vif.arst;
      end
	  end
  endtask
endclass
