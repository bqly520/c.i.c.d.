# docs: https://www.jenkins.io/doc/book/installing/linux/
# ssh into the box somehow
ssh -i <private_key> <user>@<vm_pip

# lets install java first
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jre-headless


# Long Term Support release
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y