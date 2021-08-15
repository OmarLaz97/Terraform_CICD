resource "aws_network_interface" "iaac_testing_ni_web_pub" {
  count     = 1
  subnet_id = module.iaac_testing_public_vpc.public_subnets[0]

  attachment {
    instance     = module.iaac_testing_ec2_web_pub.id[0]
    device_index = 1
  }

  depends_on = [
    module.iaac_testing_ec2_web_pub
  ]

  tags = {
    "Name" = "iaac_testing_ni_web_pub"
  }

}


resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "iaac_testing_ec2_web_pub_key" {
  source = "./modules/terraform-aws-key-pair"

  key_name   = "ec2_testing_key"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name = "web_server_key"
  }
}

module "iaac_testing_ec2_web_pub" {
  source = "./modules/terraform-aws-ec2-instance"

  key_name = "ec2_testing_key"

  instance_count = 1

  name                        = "iaac_testing_ec2_web_pub"
  ami                         = "ami-09e67e426f25ce0d7"
  instance_type               = "t2.medium"
  subnet_id                   = module.iaac_testing_public_vpc.public_subnets[0]
  associate_public_ip_address = true

  vpc_security_group_ids = [module.iaac_testing_web_sg.security_group_id]

  enable_volume_tags = false

  tags = {
    "Name" = "IAAC WEB SERVER"
  }

}

resource "null_resource" "my_instance" {

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    instance_ids = module.iaac_testing_ec2_web_pub.id[0]
  }

  # Running the remote provisioner like this ensures that ssh is up and running
  # before running the local provisioner

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready...'"]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("./ec2_testing_key.pem")
      host =  element(module.iaac_testing_ec2_web_pub.public_ip, 0)
    }
  }

  provisioner "local-exec" {
    command = "sudo ansible-playbook -vv -i ${element(module.iaac_testing_ec2_web_pub.public_ip, 0)}, --private-key ./ec2_testing_key.pem -u ubuntu ./ansible/playbook.yml --ask-vault-pass"
  }
}

resource "local_file" "private_key" {
    content  = tls_private_key.this.private_key_pem
    filename = "ec2_testing_key.pem"
}

output "instance_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
  depends_on = [
    tls_private_key.this
  ]
}

output "instance_IP" {
  value     = module.iaac_testing_ec2_web_pub.public_ip
}