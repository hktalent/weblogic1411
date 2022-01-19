# weblogic1411
weblogic1411 docker vul hub
CVE-2021-35617 Coherence Container	IIOP POC N-day

- what is Coherence
https://baike.baidu.com/item/coherence

Coherence的主要用途是共享一个应用的对象(主要是java对象，比如Web应用的一个会话java对象)和数据(比如数据库数据，通过OR-MAPPING后成为Java对象)。　简单来说，就是当一个应用把它的对象或数据托管给Coherence管理的时候，该对象或数据就能够在整个集群环境(多个应用服务器节点)共享，应用程序可以非常简单地调用get方法取得该对象，并且由于Coherence本身的冗余机制使得任何一个应用服务器节点的失败都不会影响到该对象的丢失。其实如果不使用coherence，对于一个会话在多个应用服务器节点的共享一般是通过应用服务器本身的集群技术，而Coherence的创造者则认为基于某种应用服务器技术的集群技术来共享会话变量的技术并不完整，而专门开发出Coherence这个产品(原来称为tangosol)并且最后被Oracle收购，这个产品既有原来各种应用服务器集群所具有的各种技术特点，而且又增加了原来各种应用服务器集群技术所没有的各种特性。

## docker下如何安装weblogic 14.1.1.0.0的靶机
https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html
https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/nt/middleware/14c/14110/fmw_14.1.1.0.0_wls_lite_Disk1_1of1.zip
https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/nt/middleware/12c/122140/fmw_12.2.1.4.0_wls_lite_Disk1_1of1.zip
https://download.oracle.com/otn/nt/middleware/11g/wls/1036/wls1036_generic.jar

### 我遇到了什么坑？
macos安装X11的支持，否则docker图形界面无法显示，weblogic无法继续安装
```bash
brew install xquartz
```
并启动xquartz,macos上运行：
```bash
export DISPLAY=localhost:0
xhost + 127.0.0.1
xhost + `ipconfig getifaddr en0`


```
#### 开始运行docker
- X11相关的包已经一键安装
- fmw_14.1.1.0.0_wls.jar 官网注册后下载
- jdk1.8.0_151 从其他weblogic环境中拷贝
```bash
docker run -it -e DISPLAY=$DISPLAY -v $HOME/Downloads/fmw_14.1.1.0.0_wls.jar:/fmw_14.1.1.0.0_wls.jar -v `pwd`/jdk1.8.0_151:/jdk1.8.0_151 ubuntu:latest /bin/bash -c 'apt update;apt install -yy libxrender-dev libxext-dev libxtst-dev;useradd weblogic;mkdir -p /home/weblogic;chown -R weblogic:weblogic /home/weblogic;bash'

su - weblogic
export DISPLAY="docker.for.mac.localhost:0"
/jdk1.8.0_151/bin/java -jar /fmw_14.1.1.0.0_wls.jar
```
图形界面出来自己操作完成即可
```bash
su - weblogic
export JAVA_HOME=/jdk1.8.0_151
/home/weblogic/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/startWebLogic.sh
```
- 让docker外可以访问端口
3707ee81ff3d 替换为你当前的
```
docker port 3707ee81ff3d 7001
```
你可以访问了
http://127.0.0.1:7001/console

- 用户名和密码：weblogic/weblogic123

# 你还可以直接运行
```bash
docker run -d -p 7001:7001 hktalent/weblogic:14.1.1 
docker run --rm -p 7001:7001 hktalent/weblogic:12.2.1.4.0
```
