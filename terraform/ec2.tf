resource "aws_instance" "k3s" {
  ami = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 (ap-south-1)
  instance_type = "t3.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  # user_data = file("${path.module}/bootstrap/bootstrap.sh")

  tags = {
    Name = "k3s-argocd"
  }

  connection {
    type = "ssh"
    user = "ubuntu"                  # Ubuntu AMI default user
    private_key = file(var.private_key_path)
    host = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/../k8s"
    destination = "/home/ubuntu/k8s"       # change from /home/ec2-user/k8s
  }

  # Run bootstrap.sh to install k3s + Argo CD
  provisioner "remote-exec" {
    inline = [
      # Ensure scripts are executable
      "chmod +x /home/ubuntu/k8s || true",
      "chmod +x /home/ubuntu/terraform/bootstrap/bootstrap.sh || true",

      # Fix ownership
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/k8s",

      # Run bootstrap
      "/home/ubuntu/terraform/bootstrap/bootstrap.sh"
    ]
  }
}