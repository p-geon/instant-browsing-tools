# vars
export PORT=9901
export DIR_BASE=~/

# static vars
export TAG=easy_browser_notebook

init:
	@make b
	@echo alias jn='"docker run -it --rm -v $(DIR_BASE):/work/ -p $(PORT):$(PORT) $(TAG) notebook --port $(PORT) --ip=0.0.0.0 --allow-root"' >> ~/.bashrc
	@echo alias jl='"docker run -it --rm -v $(DIR_BASE):/work/ -p $(PORT):$(PORT) $(TAG) lab --port $(PORT) --ip=0.0.0.0 --allow-root"' >> ~/.bashrc
	@exec bash -l

# --------------------------------------------------------	
# build & run
# --------------------------------------------------------
br:
	@make b
	@make r
b: ## build notebook & lab 
	docker build -f Dockerfile \
	--build-arg launch_port=$(PORT) \
	-t $(TAG) .
r: ## run jupyter notebook
	make run-notebook
#
run-notebook: ## run jupyter notebook
	docker run -it --rm -v $(DIR_BASE):/work/ \
	-p $(PORT):$(PORT) $(TAG) \
	notebook --port ${PORT} --ip=0.0.0.0 --allow-root

run-lab: ## run jupyter lab
	docker run -it --rm -v $(DIR_BASE):/work/ \
	-p $(PORT):$(PORT) $(TAG) \
	lab --port ${PORT} --ip=0.0.0.0 --allow-root

# --------------------------------------------------------
# docker commands
# --------------------------------------------------------
export NONE_DOCKER_IMAGES=`docker images -f dangling=true -q`
export STOPPED_DOCKER_CONTAINERS=`docker ps -a -q`

clean: ## clean images&containers
	@make clean-images
	@make clean-containers
clean-images:
	docker rmi $(NONE_DOCKER_IMAGES) -f
clean-containers:
	docker rm -f $(STOPPED_DOCKER_CONTAINERS)
# --------------------------------------------------------
# help
# --------------------------------------------------------
help: ## this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
