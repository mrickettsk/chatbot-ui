include .env

.PHONY: all

build:
	docker build -t chatbot-ui .

run:
	export $(cat .env | xargs)
	docker stop chatbot-ui || true && docker rm chatbot-ui || true
	docker run --name chatbot-ui --rm -e OPENAI_API_KEY=${OPENAI_API_KEY} -p 3000:3000 chatbot-ui

logs:
	docker logs -f chatbot-ui

push:
	docker tag chatbot-ui:latest ${DOCKER_USER}/chatbot-ui:${DOCKER_TAG}
	docker push ${DOCKER_USER}/chatbot-ui:${DOCKER_TAG}

tf-lint:
	cd terraform && terraform fmt --recursive -check

tf-fmt:
	cd terraform && terraform fmt --recursive

tf-init:
	$(MAKE) tf-lint
	cd terraform/envs/stable && terraform init -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" -backend-config="container_name=${BACKEND_CONTAINER_NAME}" 

tf-plan:
	cd terraform/envs/stable && terraform plan -var="openai_api_key=${OPENAI_API_KEY}" -var="openai_api_url=${OPENAI_API_URL}" -out=out.tfplan

tf-apply:
	cd terraform/envs/stable && terraform apply -auto-approve out.tfplan

tf-destroy:
	cd terraform/envs/stable && terraform destroy -auto-approve -var="openai_api_key=${OPENAI_API_KEY}" -var="openai_api_url=${OPENAI_API_URL}"