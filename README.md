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
metadata.rb

```
version '0.0.1'
name    'wdiy'
```

cookbook directory structure

cookbook
/attributes
/recipes
/templates


Setting Up Test Kitchen
-----------------------
Gemfile
```
source 'https://rubygems.org'

gem 'berkshelf'  
gem 'test-kitchen'  
gem 'kitchen-vagrant'
```
`$ bundle install`

Berksfile

```
source 'https://supermarket.getchef.com'

metadata
```

`$ berks install`


`$ kitchen init`

.kitchen.yml

shared folders  
```
  synced_folders:
    - ["vagrant", "/vagrant"]
```  
Test whether this worked  
`$ kitchen setup default-centos`  
`$ kitchen login`    
`$ cd /`  
`$ ls`  

forwarded ports  
```
  network:
    - ["forwarded_port", {guest: 4567, host: 4567}]
```

Your First Cookbook
-------------------

Install Ruby With Chef  

We are going to use the rbenv cookbook to install ruby. First we need ot add the rbenv cookbook as a dependency in our metadata file 

`depends 'rbenv', '1.7.1'`

Next use Berkshelf to grab this cookbook form the chef supermarket

`$ berks install`

Now we can use the rbenv_ruby resource to install ruby globally on the vagrant machine.

```
rbenv_ruby 2.1.1 do
  global true
end
```

Run `$ kitchen setup default-centos` to bring up vagrant and apply the recipe
Run `$ kitchen login default cenotos` to ssh into the box.
On the vagrant machine run `ruby --version`
The command should print 2.1.1 to the console.
`$ exit`

exercise: Extract the ruby version into an attribute  

exercise: using the rbenv cookbook documentation, install bundler  

Start application. You should see a database error.

Install Mysql With Chef


Create Minion Database  








