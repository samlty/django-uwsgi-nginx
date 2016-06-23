# Copyright 2013 Thatcher Peskens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from ubuntu:trusty

maintainer Dockerfiles
ENV DJANGO_VERSION 1.8.1

run echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
run echo "deb http://archive.ubuntu.com/ubuntu trusty main restricted" >> /etc/apt/sources.list
run echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe" >> /etc/apt/sources.list
run echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted" >> /etc/apt/sources.list
run apt-get update
#run apt-get install -y build-essential git
run apt-get install -y git
run apt-get install -y python python-dev python-setuptools
run apt-get install -y nginx supervisor libpq-dev
run easy_install pip

# install uwsgi now because it takes a little while
run pip install uwsgi django=="$DJANGO_VERSION" requests psycopg2

# install nginx
run apt-get install -y python-software-properties
#run apt-get install -y nginx
#run apt-get update
#RUN add-apt-repository -y ppa:nginx/stable
run apt-get install -y sqlite3 vim python-mysql.connector

# install our code
add . /home/docker/code/

# setup all the configfiles
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
run ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

# run pip install
#run pip install -r /home/docker/code/app/requirements.txt

# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
#run django-admin.py startproject myself /home/docker/code/app/
#run mkdir /home/docker/code/app/personal/ && python /home/docker/code/app/manage.py startapp personal /home/docker/code/app/personal

expose 80
cmd ["supervisord", "-n"]
