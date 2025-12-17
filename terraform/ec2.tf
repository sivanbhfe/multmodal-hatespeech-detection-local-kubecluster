resource "aws_instance" "k3s" {
  ami                    = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 ap-south-1
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.profile.name

  user_data = file("bootstrap/install_k3s.sh")

  tags = {
    Name = "k3s-argocd"
  }
}