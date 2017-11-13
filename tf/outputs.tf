output "nodes-public-ips" {
  value = [
    "${aws_instance.swarm-node.*.public_ip}"
  ]
}

output "nodes-private-ip" {
  value = [
    "${aws_instance.swarm-node.*.private_ip}",
  ]
}

