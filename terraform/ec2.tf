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
    private_key = base64decode(var.private_key_content)
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
     "mkdir -p /home/ubuntu/k8s",
     "mkdir -p /home/ubuntu/bootstrap",
      # Fix ownership
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/k8s",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/bootstrap",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../k8s"
    destination = "/home/ubuntu/k8s"       # change from /home/ec2-user/k8s
  }

    provisioner "file" {
    source      = "${path.module}./bootstrap"
    destination = "/home/ubuntu/bootstrap"       # change from /home/ec2-user/k8s
  }

  # Run bootstrap.sh to install k3s + Argo CD
  provisioner "remote-exec" {
    inline = [
      # Ensure scripts are executable
      "chmod +x /home/ubuntu/k8s || true",
      "chmod +x /home/ubuntu/bootstrap || true",
      # Run bootstrap
      "sudo /home/ubuntu/bootstrap"
    ]
  }
}