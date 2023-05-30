resource "aws_security_group" "http-sg" {
  name        = "allow_http_access"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "from any"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "webapp-1-sg"
  }
}
data "aws_ami" "amzn_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20230504.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}
resource "aws_instance" "app-server" {
  count                  = length(var.subnet_cidr_private)
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amzn_ami.id
  vpc_security_group_ids = [aws_security_group.http-sg.id]
  subnet_id              = element(aws_subnet.private.*.id, count.index)
  associate_public_ip_address = true
  tags = {
    Name = "webapp-${count.index + 1}"
  }
  user_data = file("user_data.sh")
}