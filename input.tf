variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_details" {
  type = object({
    name       = string
    location   = string
    cidr_block = string
  })
}

variable "firstvpc_subnet_details" {
  type = object({
    name              =list(string)
    availability_zone = list(string)
    cidr_block        = list(string)
    public_subnets = list(string)
    private_subnets = list(string)
  })
default = {
  availability_zone = ["us-west-2a", "us-west-2b", "us-west-2a", "us-west-2b","us-west-2a","us-west-2b"]
  cidr_block        = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24","192.168.4.0/24","192.168.5.0/24"]
  name              = [ "web1","web2" ,"app1","app2","db1", "db2"]
    public_subnets  = []
    private_subnets = ["app1", "app2", "db1", "db2"]
  }
}