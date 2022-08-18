#ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" 0>&-
vi server.txt
for ip in `cat server.txt`;
do
    ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 $ip
done
vi hosts
#cp -f ./hosts /etc/ansible/hosts
vi variables.yml
ansible-playbook umanager.yml
ansible-playbook managerjoin.yml
ansible-playbook workerjoin.yml