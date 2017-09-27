# ansible-k8s

This playbook creates a three node k8s cluster with kafka and mqtt broker running in the cluster.

Roles in the playbook:

* __debian__, install basic packages for development, vim, tcpdump, net-tools and etc.
* __auth__, setup PKI infrastructure, create certificate authority and signed certificates.
* __etcd__, setup etcd cluster.
* __controller__, deploy kubernetes master node. Install apiserver, kube-scheduler and kube-controller.
* __worker__, deploy worker nodes. Install docker, kubelet, kube-proxy and flanneld.
* __addons__, setup kubernetes dns.
* __kafka-cluster__, deploy project pods on kubernetes. kafka cluster, mqtt and mongodb kafka connector, mqtt broker, mongodb, flask.

## pre-requisites

Three host machines in the same subnet each should have at least 2G memory available, they can be either real hardware or VMs.

* three host machines
* install ansible on controller machine

## Setup

There is an example vagrant setup under __vagant__ folder. Just start VMs using vagrant and run the playbook.

### Run vagrant example

You should have [vagrant](https://www.vagrantup.com/docs/installation/) and [virtualbox](https://www.virtualbox.org/wiki/Downloads) installed.

Start VMs using vagrant:
change current folder to __vagrant__ folder, and run `vagrant up` in the terminal.

Gather ssh configuration: `vagrant ssh-config`

Then feed the output to the `~/.ssh/config` file under your home directory.

Fill the `./hosts` with corresponding ssh config.

Run playbook:
`ansible-playbook -i ./hosts main.yml`

### Deploy project in real hardware

Three host machines should have debian 9 system installed and connected in the same subnet. SSH connection to the host machines shuld be configured in `~/.ssh/config`.

Fill the variable settings into `./main.yml`.

Following variables should be set in `./main.yml`:

* ETCD_NODES (ip address of etcd nodes)
* CONTROLLER (ip address of the node that shoud run a kubernetes apiserver process)
* K8S_NODES (hostname and ip address of kubernetes nodes)

Run playbook:
`ansible-playbook -i ./hosts main.yml`