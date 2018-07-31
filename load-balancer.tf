resource "aws_lb" "frontend-load-balancer" {
  name               = "frontend-load-balancer"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.load_balancer_SG.id}"]
  subnets            = ["${aws_subnet.10_0_1_0_public_sbnt.id}", "${aws_subnet.10_0_3_public_sbnt2.id}"]
}

#listener for the load balancer
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = "${aws_lb.frontend-load-balancer.arn}"
  port              = 80                                     #port at which the load balancer is listening
  protocol          = "HTTP"                                 #connection protocol from clients to load balancer 

  default_action {
    target_group_arn = "${aws_lb_target_group.frontend_zone_a_TG.arn}" #arn of the target to which to route traffic by default
    type             = "forward"                                       #type of routing action
  }
}

#rules attached to the listeners
resource "aws_lb_listener_rule" "path-based-forwrding-rule" {
  listener_arn = "${aws_lb_listener.frontend_listener.arn}" #The ARN of the listener to which to attach the rule
  priority     = 100                                        #priority of the rule between 1-50000. A listener can't have multiple rules with same priority

  action {
    type             = "forward"                                       #type of routing action
    target_group_arn = "${aws_lb_target_group.frontend_zone_a_TG.arn}" #target group to which to route the traffic
  }

  condition {
    field  = "path-pattern" #The name of the field. Must be one of path-pattern for path based routing or host-header for host based routing
    values = ["/"]          #pattern to match. max of 1
  }
}
