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

  bit  rst_val;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp_main_in = new("m_analysis_imp_main_in", this);
    m_analysis_imp_main_out = new("m_analysis_imp_main_out", this);
    m_analysis_imp_rst  = new("m_analysis_imp_rst", this);
  endfunction

  virtual function void write_port_main_in(item m_item);
    item_queue.push_back(m_item);
  endfunction

  virtual function void write_port_main_out(item m_item);

    m_item.sum_in1 = item_queue[0].sum_in1;
    m_item.sum_in2 = item_queue[0].sum_in2;
    m_item.xact_num = item_queue[0].xact_num;

    if (m_item.sum_out != m_item.sum_in1 + m_item.sum_in2) begin
      `uvm_fatal("SB", $sformatf("Result is incorrect\n%s", m_item.convert2string()));
    end
    if ((2 ** 32 - m_item.sum_in1 < m_item.sum_in2) && m_item.carry_bit_out != 1 ) begin
      `uvm_fatal("SB", $sformatf("Carrybit is incorrect\n%s", m_item.convert2string()));
    end
    `uvm_info("SB(out)",$sformatf("Received xact #%d", m_item.xact_num), UVM_LOW);
    void'(item_queue.pop_front());
  endfunction

  virtual function void write_port_rst(item_rst m_item);
    if ((item_queue.size() > 0) && (m_item.arst_val == 0)) begin
      `uvm_info("SB(rst)",$sformatf("Resetted xact #%d", item_queue[0].xact_num), UVM_LOW);
      item_queue = {};
    end
  endfunction

endclass