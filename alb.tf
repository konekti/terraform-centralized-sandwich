resource "aws_security_group" "alb" {
  name        = "public-web"
  description = "ALB and webservers SG"
  vpc_id      = module.app-vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.firewall-vpc.vpc_cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.firewall-vpc.vpc_cidr_block]
  }
}

resource "aws_lb" "alb" {
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id, module.app-vpc.default_security_group_id]
  subnets            = [module.app-vpc.private_subnets[0], module.app-vpc.private_subnets[1]]

  enable_deletion_protection = false
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.web.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "web" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.app-vpc.vpc_id
  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "2"
    interval            = "5"
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
  }
}

resource "aws_alb_target_group_attachment" "instance_attach1" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_instances_one[0].id
  port             = 80
}

/*
resource "aws_alb_target_group_attachment" "instance_attach2" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_instances_one[1].id
  port             = 80
}
*/

resource "aws_alb_target_group_attachment" "instance_attach3" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_instances_two[0].id
  port             = 80
}

/*
resource "aws_alb_target_group_attachment" "instance_attach4" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_instances_two[1].id
  port             = 80
}
*/
