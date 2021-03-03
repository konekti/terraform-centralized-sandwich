resource "aws_lb" "nlb" {
  internal           = false
  load_balancer_type = "network"
  subnets            = [module.firewall-vpc.public_subnets[0], module.firewall-vpc.public_subnets[1]]

  enable_deletion_protection = false

}

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.firewall.arn
  }
}

resource "aws_lb_target_group" "firewall" {
  port     = 80
  protocol = "TCP"
  vpc_id   = module.firewall-vpc.vpc_id

}

resource "aws_alb_target_group_attachment" "firewall_attach1" {
  target_group_arn = aws_lb_target_group.firewall.arn
  target_id        = aws_instance.firewall1.id
  port             = 80
}


resource "aws_alb_target_group_attachment" "firewall_attach2" {
  target_group_arn = aws_lb_target_group.firewall.arn
  target_id        = aws_instance.firewall2.id
  port             = 80
}

