# https://thirdiron.com/dev-team/one-step-beyond-intro-tutorials-configure-terraform-server-https-ssl/
resource "aws_security_group" "security_group_main_load_balancer" {
  name        = "security_group_main_load_balancer"
  description = "Security groups for main load balancer used in fullstack deployment to aws project."
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Terraform requires to explicitly specify egress rule that allows outbound traffic to the internet.
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main_load_balancer" {
  name               = "MainLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group_main_load_balancer.id]
  subnets            = [aws_subnet.public_subnet_eu_west_1a.id, aws_subnet.public_subnet_eu_west_1b.id]
}

resource "aws_lb_listener" "main_load_balancer_http_listener" {
  load_balancer_arn = aws_lb.main_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_fargate_target_group.arn
  }

  # Port forwarding to HTTPS cannot be done without TLS certificate.
  #  default_action {
  #    type = "redirect"
  #
  #    redirect {
  #      port        = "443"
  #      protocol    = "HTTPS"
  #      status_code = "HTTP_301"
  #    }
  #  }
}

# HTTPS listener must wait for TLS certificate validation.
#resource "aws_lb_listener" "main_load_balancer_https_listener" {
#  load_balancer_arn = aws_lb.main_load_balancer.arn
#  port              = 443
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = ""
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ecs_fargate_target_group.arn
#  }
#}

resource "aws_lb_target_group" "ecs_fargate_target_group" {
  name        = "EcsFargateTargetGroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}
