resource "aws_instance" "Shackshine-EC2-Instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  # User data to set up a simple web server
  user_data = <<-EOF
              #!/bin/bash
              sudo apt install nginx -y
              sudo apt install git -y
              sudo git clone https://github.com/csarat424/ShackShine_O2EBrands.git
              sudo rm -rf /var/www/html/index.nginx-debian.html
              sudo cp index.html /var/www/html/index.nginx-debian.html
              sudo cp styles.css /var/www/html/style.css
              sudo cp script.js /var/www/html/script.js
              sudo systemctl restart nginx
              EOF

  tags = {
    Name = var.instance_name
  }
}


# Output the public IP for accessing the web server
output "instance_public_ip" {
  value = aws_instance.Shackshine-EC2-Instance.public_ip
}
