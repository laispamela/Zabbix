provider "AWS" {
    region = "us-east-1"
    shared_config_files=["./aws/config"]
    shared_credentials_files=["./aws/config"]
}

resource "aws_instance" "ec2_instance" {
    ami           = "ami-0e001c9271cf7f3b9"
    instance_type = "t2.medium"
    subnet_id     = "subnet-0abb81be9708ef090" # ID da Subnet
    vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

}
#SG
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg-5"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = "vpc-0bf7f96dcf5869ed4"

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
}
