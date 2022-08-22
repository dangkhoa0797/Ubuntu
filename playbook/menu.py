#!/usr/bin/python3
"""
Demonstration example for GitHub Project at
https://github.com/IngoMeyer441/simple-term-menu

This code only works in python3. Install per

    sudo pip3 install simple-term-menu

"""
import time
import os
import subprocess


from simple_term_menu import TerminalMenu


def main():
    main_menu_title = "  Main Menu.\n  Press Q or Esc to quit. \n"
    main_menu_items = ["[1] install ansible", "[2] Copy keygen ssh", "[3] Cập nhật file hosts", "[4]Cập nhật file variables.yml", "[5] Install swarm", "[6]install portainer", "[7]instaii traefik", "[8]install infrastructure", "Quit"]
    main_menu_cursor = ">> "
    main_menu_cursor_style = ("fg_blue", "bold")
    main_menu_style = ("bg_red", "fg_yellow")
    main_menu_exit = False

    main_menu = TerminalMenu(
        menu_entries=main_menu_items,
        title=main_menu_title,
        menu_cursor=main_menu_cursor,
        menu_cursor_style=main_menu_cursor_style,
        menu_highlight_style=main_menu_style,
        cycle_cursor=True,
        clear_screen=False,
    )

    install_swarm_title = "  Install swarm.\n  Press Q or Esc to back to main menu. \n"
    install_swarm_items = ["[1] Install manager leader *", "[2] Install manager reachable", "[3] install worker", "[4] take token", "[5] install swarm", "Back to Main Menu"]
    install_swarm_back = False
    install_swarm = TerminalMenu(
        install_swarm_items,
        title=install_swarm_title,
        menu_cursor=main_menu_cursor,
        menu_cursor_style=main_menu_cursor_style,
        menu_highlight_style=main_menu_style,
        cycle_cursor=True,
        clear_screen=False,
    )

    while not main_menu_exit:
        main_sel = main_menu.show()

        if main_sel == 0:
            print("install ansible")
            os.system("apt install python3-pip -y; pip3 install ansible; mkdir -p /etc/ansible/")
            subprocess.run("< /dev/zero ssh-keygen -q -N ''", shell=True)
        if main_sel == 1:
            print("Copy keygen ssh")
            os.system("vi server.txt; vi password.txt")
            os.system("sudo apt-get install -y sshpass; chmod a+x playbook/copykeygen.sh; playbook/copykeygen.sh")
        elif main_sel == 2:
            print("Cập nhật file hosts")
            subprocess.run("vi /etc/ansible/hosts", shell=True)
            time.sleep(2)
        elif main_sel == 3:
            print("Cập nhật file variables.yml")
            subprocess.run("vi playbook/variables.yml", shell=True)
        elif main_sel == 4:
            while not install_swarm_back:
                edit_sel = install_swarm.show()
                if edit_sel == 0:
                    print("Install manager leader * Selected")
                    subprocess.run("ansible-playbook playbook/umanager.yml", shell=True)
                elif edit_sel == 1:
                    print("Install manager reachable")
                    subprocess.run("ansible-playbook playbook/managerjoin.yml", shell=True)
                elif edit_sel == 2:
                    print("install worker")
                    subprocess.run("ansible-playbook playbook/workerjoin.yml", shell=True)
                elif edit_sel == 3:
                    print("take token")
                    subprocess.run("ansible-playbook playbook/umanager.yml --tags token", shell=True)
                elif edit_sel == 4:
                    print("install swarm")
                    subprocess.run("ansible-playbook playbook/umanager.yml; ansible-playbook playbook/managerjoin.yml; ansible-playbook playbook/workerjoin.yml", shell=True)
                elif edit_sel == 5 or edit_sel == None:
                    install_swarm_back = True
                    print("Back Selected")
            install_swarm_back = False
        elif main_sel == 5:
            print("install portainer")
            subprocess.run("ansible-playbook playbook/portainerinstall.yml", shell=True)
            time.sleep(5)
        elif main_sel == 6:
            print("instaii traefik")
            subprocess.run("ansible-playbook playbook/traefikinstall.yml", shell=True)
            time.sleep(5)
        elif main_sel == 7:
            print("install infrastructure")
            subprocess.run("ansible-playbook playbook/infrainstall.yml", shell=True)
            time.sleep(5)
        elif main_sel == 3 or main_sel == None:
            main_menu_exit = True
            print("Quit Selected")


if __name__ == "__main__":
    main()