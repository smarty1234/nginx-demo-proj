#specifiy the provider and access details
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${lookup(var.demo[0], "region")}"
}

# Create a VPC  for the NGINX web server
resource "aws_vpc" "default" {
  cidr_block = "${lookup(var.demo[4], "cidr_vpc")}"
}

# Create an internet gateway for public subnet
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

#  route table for internet access
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "${lookup(var.demo[8], "cidr_internet_destination")}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet  to attach our instance
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${lookup(var.demo[5], "cidr_subnet")}"
  map_public_ip_on_launch = true
}

# create a  security group for the ELB  for web access
resource "aws_security_group" "elb" {
  name        = "nginx_demo_proj_elb"
  description = "For Project Demo"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = [ "${lookup(var.demo[6], "cidr_ingress_elb")}" ]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = [ "${lookup(var.demo[7], "cidr_egress_elb")}" ]
  }
}

#  security group for ssh access and http
resource "aws_security_group" "default" {
  name        = "nginx-demo-proj"
  description = "NGINX DEMO PROJ"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access - for this demo - Any where
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = [ "${lookup(var.demo[9], "cidr_ingress_ssh")}" ]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = [ "${lookup(var.demo[10], "cidr_ingress_http")}" ]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = [ "${lookup(var.demo[11], "cidr_egress_internet")}" ]
  }
}

resource "aws_elb" "webserver" {
  name = "nginx-demo-proj-elb"

  subnets         = ["${aws_subnet.default.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.webserver.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}


resource "aws_instance" "webserver" {
  ami           = "${lookup(var.demo[1], "ami")}"
  instance_type = "${lookup(var.demo[2], "instance")}"
  key_name = "${lookup(var.demo[3], "keys")}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"
#  associate_public_ip_address = true
 connection {
    user = "ubuntu"
    private_key =  "${file("${lookup(var.demo[12], "private_key_with_path")}")}"
  }
  provisioner "file" {
   source      = "index.nginx-debian.html"
   destination = "/tmp/index.nginx-debian.html"
 }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo cp /tmp/index.nginx-debian.html /var/www/html",
      "sudo service nginx start",
    ]
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.webserver.id}"
}
