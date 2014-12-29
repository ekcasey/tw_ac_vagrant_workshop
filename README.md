Chef Tutorial
=============


Prerequisites
----------------------------  

install Sublime from http://www.sublimetext.com/2 (optional)  
install vagrant from https://www.vagrantup.com/downloads  
install virtualbox from https://www.virtualbox.org/wiki/Downloads  
install chef-dk from https://downloads.chef.io/chef-dk/mac/#/  

Let's verify that these instalations were successful. The following command should return 1.7.1 or greater
```
vagrant --version 
````

The following command should open up the virtualbox manager application 
```
virtualbox
````  

The chef-dk includes chef, test-kitchen, and berkshelf. To verify that all of these were installed properly run
```
chef --version //>=3.2.1  
kitchen --version //>=1.2.1  
berks --version //>=3.2.1 
```

Cloning the repo
----------------

First clone the workshop repo    
`$ git clone git@github.com:ekcasey/tw_ac_vagrant_workshop.git`    

This repo contains two directories. The 'app' directory includes a ruby app called Minions. Our goal is to use Chef to provision a virtual machine machine so that it can run the Minions app. Take a minute to inspect the app directory. The cookbook directory will hold our chef code.


Setting up the Local Environment
----------------------------

### Cookbook Boilerplate

review the metadata.rb

```
name    'wdiy'
version '0.0.1'
```

cookbook directory structure  

cookbook  
/attributes  
/recipes  
/templates 

### Setting Up Berkshelf  

Berkshelf is a dependency manager for Chef. The cookbook we write will depend on cookbooks written by the chef community. You wil notice that an empty Berksfile has been created for you. Berkshelf uses the Berksfile to determine what dependencies to fetch and where to fetch these dependencies from. Add the following lines to your Berksfile.  

Berksfile

```
source 'https://supermarket.getchef.com'

metadta
```

The first line tells Berkshelf to fetch cookbooks from the chef supermarket. The second line tells Berkshelf to inspect the cookbook's metadata file to determine dependencies (don't worry we will try this out later). To make sure your Berksfile is set up correctly, make sure the following command executes without errors (nothing will be downloaded because we haven't specified any dependencies yet).  

`$ berks install`  

###  Setting Up Test Kitchen

To borrow directly from the test-kitchen project 'Test Kitchen is an integration tool for developing and testing infrastructure code and software on isolated target platforms'. What this means is that test-kitchen is the glue that holds our toolchain together. The kitchen command line tool allows you to create virtual machines using vagrant or another driver, upload your cookbook and its dependencies to that machine using berkshelf, apply your cookbook using chef, and then verify the state of the machine using minitest or another testing framework (we won't actaully try testing today). We have already configured test-kitchen for this project, But lets take a moment to look at the key pieces of the .kitchen.yml file...  
  
```
driver:
  name: vagrant
```
We have specified that we will use vagrant (on top of virtualbox) as a driver. This means that the instances that kitchen creates will be local vagrant instances.  

```
provisioner:
  name: chef_solo
```

We have specified that we will be using chef_solo as a provisioner (don't worry too much about this for now)

```
platforms:
  - name: centos-6.4
    driver:
      box: centos65-x86_64-20140116
```
The above lines specifies the type of instance kitchen should create. We will be testing our cookbook on  centos-6.4 image. The last 2 lines tell test-kitchen which base image to use when creating instances. We need to download this image so that it is available to test-kitchen   

Lets download the base box...  

```
$ vagrant box add centos65-x86_64-20140116 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box
```

Finally lets take a look at the suites section of the .kitchen.yml 
```
suites:
  - name: wdiy
```

Here we have defined one suite named wdiy.

The first important test-kitchen command you should know is `kitchen list`. This prints out the instances that kitchen knows about. When you run `kitchen list` it should list a single instances named 'wdiy-centos-64' that is currently '<Not Created>'

The next important command is `kitchen create`. This will create that instance but will not yet apply the cookbook. Let's try running it now...
 
`$ kitchen create`  

This command should execute succesfully and create your virtual machine. To verify that the virtual machine was successfully create open virtual manager and look for an instance with the name  'wdiy-centos-64'.

Next, we want to ssh into our newly created virtual machine. To do this run the following command
```
$ kitchen login
```  

Now you are logged into the virtual machine! Your command prompt should have changed to indicate this. From now on we will call this machine the VM or th guest. Take a moment to look around. Maybe try the following commands...  
```
$ whoami  
$ hostname    
$ ip addr  
```  

now lets return to the host machine  
`$ exit`  

If we run `kitchen list` now, we should see that the status of our instance is Created.
 

Your First Cookbook
-------------------

**Main Objective**: Write a Chef cookbook that will provision an application server for the Minions app.

### Sharing a Folder
How will we get the app code onto the virtual machine? For now, lets share a directory from our host machine with the guest VM. Add the following line to your drvier configuration in .kitchen.yml.
```
  synced_folders:
    - ["../app", "/minions"]
```  

Test whether this worked  
`$ kitchen create wdiy-centos`  
`$ kitchen login`    
`$ cd /`  
`$ ls`  

You should see the minions directory on the virtual machine  

```
$ cd minions   
$ ls
```

### Install Ruby With Chef

Since this is a ruby app we must install ruby on the guest box in order to run the Minions app. 

We are going to use the rbenv cookbook to install ruby. First we need to add the rbenv cookbook as a dependency in our metadata file. Add the following line to metadata.rb

```
depends 'rbenv', '1.7.1'
```

Take a moment to look at the rbenv cookbook documentation https://supermarket.chef.io/cookbooks/rbenv/versions/1.4.1

Now we can use the rbenv_ruby resource to install ruby globally on the vagrant machine. First let's create a defualt.rb file in the recipes directory

`touch recipes/default.rb`

Now add the following lines to this file

```
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
```

Now all of the resource types defined in the rbenv cookbook are available to us. Lets use the rbenv_ruby resource. Add the following line to your default.rb

```
rbenv_ruby '2.1.1' do
  global true
end
```

Now we must add our cookbook to the vagrant runlist. Add the following attribute to the wdiy suite in .kitchen.yml
```
    run_list:
      - wdiy
```

Now lets apply the coobook to the instance
```
$ kitchen converge
```


Run `$ kitchen login default centos` to ssh into the box.  
On the vagrant machine run `ruby --version`  
The command should print 2.1.1 to the console.  
`$ exit`

Now lets set up forwarded ports. Add the following line to your .kitchen.yml. We will validate that this works later.

```
  network:
    - ["forwarded_port", {guest: 4567, host: 4567}]
```  

exercise: Extract the ruby version into an attribute
http://docs.chef.io/attributes.html  

exercise: using the rbenv cookbook documentation, install bundler  

Start application. You should see a database error.

Install Mysql With Chef

Create Minion Database  








