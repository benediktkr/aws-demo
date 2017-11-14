resource "aws_elb" "aws-demo-helloworld" {
  name               = "aws-demo-helloworld"

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    target              = "HTTP:8080/"
    interval            = 10
    timeout             = 2
  }

  instances                 = ["${aws_instance.swarm-node.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 400
  subnets                   = ["${aws_subnet.aws-demo.*.id}"]
  security_groups           = ["${aws_security_group.aws-demo-elb.id}"]

  tags {
    Name = "aws-demo-helloworld"
  }
}
