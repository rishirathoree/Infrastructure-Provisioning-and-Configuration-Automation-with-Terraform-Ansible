module "aws-app" {
    source = "../../modules"
    environment = var.environment
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    ami = var.ami
    instance_type_agent = var.instance_type_agent
    instance_type_jenkins = var.instance_type_jenkins
    key_name = var.key_name
}