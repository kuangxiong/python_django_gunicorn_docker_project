# 基础镜像
FROM python:v1 

# 维护者信息
LABEL maintainer="kuangxiong"

# app 所在目录
copy ./django_v1.tar.gz /var/django_v1.tar.gz 

# 环境变量
env PATH=$PATH:/usr/local/python3/bin
env LD_LIBRARY_PATH="usr/local/bin"
#arg env='stg'

# 执行环境
user root

run python3 -m pip install --upgrade pip \
	&& pip install djangorestframework \ 
	&& cd /var \
	&& tar -zxvf /var/django_v1.tar.gz \
	&& rm -rf /var/django_v1.tar.gz \
	&& cd /var/django_v1 \
#	&& echo Argument is $env \
#	&& sed -i 's/\r$//' /var/django_v1/manage.py \
#	&& sed -i 's/\r$//' /var/django_v1/gunicorn.sh \
	&& chmod +x /var/django_v1/gunicorn.sh 

# 启动项目目录
workdir /var/django_v1
# 启动项目
CMD ["/var/django_v1/gunicorn.sh"]

