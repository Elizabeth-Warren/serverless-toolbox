include .env
export

build:
	docker build . -t serverless_toolbox

npminstall:
	docker run --rm -i -t \
	--privileged \
	-v ${SRC}:/app \
	-w="/app" \
	serverless_toolbox \
	sh -c 'npm install'

ssh:
	docker run --rm -i -t \
	--privileged \
	-v ${SRC}:/app \
	-w="/app" \
	-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
	-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
	-e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
	-e MOBILIZE_AMERICA_API_KEY \
	-e MONGODB_URI \
	-p "3000:3000" \
	serverless_toolbox \
	bash

toolbox: build npminstall ssh
