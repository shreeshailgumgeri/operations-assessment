resource "aws_iam_role" "machine" {
  name = "${local.system_name}-machine-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "machine" {
  name_prefix = "${local.system_name}-instance"
  role = aws_iam_role.machine.name
}
