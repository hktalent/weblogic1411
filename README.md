# weblogic1411
weblogic1411 docker vul hub
CVE-2021-35617 Coherence Container	IIOP POC N-day

## docker下如何安装weblogic 14.1.1.0.0的靶机
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
```
