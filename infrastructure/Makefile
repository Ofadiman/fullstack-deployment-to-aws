aws_vault_account="ofadiman"

plan:
	@aws-vault exec ${aws_vault_account} -- terraform plan

apply:
	@aws-vault exec ${aws_vault_account} -- terraform apply

destroy:
	@aws-vault exec ${aws_vault_account} -- terraform destroy

init:
	@aws-vault exec ${aws_vault_account} -- terraform init

validate:
	@terraform validate

format:
	@terraform fmt
