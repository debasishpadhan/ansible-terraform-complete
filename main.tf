provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "nginx" {
  name   = "nginx_access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = "ami-0851b76e8b1bce90b"
  instance_type               = "t2.nano"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  key_name                    = "onekeypair"
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/onekeypair.pem")
    host        = aws_instance.nginx.public_ip
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i ${aws_instance.nginx.public_ip}, --private-key /var/lib/jenkins/onekeypair.pem copy.yaml"
  }
}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}
