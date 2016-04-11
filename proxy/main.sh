#!/bin/bash
INTLODLINITemp=`cat ~/.INTLODLINIT`
cat ~/.INTLODLINIT
if [[ $? -ne 0 ]]; then
    INTLODLINITemp=0
fi 
#INTLODLINIT=${INTLODLINITemp:-0}
INTLODLINIT=2
function install_proxy {

    echo '**********************************Configuring Intel proxy**********************************'
    if [[ $INTLODLINIT -eq 0 ]]; then
        echo 'export GIT_PROXY_COMMAND=~/bin/socks-gw
export PATH=~bin:$PATH' >> ~/.bashrc
         
        export INTLODLINIT=1
    fi
    
    if [[ $INTLODLINIT -eq 1 ]]; then

       mkdir -p ~/bin

       echo '#!/bin/sh
# $1 = hostname, $2 = port
proxy=proxy-socks.sc.intel.com
exec socat STDIO SOCKS4:$proxy:$1:$2' > ~/bin/git-proxy

        sudo ./edit_sudoers.sh

        echo '#!/bin/sh

MODE="GNOME"
echo  $1 |grep "\.intel\.com$" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    connect $@
else
    connect -S proxy-socks.sc.intel.com:1080 $@
fi' > ~/bin/socks-gw

        chmod a+x ~/bin -R
        export INTLODLINIT=2
    fi
    ##################################################################################################################
    export ftp_proxy=http://proxy-us.intel.com:911
    export http_proxy=http://proxy-us.intel.com:911
    export https_proxy=https://proxy-us.intel.com:911
    export socks_proxy=http://proxy-us.intel.com:1080
    export no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,127.0.0.0/8,134.134.0.0/16,172.16.0.0/20
    export GIT_PROXY_COMMAND=~/bin/socks-gw
    export PATH=~bin:$PATH
    ##################################################################################################################
}

function install_tools {
    if [[ $INTLODLINIT -eq 2 ]]; then   
    echo '**********************************Installing packages*********************************'
    sudo apt-get update
    sudo apt-get install openssh-server -y
    sudo apt-get install connect-proxy -y
    sudo apt-get install socat -y
    sudo apt-get install python-pip -y
    sudo apt-get install git -y
    sudo apt-get install git-core -y
    sudo pip install git-review
    sudo apt-get install openjdk-7-jdk -y
    sudo apt-get install openjdk-7-jre -y
    sudo apt-get install wireshark -y
    sudo apt-get install mininet -y
    sudo apt-get install xclip -y
    sudo apt-get install pkg-config gcc make ant g++ git libboost-dev libcurl4-openssl-dev libjson0-dev libssl-dev unixodbc-dev xmlstarlet -y
    install_ovs
    rm openvswitch*
    rm python*
    export INTLODLINIT=3
    fi
 
} 

function install_ovs {
   echo '***********************************Installing OVS************************************'
   OVS_VERSION=2.3.1
   sudo apt-get install -y build-essential fakeroot debhelper libssl-dev
   wget http://openvswitch.org/releases/openvswitch-${OVS_VERSION}.tar.gz
   tar -xzf openvswitch-${OVS_VERSION}.tar.gz 
   cd openvswitch-${OVS_VERSION}
   DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary
   cd ..
   sudo dpkg -i openvswitch-common_${OVS_VERSION}-1_amd64.deb openvswitch-switch_${OVS_VERSION}-1_amd64.deb   
}

function install_maven {
    if [[ $INTLODLINIT -eq 3 ]]; then
    echo '**********************************Installing Maven3.3.3**********************************'
    ##################################################################################################################
    MVN_VERSION=3.3.3
    MVN_DOWN_baseurl=http://archive.apache.org/dist/maven/maven-3
    MVN_FILENAME=apache-maven-$MVN_VERSION-bin.tar.gz
    MVN_INSTALL_DIR=/usr/local/apache-maven
    MVN_H_DIR=MVN_INSTALL_DIR/apache-maven-$MVN_VERSION
    sudo mkdir -p $MVN_INSTALL_DIR
    wget $MVN_DOWN_baseurl/$MVN_VERSION/binaries/$MVN_FILENAME
    sudo mv $MVN_FILENAME $MVN_INSTALL_DIR/
    sudo tar xzf $MVN_INSTALL_DIR/$MVN_FILENAME -C $MVN_INSTALL_DIR
    sudo rm $MVN_INSTALL_DIR/$MVN_FILENAME

    export PATH=$PATH:$MVN_H_DIR/bin
    export M2_HOME=/usr/local/apache-maven/apache-maven-3.3.3
    export M2=$M2_HOME/bin
    export MAVEN_OPTS="-Dhttp.proxyHost=proxy-sc.intel.com -Dhttp.proxyPort=911 -Xmx2048m -XX:MaxPermSize=512m"
    export PATH=$M2:$PATH
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
    export JRE_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre


    echo 'export M2_HOME=/usr/local/apache-maven/apache-maven-3.3.3
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Dhttp.proxyHost=proxy-sc.intel.com -Dhttp.proxyPort=911 -Xmx2048m -XX:MaxPermSize=512m"
export PATH=$M2:$PATH
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export JRE_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre' >> ~/.profile
    ##################################################################################################################
    mvn -v
    
    echo '**********************************Configuring Maven Settings**********************************'
    
    mkdir -p ~/.m2
    cp -n ~/.m2/settings.xml{,.orig} 2>/dev/null
    cp settings.xml ~/.m2/settings.xml
    export INTLODLINIT=4
    fi
}
odlusername=''
odlpassword=''
odlname=''
odlemail=''
function create_accounts {
    if [[ $INTLODLINIT -eq 4 ]]; then
    echo '**********************************Create/Configure ODL, Git, Gerrit**********************************'

    echo 'Create a Opendaylight accout by signing up @ https://identity.opendaylight.org'
    echo 'Note: Use Intel email Id'
    echo 'After signing up complete the details below'
    echo -n 'ODL username : '
    read odlusername
    echo -n 'Name :'
    read odlname
    echo -n 'Intel email Id :'
    read odlemail
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo '............................SSH Keygen ENTER DEFAULTS for path.................................'
    ssh-keygen -t rsa
    while [ $? -ne 0 ]; do
        echo '............................Retrying SSH Keygen.................................'
	ssh-keygen -t rsa
    done
    echo '-----------------------------------------------------------------------------------------------------'
    cat ~/.ssh/id_rsa.pub
    xclip -sel clip < ~/.ssh/id_rsa.pub
    echo '-----------------------------------------------------------------------------------------------------'
    #echo 'SSH key copied to clipboard'
    echo ''
    echo 'Step 1 : Upload the public SSH key above using the ODL account ==> https://git.opendaylight.org/gerrit'
    echo 'Step 2 : Refer :: https://wiki.opendaylight.org/view/OpenDaylight_Controller:Gerrit_Setup#Registering_your_SSH_key_with_Gerrit'
    echo -n ' Once completed uploading Press Enter to continue: '
    read input
    
    git_review_conf
    git_conf
    export INTLODLINIT=5
    fi
}

function git_review_conf {
    mkdir -p ~/.config/git-review
    echo '[gerrit]
defaultremote = origin' >> ~/.config/git-review/git-review.conf

}

function git_conf {
    git config --global user.name $odlname
    git config --global user.email $odlemail
    git config --global core.gitproxy "git-proxy"
    git config -l 
}

function download_odl_projects {
    ui_project
    odlpwd=$(pwd)
    odlstr='Enter Path to clone project repositories [Default : '~/ODL]' :'  
    
    echo -n $odlstr

    read odlprojpath
    if [[ -z "$odlprojpath" ]]; then
        odlprojpath=~/ODL
    fi
    readarray -t PROJECTS < odlresults
    mkdir -p $odlprojpath
    cd $odlprojpath 
    for PROJECT in $PROJECTS; 
        do PROJECT=${PROJECT//\"/};
	echo 'Cloning repository ...............' $PROJECT;
        git clone https://git.opendaylight.org/gerrit/p/${PROJECT}.git ${PROJECT};
    done
    cd $odlpwd 
}

function build_projects {
    echo 'use \"mvn clean install -DskipTests\" under each project'
    echo 'Checking out stable Lithium branches for each project'
    for PROJECT in $PROJECTS;
        do PROJECT=${PROJECT//\"/};
        cd $odlprojpath/$PROJECT;
        git checkout stable/lithium;
        mvn clean install -DskipTests;
        if [ $? -ne 0 ]; then
            echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Build Failed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
            echo '';
            echo $PROJECT;
            echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Build Failed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
  
        fi
    done
    cd $odlprojpath
    git clone https://git.opendaylight.org/gerrit/p/integration.git
    cd integration
    mvn clean install -D skipTests
    #cd distributions/karaf/target/assembly
    #bin/karaf
    cd $odlpwd
    
} 

function ui_project {
whiptail --title "ODL project list" --nocancel --checklist "ODL Project list" 50 40 30 \
aaa "" off \
affinity "" off \
bgpcep "" off \
controller "" on \
defense4all "" off \
dlux "" off \
docs "" on \
groupbasedpolicy "" on \
l2switch "" off \
lispflowmapping "" off \
odlparent "" off \
opendove "" off \
openflowjava "" off \
openflowplugin "" off \
opflex "" off \
ovsdb "" on \
packetcable "" off \
releng/autorelease "" off \
releng/builder "" off \
reservation "" off \
sdninterfaceapp "" off \
sfc "" on \
snbi "" off \
snmp4sdn "" off \
tcpmd5 "" off \
toolkit "" off \
ttp "" off \
vtn "" off \
yangtools "" off 2>odlresults
}

function install_transparent_proxy {

sudo apt-get install redsocks -y
sudo apt-get install iptables -y
sudo apt-get install iptables-persistent -y

sudo ./iptable.sh
sudo rm /etc/redsocks.conf
echo 'base {
 log_debug = on;
 log_info = on;
 log = "file:/root/proxy.log";
 daemon = on;
 redirector = iptables;
}
redsocks {
 local_ip = 127.0.0.1;
 local_port = 6666;
 // socks5 proxy server
 ip = 10.7.211.16;
 port = 1080;
 type = socks5;
}
redudp {
 local_ip = 127.0.0.1;
 local_port = 8888;
 ip = 10.102.248.16;
 port = 1080;
}
dnstc {
 local_ip = 127.0.0.1;
 local_port = 5300;
}' > redsocks.conf

sudo mv redsocks.conf /etc/redsocks.conf
sudo service redsocks restart
sudo dpkg-reconfigure iptables-persistent

}

install_proxy
install_transparent_proxy
#install_tools
#install_maven
#create_accounts
#config_accounts
#download_odl_projects
#build_projects
#create_test_mininet
#echo $INTLODLINIT > ~/.INTLODLINIT
