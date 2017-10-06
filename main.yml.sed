- hosts: debian
  roles:
    - debian

- hosts: auth
  roles:
    - auth
  vars:
    - CONTROLLER: "node1_ip"
    - K8S_NODES: [
    {"hostname":"node1", "ip":"node1_ip"},
    {"hostname":"node2", "ip":"node2_ip"},
    {"hostname":"node3", "ip":"node3_ip"}
]
 
- hosts: etcd
  roles:
    - etcd
  vars:
    - ETCD_NODES: [ "node1_ip", "node2_ip", "node3_ip" ]

- hosts: controller
  roles:
    - controller
  vars:
    - CONTROLLER_IP: "node1_ip"
    - ETCD_NODES: [ "node2_ip", "node1_ip", "node3_ip" ]

- hosts: worker
  roles:
    - worker
  vars:
    - K8S_NODES: [
    {"hostname":"controller", "ip":"node1_ip"},
    {"hostname":"node1", "ip":"node1_ip"},
    {"hostname":"node2", "ip":"node2_ip"},
    {"hostname":"node3", "ip":"node3_ip"}
    ]
    - ETCD_NODES: [ "node1_ip", "node2_ip", "node3_ip" ]
    - NETWORK_PLUGIN: "cni"
    - node_ip: "{{ ETCD_NODES | intersect(ansible_all_ipv4_addresses) }}"
    - node_name: "worker{{ node_ip[0][-1] }}"

- hosts: controller
  roles:
    - addons
  
- hosts: controller
  roles:
    - kafka-cluster
