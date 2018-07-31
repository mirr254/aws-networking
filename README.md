# What this repo does.

Automates the creation of a custom network in AWS services and automatically provisions the AMIs build using packer and ansible.

# Prerequisites

For this terraform scripts to work, developer will need to set up some few things which are explained below.

- One has AWS account and has accquired the relevant key pair to build images and use terraform. To get the access keys that will be used by this terraform script,

    - Go to AWS EC2 dashboard under the Network and Security.
    - Chose the key pair you want to use for the terraform scripts

- Now that we have the name of the key pair, got to `variables.tf` and change `ssh_key` variable name from   

`variable "ssh_key" {
  default = "new-cp3-api-key-pair"
}`

to suit your own.

`variable "ssh_key" {
  default = "your-key-pair-name"
}`

- Build AMI images using packer and using ansible as the provisioning tool. The are two options for this.

    - Build your own AMI but MUST assign them names starting with `FRONTEND` for the frontend application and `API` for the api.
    - Use existing AMIs to provision the applications. 

 I would reccomend using the packer and ansible scripts found on this github repo found [HERE](https://github.com/mirr254/change-management). Foolow the instructions on that repo to build the required AMIs.


# Using this Repo

Building a custom network in AWS can be a very time consuming task. This repo tries to create a custom network using `terraform` scripts to automate the process. 

We are building a custom network with 2 public subnets, 1 private subnet, internet gateway, load balancer and setting up applications to run on that infrastructure. 

The applications are frontend app built using react, a database server and an API app built using python-flask. The frontend application is hosted in 2 public subnets in different zones. This helps in increasing redundacy and increase uptime for our application.

The load balancer is internet facing and routes traffic to the frontend applications with respect to the health of the frontend applications. If any instnace in a different zone is not healthy - That means is not accepting and responding to the requests - the load balancer routes the traffic to the other application that is healthy.

The API server is hosted in private subnet and the it can only be communicated to via the public subnet. Thus, the API server cannot be accessed directly from the internet. The same case applies to the database server.

The frontend application is getting and supplying data from/to the API server.

# Instructions for use.

- installing terraform.   
Find the [appropriate package](https://www.terraform.io/downloads.html) for your system and download it.

- After download, unzip the package.

- Make sure `terraform' binary is available on the PATH. For mac and Linux users, check [this link](https://stackoverflow.com/questions/14637979/how-to-permanently-set-path-on-linux). For windows users check [this link](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows).
- To verify the installation   
` $ terraform    
    Usage: terraform [--version] [ --help] < command > [args]`
- Clone this repo and `cd` to the project folder and run the following commands to build the required infrascture  
`terraform apply` and when prompted to confirm type yes.
- After the build is finished and infrastracture created go to the AWS console and look for the `load balancer` that has been created. Since we are not accessing the frontend apps directly we will be using the load balancer dns name to access them. 
- Copy the load balancer `DNS NAME` and test using any browser.