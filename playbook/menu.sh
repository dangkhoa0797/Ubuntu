
#!/bin/bash
# Bash Menu Script Example

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
function copykeygen()
{   
    sudo apt-get install -y sshpass
    for ip in `cat server.txt`; do
        ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 $ip
    done
}

PS3='Please enter your choice: '
options=("install ansible" "copy keygen ssh" "update file host" "install manager leader" "install manager reachable" "install worker" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "install ansible")
            installansible
            ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" 0>&-
            ;;
        "copy keygen ssh")
            nano server.txt
            copykeygen
            ;;
        "update file host")
            nano hosts
            cp -f ./hosts /etc/ansible/hosts
            ;;
        "install manager leader")
            ansible-playbook umanager.yml
            ;;
        "install manager reachable")
            ansible-playbook managerjoin.yml
            ;;
        "install worker")
            ansible-playbook workerjoin.yml
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done