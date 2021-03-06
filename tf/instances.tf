# Might belong more in a different file
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "swarm-node" {
  count                       = "${var.node_count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.ben_key_pair.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.aws-demo-swarm.id}"]
  private_ip                  = "10.200.${count.index % 3}.${10 + count.index}"
  associate_public_ip_address = true
  subnet_id                   = "${element(aws_subnet.aws-demo.*.id, count.index)}"

  # lifecycle {
  #   prevent_destroy = true
  # }

  connection {
    type = "ssh"
    user = "ubuntu"
  }

  root_block_device = {
    volume_type = "gp2"
    volume_size = 20
  }

  tags {
    Name = "swarm-node-${count.index}"
    role = "${count.index < var.manager_count ? "manager" : "worker"}"
    ismaster = "${count.index == 0 ? "true" : "false" }"
  }


  # A remote-exec wait untils the instance is ready
  # (also, we need python for ansible, but this is faster than sleeping otherwise)
  provisioner "remote-exec" {
    inline = [
      "echo \"hello from remote\"",
      "sleep 3",
      "sudo apt-get update",
      "sudo apt-get install -y python"
    ]
  }

  # And then we run ansible
  provisioner "local-exec" {
    command = <<EOF
ANSIBLE_HOST_KEY_CHECKING=False \
ansible-playbook \
    -u ubuntu \
    -i '${self.public_ip},' \
    ./ansible/swarm-master.yml \
    --extra-vars '{"myhostname": "${self.tags.Name}", "swarmrole": "${self.tags.role}", "ismaster": "${self.tags.ismaster}", "masterip": "${aws_instance.swarm-node.0.private_ip}", "node_count": "${var.node_count}", "myid": "${count.index}", "services": [ ${jsonencode(var.hello-world-app)}, ]}'
EOF
  }
}
