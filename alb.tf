resource "aws_lb_target_group" "frontend" {
  name     = "webapp-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev-test.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "attach-webapp1" {
  count            = length(aws_instance.app-server)
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = element(aws_instance.app-server.*.id, count.index)
  port             = 80
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}
resource "aws_lb" "frontend" {
  name               = "frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http-sg.id]
  subnets            = [for subnet in aws_subnet.private : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}