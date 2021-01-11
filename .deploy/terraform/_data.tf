
data aws_vpc "selected" {
    default = true
}

data aws_subnet_ids "default" {
  vpc_id = data.aws_vpc.selected.id
}

data aws_caller_identity "current" {}

data aws_region "current" {}
