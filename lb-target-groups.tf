resource "aws_lb_target_group" "frontend_zone_a_TG" {
  name     = "frontend-lb-tg-a"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default.id}"

  health_check {
    interval = 25
    protocol = "HTTP" #The protocol to use to connect with the target.
    path     = "/"
    matcher  = "200"  #The HTTP codes to use when checking for a successful response from a target
    timeout  = 10     #amount of time (s) during which no response means a failed health check 
  }

  target_type = "instance"
}

resource "aws_lb_target_group" "frontend_zone_b_TG" {
  name     = "frontend-lb-tg-b"      #name of the target group
  port     = 80                      #the port on which the target will reeive traffic
  protocol = "HTTP"                  #the protocal to use when routing traffic to the targets
  vpc_id   = "${aws_vpc.default.id}" #VPC identifier in which to create the target group 

  health_check {
    interval = 25     #approximate amount of time (s) between health checks of an individual target 
    protocol = "HTTP" #protocol to use when connecting to the target
    path     = "/"    #destination of the health checks requests
    matcher  = "200"
    timeout  = 10
  }

  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "zone_a_TGA" {
  target_group_arn = "${aws_lb_target_group.frontend_zone_a_TG.arn}" #ARN of the target group in which to register targets
  target_id        = "${aws_instance.ZONE_A_frontend.id}"            #instance id/container ID for and ECS container
  port             = 80                                              #port at which the target will receive traffic
}

resource "aws_lb_target_group_attachment" "zone_b_TGA" {
  target_group_arn = "${aws_lb_target_group.frontend_zone_b_TG.arn}"
  target_id        = "${aws_instance.ZONE_B_frontend.id}"
  port             = 80
}
