module "fck-nat" {
    source = "RaJiska/fck-nat/aws"

    name = "spotifind-nat"
    vpc_id = aws_vpc.main.id
    subnet_id = aws_subnet.public.id
    use_cloudwatch_agent = true

    update_route_tables = true
    route_tables_ids = {
        "spotifind-public-rt" = aws_route_table.public.id
    }
}