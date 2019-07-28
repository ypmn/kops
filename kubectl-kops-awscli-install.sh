echo "Install kubectl "

sudo apt-get update && sudo apt-get install vim curl wget -y


curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

sudo chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

echo "Install kops "

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

chmod +x ./kops

sudo mv ./kops /usr/local/bin/

echo "Install aws cli "

sudo apt install python-pip -y

sudo pip install awscli 

export PATH=$PATH:~/.local/bin

echo " installaion of kubectl kops and aws cli were completed "

kops version

aws --version

kubectl version

