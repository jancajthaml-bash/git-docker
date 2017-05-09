NAME = jancajthaml/git
VERSION = latest

.PHONY: all build image tag upload publish

all: image

build:
	docker build -t $(NAME):stage .

image:
	docker build -t $(NAME):stage .
	docker run -it $(NAME):stage cat /dev/null
	docker export $$(docker ps -a | awk '$$2=="$(NAME):stage" { print $$1 }'| head -1) | docker import - $(NAME):stripped
	docker tag $(NAME):stripped $(NAME):$(VERSION)
	docker rmi -f $(NAME):stripped
	docker rmi -f $(NAME):stage

tag: image
	git checkout -B release/$(VERSION)
	git add --all
	git commit -a --allow-empty-message -m '' 2> /dev/null || :
	git rebase --no-ff --autosquash release/$(VERSION)
	git pull origin release/$(VERSION) 2> /dev/null || :
	git push origin release/$(VERSION)
	git checkout -B master

run: image
	docker run --rm -it --log-driver none \
		-p 22:22 \
		-v ~/git-server/keys:/git-server/keys \
		-v ~/git-server/repos:/git-server/repos \
		$(NAME):$(VERSION) git-server

upload:
	docker login -u jancajthaml https://index.docker.io/v1/
	docker push $(NAME)

publish: image tag upload