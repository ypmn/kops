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
     
     
# Follow the below commands to generate the public key and create a secret by using below command for connecting the cluster

ssh-keygen

# Note : Here give your cluster name and s3 bucket name 

kops create secret --name mycluster.abc.com sshpublickey admin -i ~/.ssh/id_rsa.pub --state "s3://mybucket.abc.com"

# Change the s3 bucket name and Export the bucket name as ENV 

export KOPS_STATE_STORE=s3://mybucket.abc.com


Now run kops commands without specifing the bucket name

# Update the cluster dry run


kops update cluster mycluster.abc.com 


# execute the below command for Update the cluster and expected output

kops update cluster mycluster.abc.com  --yes

    I0728 06:07:20.744071   18502 executor.go:103] Tasks: 0 done / 93 total; 47 can run
    I0728 06:07:20.900948   18502 executor.go:103] Tasks: 47 done / 93 total; 24 can run
    I0728 06:07:21.017732   18502 executor.go:103] Tasks: 71 done / 93 total; 18 can run
    I0728 06:07:21.244639   18502 executor.go:103] Tasks: 89 done / 93 total; 4 can run
    I0728 06:07:21.337591   18502 executor.go:103] Tasks: 93 done / 93 total; 0 can run
    I0728 06:07:21.337763   18502 dns.go:153] Pre-creating DNS records
    I0728 06:07:21.454645   18502 update_cluster.go:291] Exporting kubecfg for cluster
    kops has set your kubectl context to mycluster.abc.com

    Cluster changes have been applied to the cloud.


    Changes may require instances to restart: kops rolling-update cluster
   

# Below the command to know the status of installation and expected output

kops validate cluster mycluster.abc.com --yes

	Validating cluster mycluster.abc.com

	INSTANCE GROUPS
	NAME                    ROLE    MACHINETYPE     MIN     MAX     SUBNETS
	master-us-east-2c-1     Master  t2.medium       1       1       us-east-2c
	master-us-east-2c-2     Master  t2.medium       1       1       us-east-2c
	master-us-east-2c-3     Master  t2.medium       1       1       us-east-2c
	nodes                   Node    t2.medium       3       3       us-east-2c

	NODE STATUS
	NAME    ROLE    READY

	VALIDATION ERRORS
	KIND    NAME            MESSAGE
	dns     apiserver       Validation Failed

	The dns-controller Kubernetes deployment has not updated the Kubernetes cluster's API DNS entry to the correct IP address.  The         API DNS IP address is the placeholder address that kops creates: 203.0.113.123.  Please wait about 5-10 minutes for a master to         start, dns-controller to launch, and DNS to propagate.  The protokube container and dns-controller deployment logs may contain           more diagnostic information.  Etcd and the API DNS entries must be updated for a kops Kubernetes cluster to start.

	Validation Failed
        Note : Now It will list of the commands carefully run  to add a pubclic key to master node for ssh to master execute thatcommand
	
# Execute the below command with your cluster name after 10 mins to makesure for cluster ready and expected output 

kops validate cluster mycluster.abc.com

	Validating cluster mycluster.abc.com

	INSTANCE GROUPS
	NAME                    ROLE    MACHINETYPE     MIN     MAX     SUBNETS
	master-us-east-2c-1     Master  t2.medium       1       1       us-east-2c
	master-us-east-2c-2     Master  t2.medium       1       1       us-east-2c
	master-us-east-2c-3     Master  t2.medium       1       1       us-east-2c
	nodes                   Node    t2.medium       3       3       us-east-2c

	NODE STATUS
	NAME                                            ROLE    READY
	ip-172-20-33-98.us-east-2.compute.internal      master  True
	ip-172-20-40-104.us-east-2.compute.internal     master  True
	ip-172-20-40-56.us-east-2.compute.internal      master  True
	ip-172-20-45-130.us-east-2.compute.internal     node    True
	ip-172-20-47-238.us-east-2.compute.internal     node    True
	ip-172-20-61-226.us-east-2.compute.internal     node    True

	Your cluster mycluster.abc.com is ready



# Check the list of the nodes

kubectl get nodes

	NAME                                          STATUS   ROLES    AGE   VERSION
	ip-172-20-33-98.us-east-2.compute.internal    Ready    master   14m   v1.12.8
	ip-172-20-40-104.us-east-2.compute.internal   Ready    master   13m   v1.12.8
	ip-172-20-40-56.us-east-2.compute.internal    Ready    master   14m   v1.12.8
	ip-172-20-45-130.us-east-2.compute.internal   Ready    node     12m   v1.12.8
	ip-172-20-47-238.us-east-2.compute.internal   Ready    node     13m   v1.12.8
	ip-172-20-61-226.us-east-2.compute.internal   Ready    node     12m   v1.12.8



# Delete the cluster

kops delete cluster mycluster.abc.com --state "s3://mybucket.abc.com"

# Delete the s3 bucket

Goto s3 service in aws console delete the bucket











	   

	   
