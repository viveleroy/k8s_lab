vagrant up --provider hyperv
$join=vagrant ssh master -c "sudo kubeadm token create --print-join-command"
vagrant ssh node1 -c "if [[ ! -e ""provisioned.txt"" ]]; then sudo $join ;touch provisioned.txt; fi"
vagrant ssh node2 -c "if [[ ! -e ""provisioned.txt"" ]]; then sudo $join ;touch provisioned.txt; fi"