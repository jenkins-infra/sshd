IMAGE_NAME="jenkinsciinfra/sshd"
## Only update tags if configured people or authorized keys changed
EVERGREEN_IMAGE_TAG="evergreen-$(shell cd config/authorized_keys;\
		  tar cf - $$(cat ../../users.evergreen) | md5sum | cut -c1-6)"

build: build.evergreen

build.evergreen: 
	docker build -t $(IMAGE_NAME):$(EVERGREEN_IMAGE_TAG) -f Dockerfile .

run.evergreen: 
	docker run -i -t -p 2223:22 --name sshd --rm $(IMAGE_NAME):$(EVERGREEN_IMAGE_TAG) 

push.evergreen: 
	docker push $(IMAGE_NAME):$(EVERGREEN_IMAGE_TAG)


.PHONY: build
