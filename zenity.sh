#!/bin/bash
apt-get install -y zenity

function installansible() {
	{
        apt install python3-pip -y
        pip3 install ansible
        mkdir -p /etc/ansible/
        printf '
        ansible ansible_host=192.168.253.140 ansible_port=22 ansible_user=root

        [reachable]
        ubuntu202 ansible_host=192.168.253.139 ansible_port=22 ansible_user=root

        [worker]
        ubuntu201 ansible_host=192.168.253.138 ansible_port=22 ansible_user=root
        ' > /etc/ansible/hosts
	}
}

function UpdateAndUpgrade()
{
    DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
    DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade

    apt-get autoremove -y
    apt-get clean
    apt-get autoclean
}

function copykeygen()
{   
    sudo apt-get install -y sshpass
    for ip in `cat server.txt`; do
        sshpass -f password.txt ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 $ip
    done
}

function insertpass()
{   
    zenity --entry --width=800 --height=400 --title="pass" --text="Enter your pass" --entry-text="" > password.txt
}


menu=`zenity --list --width=800 --height=400 \
--title="Danh sách cài đặt" \
--text='<span foreground="Violet" font="26">Chọn một nhiệm vụ.\n</span>' \
  --column="Số thứ tự" --column="Lệnh" --column="Ghi chú" \
    1 "Cài đặt ansible" k \
    2 "Copy keygen ssh" k\
    3 "Cập nhật file hosts" k\
    4 "Cập nhật file variables.yml" k\
    5 "Cài đặt hệ thống swarm" k\
    0 "Tải lại menu" k\

     `

if [ "$menu" == "1" ]; then
    installansible
    ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" 0>&-
    ./zenity.sh
fi

if [ "$menu" == "2" ]; then
    nano server.txt
    insertpass
    copykeygen
    ./zenity.sh
fi

if [ "$menu" == "3" ]; then
    nano hosts
    cp -f ./hosts /etc/ansible/hosts
    ./zenity.sh
fi

if [ "$menu" == "4" ]; then
    nano playbook/variables.yml
    ./zenity.sh
fi

if [ "$menu" == "5" ]; then
    ansible-playbook playbook/umanager.yml
    ansible-playbook playbook/umanager.yml --tags dkp
    ansible-playbook playbook/managerjoin.yml
    ansible-playbook playbook/workerjoin.yml
    ./zenity.sh
fi

if [ "$menu" == "0" ]; then
    ./zenity.sh
fi

exit 0
# Nhấn Esc để đóng