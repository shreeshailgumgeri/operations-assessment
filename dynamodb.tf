resource "aws_dynamodb_table" "machine_properties" {
  hash_key = "MachineID"
  name = "${local.system_name}-MachineState"
  attribute {
    name = "MachineID"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}
