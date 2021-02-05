# Docker项目部署文档

## 1. 开发环境

    - ip: '10.25.83.94'
    - 用户：'rms'
    - 密码：''

## 2. docker

    - 项目镜像组成：基础镜像（python的基础依赖环境）+项目镜像（项目代码以及特定依赖）
    - 基础镜像：'my_python:v1'
    - 项目镜像：
        - 测试环境
        - 生产环境

## 3. 项目依赖更新

1. 先启动基础镜像，创建一个docker 容器， 更新依赖环境： “docker run -itd --name rms_addr_v1 my_python:v1 /bin/bash”
>> 注意事项：在容器启动脚本报错： exec user process caused "no such file or directory"
>> 这是由于镜像启动脚本是在windows下写的，格式是dos, 在Linux系统上用 vi 修改成 :set ff=unix
2. 进入容器， 更新依赖： “docker exec -it rms_addr_v1 /bin/bash”
    - pip 可以安装依赖： "pip install xx"
    - pip 不方便安装
3. 退出容器
    exit
4. 保存容器环境到镜像： docker commit -m "message"  rms_addr_v1 my_python:v1 

## 4 开发部署过程

1. 拷贝项目代码到开发服务器中，
    
    - 拷贝前，注意删除git 文件、缓存文件、日志、测试数据等
    
2. 删除历史版本数据

3. 打包文件为 tar.gz形式
   
4. 基于基础镜像创建docker容器
   
   ```
   docker run -itd --name rms_addr_v1 my_python:v1 /bin/bash     
   ```
   
5. 编写Dockerfile文件(以POI项目为例)

   ```
   # 基础镜像
   FROM python:latest 
   
   # 维护者信息
   LABEL maintainer="kuangxiong"
   
   # app 所在目录
   copy ./django_v1.tar.gz /var/django_v1.tar.gz 
   
   # 环境变量
   env PATH=$PATH:/usr/local/python3/bin
   env LD_LIBRARY_PATH="usr/local/bin"
   arg env='stg'
   
   # 执行环境
   user root
   
   run /usr/local/python3/bin/python3.7 -m pip install --upgrade pip \
   	&& pip install djangorestframework \ 
   	# project 
   	&& cd /var \
   	&& tar -zxvf /var/django_v1.tar.gz \
   	&& rm -rf /var/django_v1.tar.gz \
   	&& cd /var/django_v1 \
   	# 更新参数
   	&& echo Argument is $env \
   	&& sed -i 's/\r$//' /var/django_v1/manage.py \
   	# doc => unix 
   	&& sed -i 's/\r$//' /var/django_v1/gunicorn.sh \
   	&& chmod +x /var/django_v1/gunicorn.sh 
   
   # 启动项目目录
   workdir /var/django_v1
   # 启动项目
   CMD ["/var/django_v1/gunicorn.sh"]
   ```

6. 基于Dockerfile 创建docker 镜像

   ```
   docker build -t python:v3 .   
   ```

7. 创建容器并运行镜像

    ```
    #创建容器： 
    docker run -it -p 8005:8000 --name test python:v3 /bin/bash
    #测试： 
    python manage.py runserver 0.0.0.0:8000
    ```

8. postman 测试服务是否发布成功

   ```
   http://10.25.83.94:8005/address_standard/test/test_get/?a=10
   ```



## 5. 测试部署过程(开发部署确认服务无问题之后进行)

1. 更新部署配置参数，git 推代码
   + icore_rms_hadoop_alg/start_stg.sh, VERSION=stg_20201111_v1, 版本号格式： stg-日期-版本号
   + Icore_rms_hadoop_alg/deploy_desc, 确认当前发布迭代版本配置文件是否存在，没有复制一份再重命名

2. 创建测试镜像

   ```
   docker build -t hub.yun.paic.com.cn/ares-rms/prod-env:rms_address_stg_20201111_v1 --build-arg env='stg' .
   ```

3. 上传docker 镜像： 

   ```
   docker push hub.yun.piac.com.cn/ares-rms/prod-env:rms_address_stg_20201111_1
   ```



## 6 生产部署过程（测试部署确认服务无问题之后进行）

1. 创建生产镜像

   ```
   docker build -t hub.yun.paic.com.cn/ares-rms/prod-env:rms_address_prd_20201111_v1 --build-arg env='prd' .
   ```

2. 上传docker镜像

   ```
   docker push hub.yun.paic.com.cn/ares-rms/prod-env:rms_address_prd_20201111_v1
   ```

   

## 7.其他

1. 修改文件格式方法：

   - Vim 下查看文件类型：`:set ff`

   - 设置为unix 格式： `:set ff=unix`

     