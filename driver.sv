class driver extends uvm_driver #(item);
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual adder_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif)) begin
      `uvm_fatal("DRV", "Could not get vif")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item;
      seq_item_port.get_next_item(m_item);
      drive_item(m_item);
      #1
      `uvm_info("DRV",$sformatf("Generated xact\n%s", m_item.convert2string()), UVM_LOW);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(item m_item);
    vif.sum_in1 <= m_item.in1;
    vif.sum_in2 <= m_item.in2;
  endtask
endclass
