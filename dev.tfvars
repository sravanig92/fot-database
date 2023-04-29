region = "us-west-2a"
vpc_details = {
  cidr_block = "192.168.0.0/16"
  location   = "us-west-2a"
  name       = "firstvpc"
}
firstvpc_subnet_details = {
availability_zone = ["us-west-2a", "us-west-2b", "us-west-2a", "us-west-2b","us-west-2a","us-west-2b"]
  cidr_block        = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24","192.168.4.0/24","192.168.5.0/24"]
  name              = [ "web1","web2" ,"app1","app2","db1", "db2"]
  public_subnets = ["web1","web2"]
  private_subnets = ["app1","app2","db1", "db2"]
}

