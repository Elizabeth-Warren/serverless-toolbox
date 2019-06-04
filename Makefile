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
	-e MOBILE_COMMONS_USERNAME \
	-e MOBILE_COMMONS_PASSWORD \
	-e MONGODB_URI \
	-p "3001:3001" \
	serverless_toolbox \
	bash

run-offline:
	docker run --rm -i -t \
	--privileged \
	-v ${SRC}:/app \
	-w="/app" \
	-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
	-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
	-e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
	-e MOBILIZE_AMERICA_API_KEY \
	-e MOBILE_COMMONS_USERNAME \
	-e MOBILE_COMMONS_PASSWORD \
	-e MONGODB_URI \
	-p "3001:3001" \
	serverless_toolbox \
	sh -c 'serverless offline start'

toolbox: build npminstall ssh
offline: build npminstall run-offline
