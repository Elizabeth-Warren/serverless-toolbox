include .env
export

build:
	docker build ./cli -t serverless_toolbox

ssh:
	docker run --rm -i -t \
	--privileged \
	-v ${SRC}:/app \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-p 3000:3000 \
	-w="/app" \
	-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
	-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
	-e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
	serverless_toolbox \
	bash

sam:
	make build
	make ssh

# --net=host \

# --host 0.0.0.0
