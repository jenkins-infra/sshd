IMAGE_NAME="olblak/sshd"
IMAGE_TAG="latest"

build: 
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run:
	docker run -i -t -p 2223:22 $(IMAGE_NAME):$(IMAGE_TAG)

build.evergreen: 
	docker build -t $(IMAGE_NAME):evergreen-$(IMAGE_TAG) -f Dockerfile.evergreen .
run.evergreen: 
	docker run -i -t -p 2223:22 $(IMAGE_NAME):evergreen-$(IMAGE_TAG) 

.PHONY: build
