resource "aws_security_group" "aws-demo" {
  name = "aws-demo"
  description = "Security group for EC2 instances running swarm"
  vpc_id = "${aws_vpc.aws-demo.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # For a hello world kind of app, until i make a loadbalancer
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # swarm-token.py
  ingress {
    from_port = 1337
    to_port = 1337
    protocol = "tcp"
    cidr_blocks = ["10.200.0.0/16"]
  }

  # swarm-mode
  ingress {
    from_port = 2377
    to_port = 2377
    protocol = "tcp"
    cidr_blocks = ["10.200.0.0/16"]
  }
  ingress {
    from_port = 7946
    to_port = 7946
    protocol = "tcp"
    cidr_blocks = ["10.200.0.0/16"]
  }
  ingress {
    from_port = 7946
    to_port = 7946
    protocol = "udp"
    cidr_blocks = ["10.200.0.0/16"]
  }
  ingress {
    from_port = 4789
    to_port = 4789
    protocol = "tcp"
    cidr_blocks = ["10.200.0.0/16"]
  }
  ingress {
    from_port = 4789
    to_port = 4789
    protocol = "udp"
    cidr_blocks = ["10.200.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "aws-demo"
  }



}
