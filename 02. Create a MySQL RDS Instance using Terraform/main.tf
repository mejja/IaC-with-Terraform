#provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#security_group
resource "aws_security_group" "ec2sg" {
  name = "EC2-SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

#EC2_Instance
resource "aws_instance" "ec2instance" {
  ami              = "ami-0c101f26f147fa7fd"
  instance_type    = "t2.micro"
  security_groups  = ["${aws_security_group.ec2sg.name}"]

  user_data = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install httpd -y
    echo "<html><h1> Welcome to Mbandi Land</h1></html>" >> /var/www/html/index.html
    echo "<html><h2> Where Technocrats Cloud solutions</h2></html>" >> /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = "MyEC2Server"
  }
}

#Creation_of_ec2_AMI
resource "aws_ami_from_instance" "ec2ami" {
  name               = "MyEC2Image"
  source_instance_id = aws_instance.ec2instance.id
}

resource "aws_instance" "ec2amiinstance" {
  ami              = aws_ami_from_instance.ec2ami.id
  instance_type    = "t2.micro"
  security_groups  = ["${aws_security_group.ec2sg.name}"]

  tags = {
    Name = "MyEC2AMIServer"
  }
}



