package adder_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  parameter BUS_WIDTH = 32;
  `include "item.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "rst/item_rst.sv"
  `include "rst/driver_rst.sv"
  `include "rst/monitor_rst.sv"
  `include "rst/agent_rst.sv"
  `include "rst/sequence_rst.sv"
  `include "scoreboard.sv"
  `include "agent.sv"
  `include "env.sv"
  `include "sequence.sv"
  `include "test.sv"
endpackage
