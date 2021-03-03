variable "AWS_REGION" {
  default = "us-west-1"
}

variable "ENV" {
  default = "production"
}

# The source CIDR prefix that will communicate
# with the bastion server
variable "management_prefix" {

}

variable "ssh_key" {

}
