#!/usr/bin/python3
# importing the module
import os
  
# sets the text colour to green 
os.system("tput setaf 2")
  
print("Launching Terminal User Interface")
  
# sets the text color to red
os.system("tput setaf 1")
  
print("\t\tWELCOME TO Terminal User Interface\t\t\t")
  
# sets the text color to white
os.system("tput setaf 7")
  
print("\t-------------------------------------------------")
print("Entering local device")
while True:
    print("""
        1.copy keygen
        2.file hosts
        3.file variables
        4.install swarm cluster only one node
        5.install multi-manage multi-worker cluster
        6.worker
        7.portainer
        8.traefik+infra
        9.Exit""")
  
    ch=int(input("Enter your choice: "))
  
    if(ch == 1):
            os.system("vi server.txt")
            os.system("chmod a+x playbook/copykeygen.sh; playbook/copykeygen.sh")
  
    elif ch == 2:
        os.system("vi /etc/ansible/hosts")
  
    elif ch == 3:
        os.system("vi playbook/variables.yml")
  
    elif ch == 4:
        os.system("ansible-playbook playbook/umanager.yml; ansible-playbook playbook/git.yml; ansible-playbook playbook/portainerinstall.yml --skip-tags git; ansible-playbook playbook/traefikinstall.yml --skip-tags git; ansible-playbook playbook/infrainstall.yml --skip-tags git")
    elif ch == 5:
        os.system("ansible-playbook playbook/umanager.yml; ansible-playbook playbook/managerjoin.yml; ansible-playbook playbook/workerjoin.yml")
          
    elif ch == 6:
        os.system("ansible-playbook playbook/umanager.yml --tags token; ansible-playbook playbook/workerjoin.yml")
  
    elif ch == 7:
        os.system("ansible-playbook playbook/portainerinstall.yml")
             
    elif ch == 8:
            os.system("ansible-playbook playbook/traefikinstall.yml")
            os.system("ansible-playbook playbook/infrainstall.yml")
              
    elif ch == 9:
        print("Exiting application")
        exit()
    else:
        print("Invalid entry")
  
    input("Press enter to continue")
    os.system("clear")