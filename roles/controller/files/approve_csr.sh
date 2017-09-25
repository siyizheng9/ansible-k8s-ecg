#!/bin/bash

touch nohup.out

while true
do
    sleep 10s
    CSR=$(kubectl get csr | grep -v 'Approved' | grep -o '.*csr-[[:alnum:]]*')
    
    if [ -z "$CSR" ]; then
       continue
    fi
    
    CSR=$(echo $CSR| xargs)
    
    for item in $CSR; do
        kubectl certificate approve $item
    done
done
