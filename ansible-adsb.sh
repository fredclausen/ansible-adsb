#!/bin/bash

MASTER_IP="192.168.31.30"
USER="ubuntu"

echo "Welcome to server setup and maintence"

while true
do
       echo "Select z) To exit"
       echo "Select a) To provision servers"
       echo "Select b) To install Rancher"
       echo "Select c) To install Rancher cluster to the nodes"
       echo "Select d) To install k3s"
       echo "Select e) To delete existing rancher cluster"
       echo "Select f) To delete existing k3s cluster"
       echo "Select g) To reboot nut server"
       echo "Select h) To update servers"
       echo "Select i) To setup cluster pods"
       echo "Select j) To remove cluster pods"
       echo "Select k) To reboot all cluster nodes"
       echo "Select l) To deploy test.yaml"
       
       read -p "Enter selection " answer

       case $answer in
              [aA]* ) echo "Provisioning servers"
                     ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/server-setup.yaml;;
              [bB]* ) echo "Setting up rancher"
                     ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/rancher-deploy.yaml
                     echo "Remember to log in to the rancher web interface and update group_vars/all.yaml before proceeding";;
              [cC]* ) echo "Setting up rancher cluster"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/rancher-node-setup.yaml;;
              [dD]* ) echo "Setting up k3s cluster"
                     ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" k3s/site.yml
                     ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/k3s-setup.yaml;;
              [eE]* ) echo "Deleting rancher cluster"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/rancher-remove.yaml;;
              [fF]* ) echo "Deleting k3s cluster"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" k3s/reset.yml;;
              [gG]* ) echo "Rebooting nut server"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/server-reboot-nut-server.yaml;;
              [hH]* ) echo "Updating servers"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/server-update-installed-packages.yaml;;
              [iI]* ) echo "Setting up cluster pods"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" pods/setup-cluster-services.yaml;;
              [jJ]* ) echo "Removing cluster pods"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" pods/remove-cluster-services.yaml;;
              [zZ]* ) echo "Exiting!"
                     exit;;
              [kK]* ) echo "Rebooting nodes"
                ansible k3s_cluster -i inventory/inventory -b -m reboot -a;;
              [lL]* ) echo "Deploying test.yaml"
                ansible-playbook -i inventory/inventory --extra-vars="workload_state=present" --extra-vars "@group_vars/all.yaml" pods/test.yaml;;        
              esac
done