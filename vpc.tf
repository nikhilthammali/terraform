//Provider Name and EC2 resource creation
provider "aws"{
  region = "ap-south-1"
  profile = "default"
}

resource "aws_instance" "ec2-demo" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    key_name = "vpc-key"
   //vpc_security_group_ids = ["${aws_security_group.sg-demo.id}"]
   subnet_id = "${aws_subnet.subnet-demo.id}"
}

//creating a VPC
resource "aws_vpc" "vpc-demo" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "vpc-demo"
    }
  
}

//creating subnet
resource "aws_subnet" "subnet-demo" {
    vpc_id = "${aws_vpc.vpc-demo.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "subnet-demo"
    }
  
}


//Creating a Internet Gateway
resource "aws_internet_gateway" "igw-demo" {
    vpc_id = "${aws_vpc.vpc-demo.id}"
    tags = {
      Name = "igw-demo"

  }
}

//Create a route table 
resource "aws_route_table" "rt-demo" {
    vpc_id = "${aws_vpc.vpc-demo.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw-demo.id}"
    }
    tags = {
      Name = "rt-demo"
    }
}

//Associate subnet with routetable
 resource "aws_route_table_association" "rt_association-demo" {
    subnet_id = "${aws_subnet.subnet-demo.id}"
    route_table_id = "${aws_route_table.rt-demo.id}"

}

resource "aws_security_group" "sg-demo" {
    name = "{sg-demo}"
    vpc_id = "${aws_vpc.vpc-demo.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }


 ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh-sg"

    }

}


