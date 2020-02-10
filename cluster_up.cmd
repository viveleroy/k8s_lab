@echo off
vagrant up --provider hyperv
echo Join command:
vagrant ssh master -c "sudo kubeadm token create --print-join-command"
echo vagrant ssh node[n] -c ^"if [[ ! -e ^"provisioned.txt^" ]]; then sudo [join command] ;touch provisioned.txt; fi^"