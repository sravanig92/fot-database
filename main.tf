resource "aws_vpc" "set" {
  cidr_block = var.vpc_details.cidr_block

  tags = {
    name = var.vpc_details.name
  }
}


resource "aws_subnet" "subnet" {
  count             = length(var.firstvpc_subnet_details.cidr_block)
  cidr_block        = var.firstvpc_subnet_details.cidr_block[count.index]
  vpc_id            = aws_vpc.set.id
  availability_zone = var.firstvpc_subnet_details.availability_zone[count.index]

  tags = {
    name = var.firstvpc_subnet_details.name[count.index]
  }
  depends_on = [aws_vpc.set]
}


resource "aws_internet_gateway" "setgate" {
  vpc_id = aws_vpc.set.id

  tags = {
    name = "setgate"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.set.id

  tags = {
    name = "private" 
  }
  depends_on = [ aws_subnet.subnet ]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.set.id

  tags = {
    name = "public"
  }
  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.setgate.id
  }
  depends_on = [ aws_subnet.subnet ]
}


data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.firstvpc_subnet_details.public_subnets

  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.set.id]
  }
  

  depends_on = [
    aws_subnet.subnet
  ]

}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = var.firstvpc_subnet_details.private_subnets
  }

  filter {
    name   = "vpc-id"
    values =[ aws_vpc.set.id]
  }

  depends_on = [
    aws_subnet.subnet
  ]

}


resource "aws_route_table_association" "public_associations" {
  count          = length(data.aws_subnets.public.ids)
  gateway_id = aws_internet_gateway.setgate.id
  route_table_id = aws_route_table.public.id
  subnet_id      = data.aws_subnets.public.ids[count.index]

}

resource "aws_route_table_association" "private_associations" {
  count          = length(data.aws_subnets.private.ids)
  route_table_id = aws_route_table.private.id
  subnet_id      = data.aws_subnets.private.ids[count.index]

  depends_on = [
    data.aws_subnets.private
  ]

}
