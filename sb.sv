class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_imp #(item, scoreboard) m_analysis_imp;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp = new("m_analysis_imp", this);//
  endfunction

  virtual function write(item m_item);
  `uvm_info("SB",$sformatf("Received xact\n%s", m_item.convert2string()), UVM_LOW);
    if (m_item.out != m_item.in1 + m_item.in2) begin
     `uvm_fatal("SB", "Result is incorrect");
    end
    if ((2 ** 32 - m_item.in1 < m_item.in2) && m_item.carry_bit_out != 1 ) begin
     `uvm_fatal("SB", "Carrybit is incorrect");
    end
 
  endfunction
endclass