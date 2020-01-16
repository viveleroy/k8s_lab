#!/bin/bash
set -x

vagrant up
JOIN=$(vagrant ssh master -c "sudo kubeadm token create --print-join-command")
JOIN=${JOIN//[$'\t\r\n']}
vagrant ssh node1 -c "sudo ${JOIN}"
vagrant ssh node2 -c "sudo ${JOIN}"
