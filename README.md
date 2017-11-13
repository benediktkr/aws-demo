# aws-demo

This is a demo of how to set up a Docker Swarm in AWS, running a simple container ([joshuaconner/hello-world-docker-bottle](https://github.com/joshuaconner/hello-world-docker-bottle)) and deployed with a CI/CD server. 

![the cloud](http://s2.quickmeme.com/img/a7/a736c13ea9c5ad4687ceaf214c95ba2b61c41805e1e5a73877f5fd6924abd6dc.jpg)

## What it does

This repo uses Terraform to deploy a VPC in AWS, with subnets in multiple AZs. It then deploys some EC2 instances, and installs a Docker Swarm on them. 

