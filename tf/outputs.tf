output "nodes-public-ips" {
  value = [
    "${aws_instance.swarm-node-master.public_ip}",
    "${aws_instance.swarm-node-1a.*.public_ip}",
    "${aws_instance.swarm-node-1b.*.public_ip}"
  ]
}

output "nodes-private-ip" {
  value = [
    "${aws_instance.swarm-node-1a.*.private_ip}",
    "${aws_instance.swarm-node-1b.*.private_ip}"
  ]
}
