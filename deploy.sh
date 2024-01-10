#!/bin/bash

# Check if the IP address is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <EC2_INSTANCE_IP>"
    exit 1
fi

# EC2 instance IP
EC2_INSTANCE_IP="$1"
#
SSH_KEY="$2"
# Update package lists and install Nginx
ssh -i $SSH_KEY ec2-user@$EC2_INSTANCE_IP 'sudo yum update -y && sudo amazon-linux-extras install httpd -y && sudo systemctl start httpd && sudo systemctl enable httpd'

# Deploy HTML page
ssh -i $SSH_KEY ec2-user@$EC2_INSTANCE_IP 'echo "<html><head><title>Deployed by Script</title></head><body><h1>Hello from EC2!</h1></body></html>" | sudo tee /var/www/html/index.html'

# Restart Nginx for changes to take effect
ssh -i $SSH_KEY ec2-user@$EC2_INSTANCE_IP 'sudo systemctl restart httpd'

echo "Web server installation and HTML page deployment completed on EC2 instance at $EC2_INSTANCE_IP"
