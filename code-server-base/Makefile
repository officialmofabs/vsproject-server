REGISTRY               = docker.io/tonykay
IMAGE_NAME             = rhel9-vsc-code-server
VERSION                = v0.0.1

HOSTNAME               = code
CONTAINER_NAME         = rhel9-code-server
PASSWORD               = changeme

SHELL_COMMAND          = bash

#CONTAINER_RUNTIME      = docker

# Used instead of docker run.... bash 

help : ## Show this help - technically unnecessary as `make` alone will do 
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Thanks to victoria.dev for the above syntax
# https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/

: ##  
: ## TIP! make supports tab completion with *modern* shells e.g. zsh etc
: ##  

build : ## Do a docker based buildx multiarch build for amd64 arm64
	docker buildx build \
    --platform linux/arm64/v8,linux/amd64 \
    --tag $(REGISTRY)/$(IMAGE_NAME):$${VERSION:-latest} \
    --push \
    $(EXTRA_ARGS) .

build-arm64 : ## Do a docker based buildx ARM 64 build i.e. --platform linux/arm64/v8 
	docker buildx build \
		--platform linux/arm64/v8 \
		--tag $(REGISTRY)/$(IMAGE_NAME):arm64-$${VERSION:-latest} \
		--load \
		$(EXTRA_ARGS) .

build-x64 : ## Do a docker based buildx AMD 64 (x86)  build i.e. --platform linux/amd64 
	docker buildx build \
    --platform linux/amd64 \
    --tag $(REGISTRY)/$(IMAGE_NAME):amd64-$${VERSION:-latest} \
    --load \
    $(EXTRA_ARGS) .

run : ## Run locally using default arch, sharing local directory on 8080
	docker run -d --rm \
    --name $(CONTAINER_NAME) \
    --hostname $(CONTAINER_HOSTNAME) \
    -p 8080:8080 \
    --volume "$(pwd):/home/devops/project" \
    --env PASSWORD=$(PASSWORD) \
      $(REGISTRY)/$(IMAGE_NAME):$(VERSION)

run-arm : ## Run ARM image locally, sharing local directory on 8080
	docker run -d --rm \
    --platform linux/arm64/v8 \
    --name $(CONTAINER_NAME) \
    --hostname $(CONTAINER_HOSTNAME) \
    --port 8080:8080 \
    --volume "$(pwd):/home/devops/project" \
    --env PASSWORD=$(PASSWORD) \
      $(REGISTRY)/$(IMAGE_NAME):$(VERSION)

run-x64 : ## Run AMD x86-64 image locally, sharing local director on 8080
	docker run -d --rm \
    --platform linux/amd64 \
    --name $(CONTAINER_NAME) \
    --hostname $(CONTAINER_HOSTNAME) \
    --port 8080:8080 \
    --volume "$(pwd):/home/devops/project" \
    --env PASSWORD=hello \
      $(REGISTRY)/$(IMAGE_NAME):$(VERSION)

shell : ## Exec an interactive bash shell into running container
	docker exec \
    -it $(CONTAINER_NAME) \
     bash

#tag : ## Tag the image
#  docker tag $(IMAGE_NAME) $(REGISTRY)/$(IMAGE_NAME):latest
#
#push : ## Push the image to remote registry
#  docker push $(REGISTRY)/$(IMAGE_NAME):latest
#
#scan : ## Scan an image using synk
#  docker scan $(IMAGE_NAME) \
#
#complete: build scan tag push ## build -> scan -> tag -> push - Do a complete build to push workflow
#
#
## TODO login probably redundant? Just unnecessary cruft or useful (encapsultates regsitry?)
#
#docker-login : ## Login to registry via docker command
#
#  docker login $(REGISTRY)
#
#podman-login: Login to registry via podman command 
#  podman login $(REGISTRY)
#
## TODO - old cruft needs cleaned up, taken from a VMlet Makefile
## e.g. no need for privilige
## add volume mounts or dump run completely
## TODO: Remove SSH refs (from vmlet)
#
##docker-run : ## Run image via docker with sensible defaults
##  $(CONTAINER_RUNTIME) run \
##    -d \
##    --name $(CONTAINER_HOSTNAME) \
##    --hostname $(CONTAINER_HOSTNAME) \
##    --rm \
##    -p $(SSH_PORT):22 \
##    $(REGISTRY)/$(IMAGE_NAME) 
##
##podman-run : ## Run image via podman with sensible defaults
##podman-run : CONTAINER_RUNTIME = podman
##podman-run : docker-run
##
##docker-run-shell : ## Run image via docker with shell default in SHELL_COMMAND
##  $(CONTAINER_RUNTIME) run \
##    -it \
##    --rm \
##    --name $(CONTAINER_HOSTNAME) \
##    --hostname $(CONTAINER_HOSTNAME) \
##    $(REGISTRY)/$(IMAGE_NAME) $(SHELL_COMMAND)
##
##podman-run-shell : ## Run image via podman with shell default in SHELL_COMMAND
##podman-run-shell : CONTAINER_RUNTIME = podman 
##podman-run-shell : docker-run-shell
##
##docker-attach : ## Attach to a container via docker with the devops user shell
##  $(CONTAINER_RUNTIME) exec -it $(CONTAINER_HOSTNAME) $(SHELL_COMMAND)
##
##podman-attach : ## Attach to a container via podman with the devops user shell
##podman-attach : CONTAINER_RUNTIME = podman 
##podman-attach : docker-attach
