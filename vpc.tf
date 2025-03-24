resource "aws_vpc" "main" {
    cidr_block = "172.18.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "spotifind-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "spotifind-igw"
    }
}

# for our nat instance
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "172.18.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "spotifind-public-subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.idß
}