# Install kubectl

apt-get update && apt-get install vim curl wget -y


curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

# Install kops

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

# Install aws cli

sudo apt install python-pip
pip install awscli
export PATH=$PATH:~/.local/bin

# Create a iam user with admin access

Create access key for that user


# Configure aws credentials

aws configure


# Create a hostzone in route53 with your domain

Ex : abc.com

Add dns servers to domain provider

Ex : godaddy.com ( domain provider )

# create a s3 bucket in a region where you have to create the cluser

Goto aws console create s3 bucket or use aws cli create the s3 bucket

Ex : bucket name : mybucket.abc.com


# Create the cluster with two masters and three nodes


kops create cluster \
       --state "s3://mybucket.abc.com" \
       --zones "us-east-2c"  \
       --master-count 2 \
       --master-size=t2.medium \
       --node-count 3 \
       --node-size=t2.medium \
       --name mycluster.abc.com \
       --yes

# Check the cluster status


kops validate cluster mycluster.abc.com --state "s3://mybucket.abc.com"	   


Instead of using --state every time  set env for that one



export KOPS_STATE_STORE=s3://mybucket.abc.com


Now run kops commands without specifing the bucket name


kops validate cluster mycluster.abc.com --yes


# Update the cluser dry run


kops update cluster mycluster.abc.com 


# Update the cluser

kops update cluster mycluster.abc.com  --yes


Note : It will give command to add a pubclic key to master node for ssh to master execute that command

#Check the list of the nodes

kubectl get nodes


# Delete the cluster

kops delete cluster mycluster.abc.com --state "s3://mybucket.abc.com"

# Delete the s3 bucket

Goto s3 service in aws console delete the bucket











	   

	   
