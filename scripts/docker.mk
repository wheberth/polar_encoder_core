DOCKER_RUN = podman run -it --userns=keep-id
CONTAINER ?= vivado:2023.1
BASEDIR ?= $(abspath .)
WORK = $(shell basename $(BASEDIR))
DOCKER_OPTS += --net=host
MAKE_CMD ?= make
DOCKER_ENV_VARS = 
DOCKER_X_VARS =

ifdef DISPLAY
	DOCKER_X_VARS += -e DISPLAY=$$DISPLAY
	DOCKER_X_VARS += -v $$HOME/.Xauthority:/home/$$USER/.Xauthority
endif

.PHONY: shell check-display

check-display:
ifdef DISPLAY
	@xhost +local:all
endif

docker-%: check-display
	@$(DOCKER_RUN) $(DOCKER_OPTS) \
	-v $(BASEDIR):/home/work/$(WORK):z -w /home/work/$(WORK) \
	$(DOCKER_X_VARS) $(DOCKER_ENV_VARS) $(CONTAINER) \
	-c "echo -e '\e[0;34mRunning inside container => $(CONTAINER) \e[0m\n'; $(MAKE_CMD) $(lastword $(subst -, ,$@))"

shell:
	@bash -i
