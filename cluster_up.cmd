@echo off
vagrant up --provider hyperv
vagrant ssh master -c "sudo kubeadm token create --print-join-command"
echo "Run vagrant ssh node1 -c ""if [[ ! -e ""provisioned.txt"" ]]; then sudo <<<<output previous command>>>> ;touch provisioned.txt; fi"