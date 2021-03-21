# Ansible Notes
- Initial Learning: https://medium.com/faun/writing-simple-ansible-playbook-4458d83cedbb

```
# initialize a roles directory folder structure
# https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html?highlight=roles
ansible-galaxy init healthChecks

# this command will run your "0.0.0.playbook" playbook
ansible-playbook 0.0.0.playbook.yml

# this command will run your "0.0.0.playbook" playbook and use hosts.yml as the inventory file
ansible-playbook 0.0.0.playbook.yml -i hosts.yml

# a ssh tool used to add private keys identity to authentication agent
ssh-add ~/.ssh/id_rsa

# use the -l option to ssh-add to list them by fingerprint
ssh-add -l | -L

# run ad-hoc commands against azurevms defines in your hosts inventory file
ansible azurevms -a "df -h" -u bobouser -i hosts.yml
```