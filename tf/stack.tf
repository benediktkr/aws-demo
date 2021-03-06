provider "aws" {
  # No credentials specified, tf will check ~/.aws/credentials
  region = "eu-central-1"
}

resource "aws_key_pair" "ben_key_pair" {
  key_name = "ben_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/iaS4ouXCPD80OfYHFIHIM+w9ZM5yTEeLEADAMGSyYMS/EABx5KFAk9Go6va51x2UL3dl/q110MWHPe7lYelhUMD+lqCFGCw7ZS87xZvXdrzp9QVNWC4cUaUGqxu4WhLAqmgTrcSG0V8luRGpyKx9nTwm8/n3um8xMx3CVuEW1t2hVhwPfRrXUzZ7RisQ1cyfHReqSDCW40U1JeMyKy0SqQOzKRB91cLaOjJUeCk/BZGgGukU83R5Wz4cG7U+056U1y+5Rb2qcgKAVn44mmdfDuyUF6y2XnXp7Z6KMR4R/SJvj94FAuAN1e9tjMc41yTtgYI+9We2uuLGtEhZTSvvXkEx5kOfuA8OVJKgVV0VO6YcJMQD47k2BXNcx+YzZ3XaEtqKY0DZ3vI3+5tFXohmVrvJxEna5QWF7B7yN+dH1HethPd7ZAIARezmRi6mkGnE5UURgJLqgMkKdkZJoN1ZgQvSb+ZoOhUdEHbxoJI8+LRajJuahSalIjuZHdjK/02TUPyHnhzir47LC47gcp0NXxcrD87ASXserR9IvG5Vr+mlW/YXv8wpps2jzR+0cyfxJwPsCn+wTHWvSO0I3obyRLtkBNjmlz+wTv6jBn8XVQ2A1QSnzfAiCSp85gBAXfe14XfJuZgOHBuUcGFEcNSztM5SYxVdUXib9+q4ndqOEQ== benedikt@mathom"
}

# Settings ?

variable "zones" {
  default = [
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c"
  ]
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

variable "hello-world-app" {
  default = {
    name = "joshuaconner/hello-world-docker-bottle"
    port = 8080
  }
}
