include .env
export

build:
	docker build . -t serverless_toolbox

ssh:
	docker run --rm -i -t \
	--privileged \
	-v ${SRC}:/app \
	-w="/app" \
	-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
	-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
	-e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
	serverless_toolbox \
	bash

toolbox:
	make build
	make ssh
