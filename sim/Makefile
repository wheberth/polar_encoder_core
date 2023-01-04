PRJROOT = $(abspath ../)
export PRJROOT

# Sources
SRCS += $(wildcard ../hdl/*.sv)
SRCS += $(wildcard ../hdl/*.v)
export SRCS

# Testbenches
SIM_SRCS += $(wildcard ../tb/*.sv)
SIM_SRCS += $(wildcard ../tb/*.v)
export SIM_SRCS

# Memory initialization files
MEMS += $(wildcard ../**/*.mif)
MEMS += $(wildcard ../**/*.mem)
MEMS += $(wildcard ../**/*.coe) 
export MEMS

XSIMCFG += ../tcl/xsim_cfg.tcl
XVFLAGS += --sv

TOP ?= $(shell basename $(PRJROOT))
SIM_TOP ?= $(TOP)_tb
export TOP

.PHONY: clean elaboration compilation simulation wave project showsrc


simulation : $(SIM_TOP)_snapshot.wdb
elaboration: xsim.dir/$(SIM_TOP)_snapshot/xsimk.exe
compilation: xsim.dir/work.rlx

xsim.dir/work.rlx: $(SRCS) $(SIM_SRCS) $(MEMS)
	xvlog $(XVFLAGS) $(SRCS) $(SIM_SRCS)
# cp -f $(MEMS) .

xsim.dir/$(SIM_TOP)_snapshot/xsimk.exe: xsim.dir/work.rlx $(MEMS)
	xelab -debug typical -top $(SIM_TOP) -snapshot $(SIM_TOP)_snapshot

$(SIM_TOP)_snapshot.wdb: xsim.dir/$(SIM_TOP)_snapshot/xsimk.exe $(XSIMCFG)
	xsim $(SIM_TOP)_snapshot --tclbatch $(XSIMCFG) -R

wave: $(SIM_TOP)_snapshot.wdb ../tcl/show_wave.tcl
	xsim --gui $(SIM_TOP)_snapshot.wdb --tclbatch ../tcl/show_wave.tcl

clean:
	$(RM) -r *.dir *.log *.pb webtalk*.* *.jou *.wdb *.mem vivado_pid*.* .Xil
	$(RM) -r *_prj

project: $(SRCS) $(SIM_SRCS) ../tcl/make_project.tcl
	vivado -mode tcl -source ../tcl/make_project.tcl

showsrc:
	@echo ============================================
	@echo HDL Sources:   [ $(SRCS) ]
	@echo SIM sources:   [ $(SIM_SRCS) ]
	@echo TOP Entity:    [ $(TOP) ]
	@echo TOP Testbench: [ $(SIM_TOP) ]

CONTAINER ?= vivado:2022.1
DOCKER_ENV_VARS += -e SRCS=$(SRCS) -e SIM_SRCS=$(SIM_SRCS) -e TOP=$(TOP) -e SIM_TOP=$(SIM_TOP)
BASEDIR  = $(PRJROOT)
include ../scripts/docker.mk

