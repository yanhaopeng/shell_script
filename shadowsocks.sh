#!/bin/bash

####################################
install_home="/etc/shadowsocks/" # 安装目录
port=888;                        # 端口
password="password"              # 密码
encrypt="aes-256-cfb"            # 加密方式
####################################

rm -rf $install_home
mkdir -p $install_home

apt update

apt install -y python-pip git
pip install --upgrade pip
pip install setuptools
# pip install shadowsocks
pip install git+https://github.com/shadowsocks/shadowsocks.git@master

cd $install_home

cat > $install_home/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":$port,
    "password":"$password",
    "method":"$encrypt"
}
EOF

start_cmd="ssserver -c "$install_home"config.json -d start"
$start_cmd
echo 'shadowsocks 服务已启动'
sleep 3
touch /etc/rc.local
echo "#!/bin/sh -e" > /etc/rc.local
echo $start_cmd >> /etc/rc.local
echo "exit 0"
chmod 755 /etc/rc.local

echo "安装成功,已加入开机自启,端口:$port 密码:$password 加密方式:$encrypt"
