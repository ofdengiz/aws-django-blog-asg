#!/bin/bash -x
# EC2 bootstrap — pulls this repo and runs the Django app in dev mode.
# Real deployments should use an IAM role + gunicorn/nginx, not a cleartext
# token and `manage.py runserver`.

apt-get update -y
apt-get install git -y
apt-get install python3 -y
cd /home/ubuntu/

# In real use, inject this from AWS SSM Parameter Store / Secrets Manager
# rather than baking it into user_data.
TOKEN="***REDACTED***"
git clone https://$TOKEN@github.com/ofdengiz/aws-django-blog-asg.git
cd /home/ubuntu/aws-django-blog-asg
apt install python3-pip -y
apt-get install python3.7-dev default-libmysqlclient-dev -y
pip3 install -r requirements.txt
cd /home/ubuntu/aws-django-blog-asg/src
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80
