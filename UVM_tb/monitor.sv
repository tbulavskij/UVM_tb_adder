class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port  #(item) mon_analysis_port_in;
  uvm_analysis_port  #(item) mon_analysis_port_out;
  virtual adder_if vif;

  int xact_counter = 0;

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
        xact_counter++;
        m_item.xact_num = xact_counter;
        mon_analysis_port_in.write(m_item);
      end
      else if (vif.sum_in_en && !vif.arst) begin
        xact_counter++;
        `uvm_info("MON",$sformatf("Reset xact        # %d", xact_counter), UVM_LOW);
      end
      if (vif.sum_out_en) begin
        item m_item = item::type_id::create("m_item");
        m_item.sum_out = vif.sum_out;
        m_item.carry_bit_out = vif.carry_bit_out;
        mon_analysis_port_out.write(m_item);
      end
	end
  endtask
endclass
