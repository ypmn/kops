# Installation scripts for the kubectl kops and aws cli 

bash <(curl -Ls https://raw.githubusercontent.com/ypmn/kops/master/kubectl-kops-awscli-install.sh)


# Below are the manual process for installating the kops in aws 

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

# Create a iam user with admin access with programatic access 

Create access key for that user and download the csv file 


# Configure aws credentials with accessID and secretkey (from csv file) and execute below command

aws configure


# Create a hostzone in route53 with your domain in publichosted zone

Ex : abc.com

# And add NS records from aws Route53 to Nameservers in Godaddy ( Domain provider ) DNS.

Ex : abc.com  Below are aws Route53 NS records

        From AWS Route53 NS Records 
	
	(ns-751.awsdns-29.net)

	(ns-23.awsdns-02.com) 

	( ns-1202.awsdns-22.org)

	( ns-1931.awsdns-49.co.uk)
 
        Add To
     
        Go Daddy (domain provider ) DNS NameServer 

# create a s3 bucket in a region where you have to create the cluser

Goto aws console create s3 bucket or use aws cli create the s3 bucket

Ex : bucket name : mybucket.abc.com

aws s3 mb s3://mybucket.abc.com --region us-east-2


# Create the cluster with 3 masters and three nodes

# Note : Master node count should be odd number

kops create cluster \
       --state "s3://mybucket.abc.com" \
       --zones "us-east-2c"  \
       --master-count 3 \
       --master-size=t2.medium \
       --node-count 3 \
       --node-size=t2.medium \
       --name mycluster.abc.com \
       --yes
       
     # above " kops create cluster command expected output mentioned below "
     I0728 05:49:50.789769   18430 create_cluster.go:519] Inferred --cloud=aws from zone "us-east-2c"
     W0728 05:49:50.789974   18430 create_cluster.go:720] Running with masters in the same AZs; redundancy will be reduced
     I0728 05:49:50.832235   18430 subnets.go:184] Assigned CIDR 172.20.32.0/19 to subnet us-east-2c

     SSH public key must be specified when running with AWS
     (create with `kops create secret --name mycluster.abc.com sshpublickey admin -i ~/.ssh/id_rsa.pub`)
    


# Check the cluster status


kops validate cluster mycluster.abc.com --state "s3://mybucket.abc.com" 	

or 

kops validate cluster mycluster.abc.com --state "s3://mybucket.abc.com" --yes


Instead of using --state every time  set env for that below the mentioned process



export KOPS_STATE_STORE=s3://mybucket.abc.com


Now run kops commands without specifing the bucket name


kops validate cluster mycluster.abc.com --yes


# Update the cluster dry run


kops update cluster mycluster.abc.com 


# Update the cluster

kops update cluster mycluster.abc.com  --yes

# And wait for atleast 20 mins to get up the k8s cluster and below the command to know the status of installation

kops validate cluster mycluster.abc.com --yes

# Now here we need to generate ssh key and below are the process

ssh-keygen




Note : Now It will list of the commands carefully run  to add a pubclic key to master node for ssh to master execute that command

# Check the list of the nodes

kubectl get nodes


# Delete the cluster

kops delete cluster mycluster.abc.com --state "s3://mybucket.abc.com"

# Delete the s3 bucket

Goto s3 service in aws console delete the bucket











	   

	   
