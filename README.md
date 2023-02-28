# Tech 201 Infrastructure as Code

## What is Infrastructure as Code? (IaC)
Infrastructure as Code is the managing and provisioning of IT infrastructure through code as opposed to manual processes.
With IaC, configuration files are created that contain your infrastructure specifications, which makes it easier to edit and distrubute configurations.

### Types of IaC
There are various ways to have IaC, these include the following:
- **Scripts** - A very direct form of IaC, typically used for simple or one-off tasks.
- **Configuration management tools** - Thes tools implement automation by installing and configuring servers. This type of IaC is designed for more complex tasks as these are specialized tools built to manage software. This is the most common type of IaC and one of the most well known examples is Ansible.
- **Provisioning tools** - This type of has more advantages in complex tasks. These tools implement automation by creating infrastructure.
- **Containers and templating tools** - These tools formulate templates and images pre-loaded with all the libraries and components to run and application. Data distributed with these tools are easy to manage and have a lower overhead compared to running an entire server.

### Why should we use IaC?
Provisioning infrastructure has historically been a time consuming and costly manual process. Adopting a code-based approach makes it easier for organisations to do more in less time.

## Benefits of IaC
Here are some of the benefits of IaC:

### Cost reduction
Every task done contributes to the heavy financial budget of every building team. Most times, the time taken to complete the task results in high pricing. However, since significant tasks, like time-consuming infrastructure configuration, are automated by IaC, the engineers can finish these tasks in no time and focus on other mission-critical tasks.

### Speed
There are many processes in building, monitoring, and managing infrastructure structures, but as IaC has made it possible to automate almost every process, the work can be two times faster. Automation stretches from significant procedures like virtualization to user account management, databases, network management, and even minor operations like adding environments and resources when needed or shutting down when it is not the case. This automation feature promises faster and simpler procedures.

### Reduced human error
On this benefit, there are two descriptions of human errors. The first is the face meaning which implies mistakes made by engineers or IT personnel in the manual process of infrastructure building. The second side to human error is the adaptation of new employees to the infrastructure built by the former IT expert. IaC solves these two issues as automation reduces the risks of human-made mistakes by cutting down long processes. 

### Improved consistency
Infrastructure as Code aids consistency as it helps avoid human errors and incompatibility in activities, like deployment and configuration. IaC improves consistency during these activities by preventing waste of valuable resources, unwanted downtime, and setbacks that can cause inconsistencies in the configuration.

### Eliminating configuration drift
Another critical benefit of infrastructure as code is that it is idempotent. This implies that one can deploy the code many times, with the first deployment being the actual deployment and subsequent deployments having no essential effect.

### Stable and scalable environment
Using IaC, teams can configure their environments according to their specifications rapidly and at scale. As stated earlier, they can also create these environments with sure consistency as they can deploy the configuration several times. These several deployments also make the environment stable, preventing incompatibility caused by configuration drift or missing dependencies.

## Configuration Management
Configuration Management is the process of maintaining systems, such as computer hardware and software, in a desired state. Configuration Management is also a method of ensuring that systems perform in a manner consistent with expectations over time.

## Orchestration
Orchestration is the automated configuration, management, and coordination of computer systems, applications, and services. Orchestration helps IT to more easily manage complex tasks and workflows.

IT teams must manage many servers and applications, but doing so manually isn’t a scalable strategy. The more complex an IT system, the more complex managing all the moving parts can become. The need to combine multiple automated tasks and their configurations across groups of systems or machines increases. That’s where orchestration can help.

## IaC Tools
There are a variety of tools that are used to implement IaC, here are some of the best tools for IaC in 2022:
- Terraform
- Ansible
- AWS CloudFormation
- Azure Resource Manager
- Google Cloud Deployment Manager
- Chef
- Puppet
- SaltStack

### Terraform

### Ansible


# Using Ansible Controller with 3 VMs
Firstly we will create a vagrantfile with the following code to setup 3 Virtual Machines in Virtual Box.
```Ruby
# MULTI SERVER/VMs environment 
 #
 Vagrant.configure("2") do |config|
 # creating are Ansible controller
   config.vm.define "controller" do |controller|
     
    controller.vm.box = "bento/ubuntu-18.04"
    
    controller.vm.hostname = 'controller'
    
    controller.vm.network :private_network, ip: "192.168.33.12"
    
    # config.hostsupdater.aliases = ["development.controller"] 
    
   end 
 # creating first VM called web  
   config.vm.define "web" do |web|
     
     web.vm.box = "bento/ubuntu-18.04"
    # downloading ubuntu 18.04 image
 
     web.vm.hostname = 'web'
     # assigning host name to the VM
     
     web.vm.network :private_network, ip: "192.168.33.10"
     #   assigning private IP
     
     #config.hostsupdater.aliases = ["development.web"]
     # creating a link called development.web so we can access web page with this link instread of an IP   
         
   end
   
 # creating second VM called db
   config.vm.define "db" do |db|
     
     db.vm.box = "bento/ubuntu-18.04"
     
     db.vm.hostname = 'db'
     
     db.vm.network :private_network, ip: "192.168.33.11"
     
     #config.hostsupdater.aliases = ["development.db"]     
   end
 
 
end
```
Then we will use vagrant up to spin up our 3 VMs: `controller`, `web`, `db`. Once our machines are up we need to run the following commands for each machine (we will ssh into each VM to do this):
```
sudo apt update
sudo apt upgrade
```
In our `controller` machine we run the following commands:
```
sudo apt-get install software=properties-common
```
and 
```
sudo apt-add-repository ppa:ansible/ansible
```
Then to install ansible on our controller:
```
sudo apt-get install ansible
```
If we enter `ansible --version` within our controller machine we should get `ansible 2.9.27` in our output.

We then navigate to our hosts file
```
cd /etc/ansible/hosts
```
In hosts, we update the file to include this line to allow the controller to connect to our `web` machine
```
[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```
Then we want to update the ansible configuration file (should be in the same directory) and uncomment the following line:
```
host_key_checking = False
```
Following which we run the command
```
sudo ansible -m ping web
```
If we get the following in our output
```
192.168.33.10 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
This verifies that our controller is able to connect to our `web` machine.


# Sources
https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac#:~:text=choose%20Red%20Hat%3F-,Overview,to%20edit%20and%20distribute%20configurations.

https://www.spiceworks.com/tech/cloud/articles/what-is-infrastructure-as-code/

https://www.vmware.com/topics/glossary/content/configuration-management.html#:~:text=Configuration%20Management%20is%20the%20process,consistent%20with%20expectations%20over%20time.

https://www.redhat.com/en/topics/automation/what-is-orchestration#:~:text=Orchestration%20is%20the%20automated%20configuration,isn't%20a%20scalable%20strategy.

https://www.xenonstack.com/blog/infrastructure-as-code-tools