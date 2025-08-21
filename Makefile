.PHONY: build run gui clean

work := $(shell pwd)
build := $(work)/build

export W_DIR = $(work)
export LM_LICENSE_FILE = /home/user/questasim/questasim/license.dat

build:
	vlog -f $(work)/file_list.f -work $(build)/ -cover bcestf -covercells

run:
	vsim build.tb_top -c -do "run -all; exit;" +UVM_TESTNAME=adder_test 

gui:
	vsim build.tb_top -do "add wave -position insertpoint vsim:/tb_top/_if/*;" +UVM_TESTNAME=adder_test

clean:
	rm -rf $(build)
	rm -f $(work)/transcript
	rm -f $(work)/vsim_stacktrace.vstf