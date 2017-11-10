resource "aws_vpc" "aws-demo" {
  cidr_block = "10.200.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "aws-demo"
  }
}

resource "aws_internet_gateway" "aws-demo-gw" {
  vpc_id = "${aws_vpc.aws-demo.id}"

  tags {
    Name = "aws-demo-gw"
  }
}

resource "aws_default_route_table" "aws-demo" {
  default_route_table_id = "${aws_vpc.aws-demo.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.aws-demo-gw.id}"
  }

  tags {
    Name = "aws-demo"
  }
}


resource "aws_subnet" "aws-demo-1a" {
  vpc_id = "${aws_vpc.aws-demo.id}"
  cidr_block = "10.200.0.0/24"
  availability_zone = "eu-central-1a"

  tags {
    Name = "aws-demo-1a"
  }
}

resource "aws_subnet" "aws-demo-1b" {
  vpc_id = "${aws_vpc.aws-demo.id}"
  cidr_block = "10.200.1.0/24"
  availability_zone = "eu-central-1b"

  tags {
    Name = "aws-demo-1b"
  }
}
