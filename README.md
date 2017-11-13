# aws-demo

This is a demo of how to set up a Docker Swarm in AWS.

![the cloud](http://s2.quickmeme.com/img/a7/a736c13ea9c5ad4687ceaf214c95ba2b61c41805e1e5a73877f5fd6924abd6dc.jpg)

## What it does

This repo uses Terraform to deploy a EC2 instances onto a VPC in AWS, with subnets in multiple AZs. Then it uses Ansible to provision a Docker Swarm on the nodes.

## Configure

The AWS creditials are read from `~/.aws/credentials`, rather than being kept in a `.tf` file. Use `aws configure` (install `aws-cli` with pip) to configure this.

For settings, take a look at `tf/stack.tf`. The format is not ideal, but you'll find the following (relatively self-explanatory) settings there, as well as the public key used for the instances.

```hcl
resource "aws_key_pair" "ben_key_pair" {
  key_name = "ben_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1y[...]ndqOEQ== benedikt@mathom"
}

variable "domainname" {
  default = "aws-demo.sudo.is"
}

variable "node_count" {
  default = 5
}

variable "manager_count" {
  default = 3
}

variable "instance_type" {
  default = "t2.nano"
}
```

## How to run

Just run terraform!

```shell
aws-demo$ terraform apply tf/
[....]
Outputs:

nodes-private-ips = [
    10.200.0.10,
    10.200.1.11,
    10.200.0.12
]
nodes-public-ips = [
    54.93.155.184,
    54.93.50.56,
    54.93.241.144
]
ns-servers = [
    ns-1319.awsdns-36.org,
    ns-1542.awsdns-00.co.uk,
    ns-62.awsdns-07.com,
    ns-748.awsdns-29.net
]
```

The nameservers are outputted since because it's assumed that the domain used is a subdoamain, and need to be delegated to AWS. Here is what the zone file should look like to delegate it:

```bind
aws-demo.sudo.is.	NS	ns-1319.awsdns-36.org.
aws-demo.sudo.is.	NS	ns-1512.awsdns-00.co.uk.
aws-demo.sudo.is.	NS	ns-62.awsdns-07.com.
aws-demo.sudo.is.	NS	ns-748.awsdns-29.net.
```

If the domain is delegated with the `NS` records correct, you can use the DNS name to SSH to one of the instances to check that everything is working as supposed (otherwise you can use the IP outputed by terraform).

```shell
aws-demo$ ssh swarm-node-1.aws-demo.sudo.is
ubuntu@swarm-node-0:~$ sudo docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
1nfhj6nuv3z9xnlug91my15h0     swarm-node-3        Ready               Active
7t5swjgnqu9d3rzh7blven66m     swarm-node-4        Ready               Active
9mpyjxznwf5tdawrlv8xxfwo8     swarm-node-2        Ready               Active              Reachable
gumqc06pqtn6vnnoa1fxs5bt0 *   swarm-node-0        Ready               Active              Leader
n2fflejq35acvil36xsh6ashy     swarm-node-1        Ready               Active              Reachable
```

# Todo

Use a CI/CD to run a simple container ([joshuaconner/hello-world-docker-bottle](https://github.com/joshuaconner/hello-world-docker-bottle)) and deployed with a CI/CD server.

# Improvements

I tried to keep all of the logic in Terraform, but it feels like it belongs somewhere else --- even independently. Also, it would be better if you could just specify a total number of nodes, and an automatically correct ratio of managers/workers would be selected automatically.
