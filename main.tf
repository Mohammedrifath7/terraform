# <<<<<<< HEAD
provider "aws"{
    region = "ap-south-1"  
    alias = "env"
}
resource "aws_vpc" "my_vpc"{
    cidr_block = "10.10.0.0/16"
    tags = {
        Name : "my_vpc"
    }
}


resource "aws_subnet" "subnet-task2" {
  vpc_id = aws_vpc.my_vpc.id
  
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "task-2-Subnet"
  }
}

resource "aws_internet_gateway" "task2_IGW" {
  vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "task-2-IGW"
    }
}

resource "aws_route_table" "task2_route_table" {
    vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "task-2-route-table"
  }
}

resource "aws_route" "task2_route" {
  
    route_table_id = aws_route_table.task2_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task2_IGW.id
}

resource "aws_route_table_association" "associate" {
    route_table_id = aws_route_table.task2_route_table.id
  subnet_id = aws_subnet.subnet-task2.id

}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
# >>>>>>> 7587a0a3f8062389587c4e38d9079acd6c7eb4a2
}