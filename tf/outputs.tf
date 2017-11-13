output "nodes-public-ips" {
  value = [
    "${aws_instance.swarm-node.*.public_ip}"
  ]
}

output "nodes-private-ips" {
  value = [
    "${aws_instance.swarm-node.*.private_ip}",
  ]
}

output "ns-servers" {
  value = [
    "${aws_route53_zone.aws-demo.name_servers}"
  ]
}
