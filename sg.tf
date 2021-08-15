data "external" "myipaddr" {
    program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

module "iaac_testing_web_sg" {
    source = "./modules/terraform-aws-security-group"

    name        = "iaac_testing_web_sg"
    description = "Security group which is used for the web server in the public vpc"
    vpc_id      = module.iaac_testing_public_vpc.vpc_id

    tags = {
        Name = "web-sg"
    }

    ingress_with_cidr_blocks = [
        {
            cidr_blocks = "${data.external.myipaddr.result.ip}/32"
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            description = "SSH rule for the web server in the public VPC"
        },
        {
            cidr_blocks = "${data.external.myipaddr.result.ip}/32"
            from_port   = 8443
            to_port     = 8443
            protocol    = "tcp"
            description = "TCP rule to access the minikube api server only from my IP"
        },
        {
            cidr_blocks = "0.0.0.0/0"
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            description = "HTTP rule for the web server in the public VPC"
        }
  ]

  egress_with_cidr_blocks = [
      {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = "0.0.0.0/0"
      }
  ]

  egress_with_ipv6_cidr_blocks = [
    {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        ipv6_cidr_blocks = "::/0"
    } 
  ]

    ingress_with_ipv6_cidr_blocks = [
        {
            ipv6_cidr_blocks = "::/0"
            from_port        = 80
            to_port          = 80
            protocol         = "tcp"
            description      = "HTTP rule for the web server in the public VPC"
        }
    ]
}