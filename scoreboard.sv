class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  `uvm_analysis_imp_decl(_port_main_in) 
  `uvm_analysis_imp_decl(_port_main_out) 
  `uvm_analysis_imp_decl(_port_rst)  

  uvm_analysis_imp_port_main_in #(item, scoreboard) m_analysis_imp_main_in;
  uvm_analysis_imp_port_main_out #(item, scoreboard) m_analysis_imp_main_out;
  uvm_analysis_imp_port_rst  #(item_rst, scoreboard) m_analysis_imp_rst;

  item item_queue[$];

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp_main_in = new("m_analysis_imp_main_in", this);
    m_analysis_imp_main_out = new("m_analysis_imp_main_out", this);
    m_analysis_imp_rst  = new("m_analysis_imp_rst", this);
  endfunction

  virtual function void write_port_main_in(item m_item);
  //`uvm_info("SB(in)",$sformatf("Received xact\n%s", m_item.convert2string()), UVM_LOW);
    item_queue.push_back(m_item);
  endfunction

  virtual function void write_port_main_out(item m_item);
  //`uvm_info("SB(out)",$sformatf("Received xact\n%s", m_item.convert2string()), UVM_LOW);
    if (m_item.sum_out != item_queue[0].sum_in1 + item_queue[0].sum_in2) begin
      `uvm_fatal("SB", "Result is incorrect");
    end
    if ((2 ** 32 - item_queue[0].sum_in1 < item_queue[0].sum_in2) && m_item.carry_bit_out != 1 ) begin
      `uvm_fatal("SB", "Carrybit is incorrect");
    end
    item_queue.pop_front();
  endfunction

  virtual function void write_port_rst(item_rst m_item);
    //`uvm_info("SB(rst)",$sformatf("Received xact\n%s", m_item.convert2string()), UVM_LOW);
    item_queue = {};
  endfunction

endclass