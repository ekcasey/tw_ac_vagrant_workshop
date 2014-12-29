Chef Tutorial
=============


Prerequisites
----------------------------
install Sublime from http://www.sublimetext.com/2 (optional)
install vagrant from https://www.vagrantup.com/downloads  
install virtualbox from https://www.virtualbox.org/wiki/Downloads  
install chef-dk from https://downloads.chef.io/chef-dk/mac/#/

Let's verify that these instalations were successful. The following command should return 1.7.1 or greater
`vagrant --version `

The following command should open up the virtualbox manager application 
`virtualbox`  

The chef-dk includes chef, test-kitchen, and berkshelf. To verify that all of these were installed properly run
`chef --version //>=3.2.1`  
`kitchen --version //>=1.2.1`  
`berks --version //>=3.2.1`  


Cloning the repo
----------------

First clone the workshop repo    
`$ git clone git@github.com:ekcasey/tw_ac_vagrant_workshop.git`    

This repo contains two directories. The 'app' directory includes a ruby app called Minions. Our goal is to use Chef to provision a virtual machine machine so that it can run the Minions app. The cookbook directory will hold our chef code.


Setting up the Local Environment
----------------------------

### Install Ruby

Chef is a DSL built on top of ruby. We will install ruby with rbenv.     
`$ brew install rbenv`  
`$ brew install ruby-build`  
`$ rbenv install 2.1.1`  
`$ rbenv local 2.1.1`  

Now we want rbenv to hook into the shell so that the correct version of ruby is used automatically. To accomplish this run the following command and follow the instructions it returns.  
`$ rbenv init`  

Now, to verify that the above steps worked ask ruby for its version and verify that it returns 2.1.1.  
`$ ruby --version //2.1.1`


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

Lets download the base box...

`$ vagrant box add centos65-x86_64-20140116 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box  `

then run
`$ kitchen create`  

this should create your virtual machine  
`$ kitchen login`  

now you are logged into the viratual machine, take a moment to look around  
maybe try the following commands 
`whoami`  
`hostname`  
`ip`  

now lets return to the host machine  
`$ exit`  

and destroy the virtual


Cookbook Boilerplate
--------------------
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



Hosting Minions on The Virtual Box
----------------------------------
How will we get the app code onto the virtual machin. Lets share a directory with the virtual machine. Add the following line to your drvier configuration.
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

now 
`$ cd minions`  
`$ ls`

The contents of the minions directory should be the same as the app directory on the host machine. These directories will sync. Lets demonstrate that. Open a second terminal tab and navigate to the tw_ac_vagrant_workshop directory. Then run...

`$ echo 'hello' > app/hello.txt`

Now return to your vagrant tab and 'ls' again. You should see hello.txt in the minion directory. Now lets clean up 
`$ rm hello.txt`

Now lets set up forwarded ports. Add the following line to your .kitchen.yml. Will will validate that this works later.

```
  network:
    - ["forwarded_port", {guest: 4567, host: 4567}]
```

Your First Cookbook
-------------------


Our goal is to get the app running on the virtual machine. Since this is a ruby app we must first install ruby on the guest box.

Install Ruby With Chef
----------------------  

We are going to use the rbenv cookbook to install ruby. First we need ot add the rbenv cookbook as a dependency in our metadata file 

`depends 'rbenv', '1.7.1'`

Next use Berkshelf to grab this cookbook form the chef supermarket

`$ berks install`

Berkshelf has now downloaded a copy of the rbenv cookbook to your host machine from the chef supermarket. Take a moment to look at the rbenv cookbook documentation https://supermarket.chef.io/cookbooks/rbenv/versions/1.4.1

Now we can use the rbenv_ruby resource to install ruby globally on the vagrant machine. First let's create a defualt.rb file in the recipes directory

`touch recipes/default.rb`

Now add the following lines to this file

```
include_recipe "rbenv::ruby_build"
```

Now all of the resource types defined in the rbenv cookbook are avail to us. Lets use the rbenv_ruby resource. Add the following line to your default.rb

rbenv_ruby '2.1.1' do
  global true
end
```
Now we must add our cookbook to the vagrant runlist
```
    run_list:
      - wdiy
```
Now lets recreate the vagrant
`$ kitchen setup`
This time we are using setup so that the cookbook will be applied.


Run `$ kitchen login default cenotos` to ssh into the box.  
On the vagrant machine run `ruby --version`  
The command should print 2.1.1 to the console.  
`$ exit`  

exercise: Extract the ruby version into an attribute
http://docs.chef.io/attributes.html  

exercise: using the rbenv cookbook documentation, install bundler  

Start application. You should see a database error.

Install Mysql With Chef


Create Minion Database  








