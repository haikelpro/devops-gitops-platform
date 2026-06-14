TF_DIR=terraform/environments/local

tf-init:
	cd $(TF_DIR) && terraform init

tf-plan:
	cd $(TF_DIR) && terraform plan

tf-apply:
	cd $(TF_DIR) && terraform apply

tf-destroy:
	cd $(TF_DIR) && terraform destroy

tf-fmt:
	terraform fmt -recursive

tf-validate:
	cd $(TF_DIR) && terraform validate
