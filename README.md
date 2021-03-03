# ELB Sandwich using Terraform

## What is this repository for?

This is an example Terraform project which deploys a web application using AWS infrastructure that is:

- Isolated in a VPC
- Load balanced
- Protected by Vyos routers acting as firewalls
- Accessible by SSH via a bastion host

### Dependencies

This project assumes that you are already familiar with AWS and Terraform.

There are several dependencies that are needed before the Terraform project can be run. Make sure that you have:

- The [Terraform](https://www.terraform.io) 0.14 binary installed and available on the PATH.
- AWS credentials configured via environment variables or credentials file
- An existing SSH key pair in the region in which you launch the templates

### Configure the project properties

Edit the vars.tf to include your SSH key and source IPv4 address.

```
variable "management_prefix" {
  default = "x.x.x.x/32"
}

variable "ssh_key" {
  default = "foo"
}
```

## Deployment

### Initialize the modules

`terraform init`

### Plan the deployment

`terraform plan -var-file="user.tfvars"`

### Apply the deployment

`terraform apply`

In the output of terraform apply, you will see the IPv4 address of the bastion host. It can be used
to access the firewalls and web servers.

The firewalls need additional configuration. This configuration is provided in the output as well. Include
the IP address of the ALB in the same availability zone as destination NAT IP address.

Once both firewalls are configured, you can visit the web application by entering the FQDN of the NLB in
your browser.

### Destroy the deployment

`terraform destroy`

## Additional Information

This repo is intended to accompany the video at https://youtu.be/ZBY7WgpeeW8.

For any questions, please contact me at jeffl@konekti.us.
