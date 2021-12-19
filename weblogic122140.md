# weblogic 12.2.1.4.0
weblogic 12.2.1.4.0 docker vul hub
CVE-2021-2394 core

## docker下如何安装weblogic 12.2.1.4.0 的靶机
### 我遇到了什么坑？
macos安装X11的支持，否则docker图形界面无法显示，weblogic无法继续安装
```bash
brew install xquartz
```
并启动xquartz,macos上运行：
```bash
export DISPLAY="localhost:0"
xhost + 127.0.0.1
xhost + `ipconfig getifaddr en0`


```
#### 开始运行docker
- X11相关的包已经一键安装
- fmw_14.1.1.0.0_wls.jar 官网注册后下载
- jdk1.8.0_151 从其他weblogic环境中拷贝
```bash
docker run -it -e DISPLAY=$DISPLAY --name myweblgc -v $HOME/Downloads/weblogic/fmw_12.2.1.4.0_wls_lite_Disk1_1of1/fmw_12.2.1.4.0_wls_lite_generic.jar:/tmp/fmw_12.2.1.4.0_wls_lite_generic.jar -v `pwd`/jdk1.8.0_151:/jdk1.8.0_151 ubuntu:latest /bin/bash -c 'apt update;apt install -yy libxrender-dev libxext-dev libxtst-dev;useradd weblogic;mkdir -p /home/weblogic;chown -R weblogic:weblogic /home/weblogic;bash'

su - weblogic
export DISPLAY="docker.for.mac.localhost:0"
# -silent -responseFile /home/weblogic/wls.rsp -invPtrLoc /home/weblogic/oraInst.loc ORACLE_HOME="/weblogic/bea"
/jdk1.8.0_151/bin/java -jar /tmp/fmw_12.2.1.4.0_wls_lite_generic.jar
```
图形界面出来自己操作完成即可
```bash
su - weblogic
export JAVA_HOME=/jdk1.8.0_151
/home/weblogic/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/startWebLogic.sh
```
- 让docker外可以访问端口
curIDD="867b4ca85695"
替换为你当前的
```
docker commit $curIDD weblogic122140_1
docker run -it --name wblgc weblogic122140_1 /bin/bash
rm -rf /jdk1.8.0_151
docker cp jdk1.8.0_151 wblgc:/
docker commit  wblgc weblogic122140
docker build -f Dockerfile122140 -t hktalent/weblogic:12.2.1.4.0 .

docker run --rm -p 7001:7001 hktalent/weblogic:12.2.1.4.0

```
你可以访问了
http://127.0.0.1:7001/console

- 用户名和密码：weblogic/weblogic123

# 你还可以直接运行
```bash

docker stop weblogic122140
docker rm weblogic122140
docker rmi weblogic122140
docker port d99554f052ed 7001


docker run --rm -p 7001:7001 hktalent/weblogic:12.2.1.4.0

docker login
docker push hktalent/weblogic:12.2.1.4.0
docker image push hktalent/weblogic:12.2.1.4.0
```


service:jmx:iiop://172.17.0.2:7001/jndi/weblogic.management.mbeanservers.runtime
service:jmx:iiop://172.17.0.2:7001/jndi/weblogic.management.mbeanservers.domainruntime
service:jmx:iiop://172.17.0.2:7001/jndi/weblogic.management.mbeanservers.edit