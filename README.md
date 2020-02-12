# K8S Lab

Kubernetes v1.16

## Build cluster

### Virtualbox / libvirt

Run: `./cluster_up.sh`

You get these VMs:

  | name   | IP            |
  | ------ | ------------- |
  | master | 192.168.33.20 |
  | node1  | 192.168.33.21 |
  | node2  | 192.168.33.22 |

### Hyper-V

Run: `./cluster_up.ps1`

Vagrant will ask which network switch to bind per node. Keep an eye on your console.

You get these VMs:

  | name   | IP                          |
  | ------ | --------------------------- |
  | master | Only known after deployment |
  | node1  | ^ |
  | node2  | ^ |

Access them by `vagrant ssh <machine_name>`

## Access Kubernetes

The vagrant user on master node has admin credential for kubernetes.
So you can use kubectl on a easy way. Access the master by `vagrant ssh master`.

Bash completion for `kubectl` is available and `kubectl` has an alias `k`.

Example:

```
[vagrant@master ~]$ kubectl get nodes
NAME     STATUS   ROLES    AGE     VERSION
master   Ready    master   2m57s   v1.16.1
node1    Ready    <none>   2m15s   v1.16.1
node2    Ready    <none>   2m12s   v1.16.1
[vagrant@master ~]$ k get nodes
NAME     STATUS   ROLES    AGE     VERSION
master   Ready    master   2m58s   v1.16.1
node1    Ready    <none>   2m16s   v1.16.1
node2    Ready    <none>   2m13s   v1.16.1
```

## Shutdown

To stop all the machines execute: `vagrant halt`

## Boot up

To boot up the cluster use: `vagrant up`

## Destroy

If you want to destroy the cluster to build it again or just to free resources,
use: `vagrant destroy`
