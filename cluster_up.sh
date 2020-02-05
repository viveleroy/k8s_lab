#!/bin/bash
set -x

vagrant up
JOIN=$(vagrant ssh master -c "sudo kubeadm token create --print-join-command")
JOIN=${JOIN//[$'\t\r\n']}
vagrant ssh node1 -c "if [[ ! -e "provisioned.txt" ]]; then sudo ${JOIN}; touch provisioned.txt; fi"
vagrant ssh node2 -c "if [[ ! -e "provisioned.txt" ]]; then sudo ${JOIN}; touch provisioned.txt; fi"
