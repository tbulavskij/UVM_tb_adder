class driver_rst extends uvm_driver #(item_rst);
  `uvm_component_utils(driver_rst)

  function new(string name = "driver_rst", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual adder_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif)) begin
      `uvm_fatal("DRV(rst)", "Could not get vif")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item_rst m_item;
      seq_item_port.get_next_item(m_item);
      drive_item(m_item);
      #1;
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(item_rst m_item);
    vif.arst = 0;
    #(m_item.arst_duration);
    vif.arst = 1;
    #(m_item.arst_delay);
  endtask
endclass
