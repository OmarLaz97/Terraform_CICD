# Terraform_CICD
## _Terraform and Ansible for my CICD project_

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## Features

- Create AWS VPC, Security Group, Key and a t2.medium EC2 using Terraform
- Provision and install all dependencies on the EC2 using Ansible

## Tech

The application uses a number of open source projects to work properly:

- [Terraform] - IaaC tool!
- [Ansible] - Infrastructure provisioning tool!

## Installation

The application requires [Terraform](https://www.terraform.io/downloads.html) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) to run

## IAM Role Key

Please create an IAM role on your AWS account and add the AWS_ACCESS_KEY and AWS_SECRET_KEY to Terraform_CICD/terraform.tfvars
## NB: the t2.medium machine will cost around 0.2$/hour

## Run the app

The application is very easy to install and deploy in a Docker container.

Just by running a single command you will be able to create and deploy the an application using minikube on the ec2 machine

```sh
cd Terraform_CICD
terraform init
terraform apply
```

This will create the AWS ec2, will add your ip to the security group and will output the ip of the machine created


Verify the deployment by navigating to your server address in
your preferred browser.

```sh
<instance_IP>
```

