#########################################################################
# File Name: gunicorn.sh
# Author:kuangxiong 
# mail:kuangxiong@lsec.cc.ac.cn 
# Created Time: Thu Feb  4 13:55:02 2021
#########################################################################
#!/bin/bash

gunicorn django_v1.wsgi:application \
	--bind 0.0.0.0:8000 \
	--workers 2 \
	--thread 2 \
	--timeout 30 \
	--preload \
	--access-logfile - \
	--error-logfile -
