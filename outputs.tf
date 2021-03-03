output "bastionIP" {
  value = aws_instance.bastion.public_ip
}

output "nlbDNSNames" {
  value = aws_lb.nlb.dns_name
}

output "albDNSNames" {
  value = aws_lb.alb.dns_name
}

output "firewall1_config" {
  value = data.template_file.firewall1_config.rendered
}

output "firewall2_config" {
  value = data.template_file.firewall2_config.rendered
}



