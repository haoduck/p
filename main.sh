#!/bin/bash
mail=$1
if [[ -z $mail ]]; then  
    echo "Please input mail." 
    exit  
fi
url="https://github.com/haoduck/p2pclient/raw/main/p2pclient-upx"
lsp="$HOME/p2pclient"
if [[ $(command -v apt-get) ]];then
    mjj=apt-get
    apt-get update
elif [[ $(command -v yum) ]];then
    mjj=yum
    yum install -y epel-release #不装安不了screen
    yum makecache
else
    echo "不支持的系统,可以尝试手动安装"
    exit 1
fi

if [[ $(command -v wget) ]];then
    wget -qO $lsp $url
elif [[ $(command -v curl) ]];then
    curl -sLo $lsp $url
else
    $mjj install -y wget
    wget -qO $lsp $url
fi

if [[ -z $(command -v screen) ]];then
    $mjj install -y screen
fi

if [[ -f $lsp ]];then
    chmod +x $lsp
else
    echo "出错了"
    exit 1
fi



if [[ -f "$HOME/.bashrc" ]];then
    cxk="$HOME/.bashrc"
elif [[ -f "$HOME/.profile" ]];then
    cxk="$HOME/.profile"
else
    echo "~~~"
fi

gay="[[ -z \$(ps -aux|grep p2pclient|grep -v grep) ]] && screen -dmS p2pclient $lsp -l $mail"
if [[ $cxk ]];then
    if [[ -z "$(cat $cxk|grep $lsp)" ]];then
        echo -e "\n\n$gay\n" >> $cxk
    fi
fi

[[ -z $(ps -aux|grep p2pclient|grep -v grep) ]] && screen -dmS p2pclient $lsp -l $mail
