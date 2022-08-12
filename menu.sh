#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("install manager leader" "install manager reachable" "install worker" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            ansible-playbook umanager.yml
            ;;
        "Option 2")
            ansible-playbook managerjoin.yml
            ;;
        "Option 3")
            ansible-playbook workerjoin.yml
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
