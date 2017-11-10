
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

# Tha master node is put in 1a of "eu-central" (defined in stack.tf)

resource "aws_instance" "swarm-node-master" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.ben_key_pair.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.aws-demo.id}"]
  private_ip                  = "10.200.0.10"
  associate_public_ip_address = true  # remove when loadbalancer is ready 
  subnet_id                   = "${aws_subnet.aws-demo-1a.id}"

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
    Name = "swarm-node-master"
  }

  # provisioner "file" {
  #   source      = "provision"
  #   destination = "/tmp"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod 755 /tmp/provision/provision-master.sh",
  #     "sudo /tmp/provision/provision-master.sh ${self.tags.Name}"
  #   ]
  # }

}

resource "aws_instance" "swarm-node-1a" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.ben_key_pair.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.aws-demo.id}"]
  subnet_id                   = "${aws_subnet.aws-demo-1a.id}"
  count                       = "${var.count-1a}"
  associate_public_ip_address = true

  # lifecycle {
  #   prevent_destroy = true
  # }

  connection {
    type = "ssh"
    user = "ubuntu"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags {
    Name = "swarm-node-1a-${count.index}"
    role = "${count.index < var.managers_in_zone ? "manager" : "worker"}"
  }

  # provisioner "file" {
  #   source      = "provision"
  #   destination = "/tmp"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod 755 /tmp/provision/provision-managers.sh",
  #     "sudo /tmp/provision/provision-managers.sh ${self.tags.Name} ${self.tags.role}"
  #   ]
  # }
}


resource "aws_instance" "swarm-node-1b" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.ben_key_pair.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.aws-demo.id}"]
  subnet_id                   = "${aws_subnet.aws-demo-1b.id}"
  count                       = "${var.count-1b}"
  associate_public_ip_address = true

  # lifecycle {
  #   prevent_destroy = true
  # }

  connection {
    type = "ssh"
    user = "ubuntu"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags {
    Name = "swarm-node-1b-${count.index}"
    role = "${count.index < var.managers_in_zone ? "manager" : "worker"}"
  }

  # provisioner "file" {
  #   source      = "provision"
  #   destination = "/tmp"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod 755 /tmp/provision/provision-managers.sh",
  #     "sudo /tmp/provision/provision-managers.sh ${self.tags.Name} ${self.tags.role}"
  #   ]
  # }
}
