
#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("install ansible" "update file host" "install manager leader" "install manager reachable" "install worker" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "install ansible")
            chmod a+x installansible.sh
            /root/installansible.sh
            ;;
        "update file host")
            cp -f /root/hosts /etc/ansible/hosts
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