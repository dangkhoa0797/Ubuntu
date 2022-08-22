for ip in `cat server.txt`; do
    sshpass -f password.txt ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 $ip
done