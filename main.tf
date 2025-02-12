data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "glenn_dynamodb_read_policy" {
  name        = "glenn-dynamodb-read-policy"
  description = "Policy to allow all read and list operations on DynamoDB table glenn-bookinventory"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:ListTables",
          "dynamodb:DescribeTable",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:${data.aws_caller_identity.current.account_id}:table/glenn-bookinventory"
      }
    ]
  })
}

resource "aws_iam_role" "glenn_dynamodb_read_role" {
  name               = "glenn-dynamodb-read-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glenn_dynamodb_read_role_attachment" {
  role       = aws_iam_role.glenn_dynamodb_read_role.name
  policy_arn = aws_iam_policy.glenn_dynamodb_read_policy.arn
}