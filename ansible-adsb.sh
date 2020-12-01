#!/bin/bash

echo "Welcome to server setup and maintence"

while true
do
	echo "Select 0) To provision servers"
	echo "Select 1) For Rancher"
	echo "Select 3) For k3s"
	echo "Select 4) To delete existing rancher cluster"
	echo "Select 5) To delete existing k3s cluster"
	echo "Select 6) To reboot nut server"
	echo "Select 7) To update servers"
	echo "Select 8) To exit"
	read -p "Enter selection " answer

	case $answer in
		[0]* ) echo "Provisioning servers"
		       ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/server-setup.yaml;;
		[1]* ) echo "Setting up rancher"
		       ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/rancher-deploy.yaml
		       echo "Remember to log in to the rancher web interface and update group_vars/all.yaml before proceeding";;
		[2]* ) echo "Setting up rancher cluster"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/rancher-node-setup.yaml;;
		[3]* ) echo "Setting up k3s cluster"
		       ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" k3s/site.yaml;;
		[4]* ) echo "Deleting rancher cluster"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/rancher-remove.yaml;;
        [5]* ) echo "Deleting k3s cluster"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" k3s/reset.yaml;;
        [6]* ) echo "Rebooting nut server"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/server-reboot-nut-server.yaml;;
        [7]* ) echo "Updating servers"
               ansible-playbook -i inventory/inventory --extra-vars "@group_vars/all.yaml" server/server-update-installed-packages.yaml;;

		# No cluster setup
		[8]* ) echo "Exiting!"
		       exit;;
	esac
done