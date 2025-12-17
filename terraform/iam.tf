resource "aws_iam_role" "ec2_role" {
  name = "k3s-argocd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "secrets_policy" {
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ec2_role.name
}
