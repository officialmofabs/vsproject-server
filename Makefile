IMAGE_NAME 						= rhel-vsc-code-server
REGISTRY 							= docker.io/tonykay
CONTAINER_RUNTIME 		= docker

#CONTAINER_HOSTNAME 		= terminal
#RHEL_VERSION 					= 9
#TERMINAL_PORT 				= 8080
SHELL_COMMAND 				= sudo su - devops

# Used instead of docker run.... bash 

: ## TIP! make supports tab completion with *modern* shells e.g. zsh etc
: ##  

help: ## Show this help - technically unnecessary as `make` alone will do 
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Thanks to victoria.dev for the above syntax
# https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/

build-arm64 : ## Do a docker based build for ARM
build-arm64 : ##    EXTRA_ARGS='--squash' for example
	DOCKER_BUILDKIT=1 \
		docker build \
		-f Dockerfile-linux-arm64-v8 \
		-t $(IMAGE_NAME) \
		--platform linux/arm64/v8 \
		$(EXTRA_ARGS) .

#		--build-arg=RHEL_VERSION=$(RHEL_VERSION) \
# TODO add multi arch build for ARM and x64

build-x64 : ## Do a docker based build for x64
build-x64 : ##    EXTRA_ARGS='--squash' for example
	DOCKER_BUILDKIT=1 \
		docker build \
		-f Dockerfile-linux-amd64 \
		-t $(IMAGE_NAME) \
		--platform linux/amd64 \
		$(EXTRA_ARGS) .

tag : ## Tag the image
	docker tag $(IMAGE_NAME) $(REGISTRY)/$(IMAGE_NAME):latest

push : ## Push the image to remote registry
	docker push $(REGISTRY)/$(IMAGE_NAME):latest

scan : ## Scan an image using synk
	docker scan $(IMAGE_NAME) \

complete: build scan tag push ## build -> scan -> tag -> push - Do a complete build to push workflow


# TODO login probably redundant? Just unnecessary cruft or useful (encapsultates regsitry?)

docker-login : ## Login to registry via docker command

	docker login $(REGISTRY)

podman-login: Login to registry via podman command 
	podman login $(REGISTRY)

# TODO - old cruft needs cleaned up, taken from a VMlet Makefile
# e.g. no need for privilige
# add volume mounts or dump run completely
# TODO: Remove SSH refs (from vmlet)

#docker-run : ## Run image via docker with sensible defaults
#	$(CONTAINER_RUNTIME) run \
#		-d \
#		--name $(CONTAINER_HOSTNAME) \
#		--hostname $(CONTAINER_HOSTNAME) \
#		--rm \
#		-p $(SSH_PORT):22 \
#		$(REGISTRY)/$(IMAGE_NAME) 
#
#podman-run : ## Run image via podman with sensible defaults
#podman-run : CONTAINER_RUNTIME = podman
#podman-run : docker-run
#
#docker-run-shell : ## Run image via docker with shell default in SHELL_COMMAND
#	$(CONTAINER_RUNTIME) run \
#		-it \
#		--rm \
#		--name $(CONTAINER_HOSTNAME) \
#		--hostname $(CONTAINER_HOSTNAME) \
#		$(REGISTRY)/$(IMAGE_NAME) $(SHELL_COMMAND)
#
#podman-run-shell : ## Run image via podman with shell default in SHELL_COMMAND
#podman-run-shell : CONTAINER_RUNTIME = podman 
#podman-run-shell : docker-run-shell
#
#docker-attach : ## Attach to a container via docker with the devops user shell
#	$(CONTAINER_RUNTIME) exec -it $(CONTAINER_HOSTNAME) $(SHELL_COMMAND)
#
#podman-attach : ## Attach to a container via podman with the devops user shell
#podman-attach : CONTAINER_RUNTIME = podman 
#podman-attach : docker-attach
