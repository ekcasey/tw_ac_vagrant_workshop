chef_tutorial
=============


Setting up local environment
----------------------------
install Sublime from http://www.sublimetext.com/2 
install vagrant from https://www.vagrantup.com/downloads  
install virtualbox from https://www.virtualbox.org/wiki/Downloads  
install chef-dk from https://downloads.chef.io/chef-dk/mac/#/

install ruby with rbenv  
`$ brew install rbenv`  
`$ brew install ruby-build`  
`$ rbenv install 2.1.1`  
`$ rbenv local 2.1.1` 
`$ rbenv init`
Follow the instructions returned by this command 
`$ ruby --version //2.1.1`

`gem install bundler`


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


Setting Up Berkshelf
-----------------------


Berksfile

```
source 'https://supermarket.getchef.com'

metadata
```

`$ berks install`


Setting Up Test Kitchen
-----------------------
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

and destroy the virtual machine  
`$ kitchen destroy` 


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








