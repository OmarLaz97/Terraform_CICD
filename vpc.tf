module "iaac_testing_public_vpc" {
  source = "./modules/terraform-aws-vpc/"

  name = "iaac_testing_public_vpc"
  cidr = "10.3.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.3.1.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "public_web_subnet"
  }

  vpc_tags = {
    Name = "public_vpc"
  }
}