#!/bin/bash

# Update system packages
sudo apt update -y
sudo apt upgrade -y

# Install necessary packages
sudo apt install -y python3 python3-pip python3-venv git apache2

# Stop and disable Nginx if running
sudo systemctl stop nginx
sudo systemctl disable nginx

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Clone the GitHub repository
cd /home/ubuntu || exit
rm -rf python-mysql-db-proj-1
git clone https://github.com/jayakumarm06/python-mysql-db-proj-1.git
cd python-mysql-db-proj-1 || exit

# Create and activate a virtual environment
sudo apt install python3-venv -y
python3 -m venv venv
. venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Start the application in the background and log output
nohup python3 -u app.py > app.log 2>&1 &
echo "Setup complete! Application is running."
