# docs: https://www.jenkins.io/doc/book/installing/linux/
# lets install java first
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jre-headless


# Long Term Support release
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y

# Unlocking Jenkins/Console. http://<vm_pip>:8080 
# this password is also the password for "admin", may need sleep()
sleep 10
jenkinsurl=`curl ipinfo.io/ip`
echo "Please visit http://${jenkinsurl}:8080 to complete setup"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword