export PATH_DEPLOY=.deploy
export APP_NAME=test-service
export AWS_ACCOUNT_ID=281902667290##mgmt
export AWS_DEFAULT_REGION=ap-southeast-2
export AWS_REGION=ap-southeast-2
export CONTAINER_PORT=8080
export CPU=512
export MEMORY?=1024
export COMMAND=apache2-foreground
export WORKSPACE=test-ap-southeast-2
export CLUSTER_NAME=dev-cluster
export FAMILY=dev-cluster-test-service

export NAME=$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_DEFAULT_REGION).amazonaws.com/${APP_NAME}
export TAG=$$(git log -1 --pretty=%h)
export IMAGE_NAME=${NAME}:${TAG}
export LATEST= ${NAME}:latest

ifdef CI
	ECR_REQUIRED=
else
	ECR_REQUIRED=ecrLogin
endif

audit:
	yarn audit

install:
	yarn install --force

ecrLogin:
	@echo "make ecrLogin"
	$(shell docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm aws "aws ecr get-login-password --region $(AWS_DEFAULT_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.ap-southeast-2.amazonaws.com")

dockerBuild: install audit
	@echo "make dockerBuild"
	docker build . -t ${IMAGE_NAME}
.PHONY: dockerBuild

dockerPush: $(ECR_REQUIRED)
	echo "make dockerPush"
	docker push $(IMAGE_NAME) 
.PHONY: dockerPush

deploy-ecs:
	@echo "make deploy-queue"
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) \
		-e AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} \
		-e IMAGE_NAME=$(NAME):$$(git log -1 --pretty=%h) \
		-e CLUSTER_NAME=$(CLUSTER_NAME) \
		-e APP_NAME=$(APP_NAME) \
		-e FAMILY=${FAMILY} \
		--rm \
		deploy /work/worker-deploy.sh
.PHONY: deploy-queue

terraform-init:
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm terraform init
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm terraform workspace new $(WORKSPACE) 2>/dev/null; true # ignore if workspace already exists
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm terraform workspace "select" $(WORKSPACE)
.PHONY: terraform-init

terraform-apply:
	@echo "+++ :terraform: Terraform Apply"
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm \
		terraform apply .terraform-plan-$(WORKSPACE)
.PHONY: terraform-apply

terraform-shell:
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm \
		--entrypoint "" \
		terraform bash
.PHONY: terraform-shell

terraform-plan:
	@echo "+++ :terraform: Terraform Plan"
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm \
		terraform plan -out=.terraform-plan-$(WORKSPACE)
.PHONY: terraform-plan

terraform-plan-destroy:
	@echo "+++ :terraform: Terraform Plan Destroy"
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm \
		terraform plan -out=.terraform-plan-destroy-$(WORKSPACE) -destroy
.PHONY: terraform-plan

terraform-destroy:
	@echo "+++ :terraform: Terraform destroy"
	docker-compose -f $(PATH_DEPLOY)/docker-compose.yml run --rm \
		terraform destroy -auto-approve
.PHONY: terraform-destroy