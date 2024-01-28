provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "shahar_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "shahar"
  }
}

resource "aws_subnet" "shahar_subnet" {
  vpc_id            = aws_vpc.shahar_vpc.id
  cidr_block        = var.vpc_id_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "shahar"
  }
}

resource "aws_internet_gateway" "shahar_igw" {
  vpc_id = aws_vpc.shahar_vpc.id

  tags = {
    Name = "shahar"
  }
}

resource "aws_route_table" "shahar_rt" {
  vpc_id = aws_vpc.shahar_vpc.id

  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.shahar_igw.id
  }

  tags = {
    Name = "shahar"
  }
}

resource "aws_route_table_association" "shahar_rta" {
  subnet_id      = aws_subnet.shahar_subnet.id
  route_table_id = aws_route_table.shahar_rt.id
}

resource "aws_security_group" "shahar_sg" {
  vpc_id = aws_vpc.shahar_vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shahar"
  }
  }

resource "aws_instance" "shahar_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.shahar_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.shahar_sg.id]
  key_name      = "sharap"
  user_data = file("script.sh")
  
   
  provisioner "file" {
    source      = "files/Dockerfile"
    destination = "/home/ubuntu/Dockerfile"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Or appropriate user for your AMI
      private_key = file(var.pem_file)
      host        = self.public_ip
    }
  }
  
  provisioner "file" {
    source      = "files/app.py"
    destination = "/home/ubuntu/app.py"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Or appropriate user for your AMI
      private_key = file(var.pem_file)
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "files/docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Or appropriate user for your AMI
      private_key = file(var.pem_file)
      host        = self.public_ip
    }
  }
  
  provisioner "file" {
    source      = "files/requirements.txt"
    destination = "/home/ubuntu/requirements.txt"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Or appropriate user for your AMI
      private_key = file(var.pem_file)
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "files/default.conf"
    destination = "/home/ubuntu/default.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Or appropriate user for your AMI
      private_key = file(var.pem_file)
      host        = self.public_ip
    }
  } 

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /home/ubuntu/app",
      "sudo mv app.py Dockerfile docker-compose.yml requirements.txt default.conf app",
      "cd app"
    ]
  }
     connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.pem_file)}"
      host        = "${self.public_ip}"
    }
  
  tags = {
    Name = "shahar"
  }
}

output "instance_ip" {
  value = aws_instance.shahar_instance.public_ip
}
