module "aws-app" {
  source                = "../../modules"
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  ami                   = var.ami
  instance_type_agent   = "t3.micro"
  instance_type_jenkins = "c7i-flex.large"
  key_name              = var.key_name
}
