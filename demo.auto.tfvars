   demo = [
      { #0
          region = "us-west-2"
      },
      { #1
          ami = "ami-0ee66876"
      },
      { #2
          instance = "t2.micro"
      },
      { #3
          keys = "xxxxx-corporate-ansible-gateway"
      },
      { #4
          cidr_vpc = "10.0.0.0/16"
      },
      { #5
          cidr_subnet = "10.0.1.0/24"
      },
      { #6
          cidr_ingress_elb = "0.0.0.0/0" # from anywhere
      },
      { #7
          cidr_egress_elb = "0.0.0.0/0" # to anywhere
      },
      { #8
          cidr_internet_destination = "0.0.0.0/0"
      },
      { #9
            cidr_ingress_ssh = "0.0.0.0/0" # from anywhere - security reasons use /32 with specific IP address
      },
      { #10
            cidr_ingress_http = "10.0.0.0/16" # http access from vpc
      },
      { #11
            cidr_egress_internet = "0.0.0.0/0" # cidr internet access
      },
      { #12
            private_key_with_path = "/Users/xxxx/.ssh/xxxxx-corporate-ansible-gateway" # ssh access
      }
   ]
