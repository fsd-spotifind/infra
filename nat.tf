module "fck-nat" {
    source = "RaJiska/fck-nat/aws"

    name = "spotifind-nat"
    vpc_id = aws_vpc.main.id
    subnet_id = aws_subnet.public_a.id
    use_cloudwatch_agent = true

    update_route_tables = true
    route_tables_ids = {
        "spotifind-private-rt-a" = aws_route_table.private_a.id
        "spotifind-private-rt-b" = aws_route_table.private_b.id
    }
}