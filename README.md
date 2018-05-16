# nginx-demo-proj
using Terraform
- Requisite 

This assumes you have an AWS account - got your access key, secret and a private key to ssh to instance when created. You have installed terraform as well.

- Clone this Repo

- Open the `secret.tfvars` file and provide your access key and secret. Make this part of your git ignore. Save the file

- Open the `demo.auto.tfvars` file and edit the comment #3 keys and corresponding private key #12. Make sure the #0 region is correct. Save The file

- Execute `terraform init` - make sure that no errors are introduced because of your manual edit.

- Execute `terraform plan -var-file="secret.tfvars"`

- Execute `terraform apply -var-file="secret.tfvars"`

- Execute `terraform show|grep dns_name`

- Execute `http:\\<dns_name>` in browser. You can login to using your private key to `terraform show|grep public|head -1`

command: ssh -i <private_key_with_path> ubuntu@<public_ip_from_above>

- Execute `terraform destroy -var-file="secret.tfvars`
