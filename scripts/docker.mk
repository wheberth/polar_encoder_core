DOCKER_RUN = podman run -it --userns=keep-id
CONTAINER ?= vivado:2022.1
BASEDIR ?= $(abspath .)
WORK = $(shell basename $(BASEDIR))
DOCKER_ENV_VARS += -e DISPLAY=$$DISPLAY
DOCKER_OPTS += --net=host
MAKE_CMD ?= make

docker-shell:
	@xhost +local:all
	@$(DOCKER_RUN) $(DOCKER_OPTS) \
	-v $(BASEDIR):/home/work/$(WORK):z -w /home/work/$(WORK) \
	$(DOCKER_ENV_VARS) $(CONTAINER)

docker-%:
	@xhost +local:all
	@$(DOCKER_RUN) $(DOCKER_OPTS) \
	-v $(BASEDIR):/home/work/$(WORK):z -w /home/work/$(WORK) \
	$(DOCKER_ENV_VARS) $(CONTAINER) \
	-c "echo -e '\e[0;34mRunning inside container => $(CONTAINER) \e[0m\n'; $(MAKE_CMD) $(lastword $(subst -, ,$@))"

