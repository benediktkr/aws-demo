resource "aws_route53_zone" "aws-demo" {
  name = "aws-demo.sudo.is"

  tags {
    Environment = "aws-demo"
  }
}

resource "aws_route53_record" "aws-demo-ns" {
  zone_id = "${aws_route53_zone.aws-demo.zone_id}"
  name    = "aws-demo.sudo.is"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.aws-demo.name_servers.0}",
    "${aws_route53_zone.aws-demo.name_servers.1}",
    "${aws_route53_zone.aws-demo.name_servers.2}",
    "${aws_route53_zone.aws-demo.name_servers.3}",
  ]
}

resource "aws_route53_record" "swarm-nodes" {
  count   = "${var.node_count}"
  zone_id = "${aws_route53_zone.aws-demo.zone_id}"
  name    = "swarm-node-${count.index}" 
  type    = "CNAME"
  records = ["${element(aws_instance.swarm-node.*.public_dns, count.index)}"]
  ttl     = 360
}

