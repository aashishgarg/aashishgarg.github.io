---
layout: post
share: true
title: "How to setup Rails Server"
modified: 2016-05-06T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2016-05-06T08:20:50-04:00
---

##### First of all a machine is required to deploy an application 

* Login to EC2 Management console.
* Click launch instance.
* Select an Amazon machine image(AMI). We will use ubuntu server.
* Select instance type - "t2.micro"(its free and cheap).
* Default settings are good for the start.
* Configure security group.
* Select or create a keypair to connect to instance. You HAVE to have the private key on your local box in order to ssh into the EC2 instance. The key should live in your ~/.ssh directory.
* Wait for instance to launch.

##### Then you need to ssh your machine through pem file.

* chmod 400 /path_to_pem/pem_file.pem
* ssh -i /path_to_pem/pem_file.pem username@public_dns_of_machine(default username for ubuntu machine is [ubuntu])
* Then add your local machine's id_rsa.pub key to the .ssh/authorized_keys file.
* then, ssh user@ip

###### Till here blank machine is available to make a rails server. Some of the terms that you need to know first.

**CURL** - curl is a tool to transfer data from or to a server, using one of the supported protocols (DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP). The command is designed to work without user interaction.

**Application Server** - An application server exposes business logic to client applications through various protocols, possibly including HTTP

**Web Server** - A Web server handles the HTTP protocol. When the Web server receives an HTTP request, it responds with an HTTP response, such as sending back an HTML page. 

##### Install RVM 

```
sudo apt-get install curl
command curl -sSL https://rvm.io/mpapis.asc | gpg --import
\curl -L https://get.rvm.io | bash -s stable
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bashrc
```

##### Restart machine 

```
type rvm | head -n 1
rvm requirements
rvm install 2.2.2
gem install bundler --no-ri --no-rdoc
sudo apt-get -y install curl git-core
```

##### Install Rake 

```
sudo apt-get install rake
```

##### Install Oracle Java 

```
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
```

##### Install MySql 

```
sudo apt-get update
sudo apt-get install mysql-server mysql-client
sudo apt-get install libmysqlclient-dev
```

##### Install RMagic dependencies 

```
sudo apt-get install imagemagick
sudo apt-get install libmagickwand-dev
```

##### Install Nokogiri dependencies  

```
sudo apt-get install libxslt-dev libxml2-dev
```


Till here major required dependencies are installed on machine to work on.

**If rails application created does not have any view then create an index.html in public folder of application. By default this page will be rendered and if application has views then delete this file. Then only application views will be rendered.**


Here you need to choose one deployment tool out of Capistrano or mina or any other.

For here we will go ahead with **MINA**

Compare this to the capistrano, where each command is run separately on their own SSH sessions. Mina only creates one SSH session per deploy, minimizing the SSH connection overhead.


##### Install gem MINA  

```
 gem install mina
```

##### Initialize mina   

```
# ================================================================================================================= #
comment '<<-------------- Requiring all files -------------------------->>'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'yaml'
require 'io/console'

%w(base nginx mysql check crontab log_rotate product_deployment_sheet).each do |pkg|
  require "#{File.join(__dir__, 'recipes', pkg)}"
end
# ================================================================================================================= #
comment '<<-------------- Setting all variables ------------------------>>'
set :application, 'honeyDewMelon'
set :user, 'deploy'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :repository, repository_url
set :branch, set_branch
set :_rvm_path, "/home/deploy/.rvm/scripts/rvm"
set :sheet_name, 'Product deployment status'
set :ruby_version, "#{File.readlines(File.join(__dir__, '..', '.ruby-version')).first.strip}"
set :gemset, "#{File.readlines(File.join(__dir__, '..', '.ruby-gemset')).first.strip}"

set :sheet_name, 'Product deployment status'
set :work_sheet_name, 'HeartRate_HoneyDewMelon'

# These folders will be created in [shared] folder and referenced through symlinking from current folder.
set :shared_dirs, fetch(:shared_dirs, []).push('public/system')

# These files will be created in [shared] folder and referenced through symlinking from current folder.
set :shared_files, fetch(:shared_file, []).push('config/database.yml',
                                                'config/secrets.yml',
                                                'config/slack_notifier.yml',
                                                'config/memcache_settings.yml')
set :term_mode, :nil
set :ubuntu_code_name, 'xenial' # To find out - (`lsb_release --codename | cut -f2`).

# ================================================================================================================= #
task :environment do
  comment '<<-------------- Setting the Environment ---------------------->>'
  set :rails_env, ENV['on'].to_sym unless ENV['on'].nil?
  require "#{File.join(__dir__, 'deploy', "#{fetch(:rails_env)}_configurations_files", "#{fetch(:rails_env)}.rb")}"
end

# ================================================================================================================= #
task set_sudo_password: :environment do
  set :sudo_password, ask_sudo
  command "echo '#{erb(File.join(__dir__, 'deploy', "#{fetch(:rails_env)}_configurations_files", 'sudo_password.erb'))}' > /home/#{fetch(:user)}/SudoPass.sh"
  command "chmod +x /home/#{fetch(:user)}/SudoPass.sh"
  command "export SUDO_ASKPASS=/home/#{fetch(:user)}/SudoPass.sh"
end

# ================================================================================================================= #
desc 'Restart passenger server'
task :restart => :environment do
  # invoke :set_sudo_password
  invoke :'crontab:install'
  command %[sudo -A service nginx restart]
  comment '<<---------------- Start Passenger ------------------->>'
  command %[mkdir -p #{File.join(fetch(:current_path), 'tmp')}]
  command %[touch #{File.join(fetch(:current_path), 'tmp', 'restart.txt')}]
  invoke :'product_deployment_sheet:update'
end

# ================================================================================================================= #
task :'use:rvm', :env do |_, args|
  comment '<<*************************************************************************>>'
  comment '<<************ Ruby Version Manager not found so installing RVM  **********>>'
  comment '<<*************************************************************************>>'

  comment '<<----------- 1 ---------------------------------------------------------- >>'
  command %[gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3]
  comment '<<----------- 2 ---------------------------------------------------------- >>'
  command %[curl -sSL https://get.rvm.io | bash -s stable]
  comment '<<----------- 3 ---------------------------------------------------------- >>'
  command %[source "#{fetch(:_rvm_path)}"]
  comment '<<----------- 4 ---------------------------------------------------------- >>'
  command %[rvm autolibs disable]
  comment '<<----------- 4.1 ---------------------------------------------------------- >>'
  command %[rvm pkg install zlib]
  comment '<<----------- 5 ---------------------------------------------------------- >>'
  command %[rvm requirements]
  comment '<<----------- 6 ---------------------------------------------------------- >>'
  command %[rvm install "#{fetch(:ruby_version)}"]

  comment '<<*************************************************************************>>'
  comment '<<************ RVM Setup Done  ********************************************>>'
  comment '<<*************************************************************************>>'

  comment '<<*************************************************************************>>'
  comment '<<************ Creating New Gemset (Start) ********************************>>'
  comment '<<*************************************************************************>>'

  command %[source #{fetch(:_rvm_path)}]
  command %[rvm use #{fetch(:ruby_version)}@#{fetch(:gemset)} --create]
  command %[rvm use #{fetch(:ruby_version)}@#{fetch(:gemset)} --default]
  comment '<<*************************************************************************>>'
  comment '<<************ Creating New Gemset (End) **********************************>>'
  comment '<<*************************************************************************>>'
end

# ================================================================================================================= #
task setup_yml: :environment do
  comment '<<*************************************************************************>>'
  comment '<<************** YML Setup (started) **************************************>>'
  comment '<<*************************************************************************>>'
  Dir[File.join(__dir__, '*.yml.example')].each do |_path|
    command %[echo "#{erb _path}" > "#{File.join(fetch(:deploy_to), 'shared/config',
                                                 File.basename(_path, '.yml.example') +'.yml')}"]
  end
  comment '<<*************************************************************************>>'
  comment '<<************** YML Setup (Done) *****************************************>>'
  comment '<<*************************************************************************>>'
end

# ================================================================================================================= #
task setup_prerequisites: :environment do
  comment '<<*************************************************************************>>'
  comment '<<************** Setup Prerequisites installation (Start) *****************>>'
  comment '<<*************************************************************************>>'

  set :rails_env, ENV['on'].to_sym unless ENV['on'].nil?
  require "#{File.join(__dir__, 'deploy', "#{fetch(:rails_env)}_configurations_files", "#{fetch(:rails_env)}.rb")}"

  ['python-software-properties',
   'libmysqlclient-dev',
   'imagemagick',
   'libmagickwand-dev',
   'nodejs',
   'build-essential',
   'zlib1g-dev',
   'libssl-dev',
   'libreadline-dev',
   'libyaml-dev',
   'libcurl4-openssl-dev',
   'libncurses5-dev',
   'libgdbm-dev',
   'curl',
   'git-core',
   'make',
   'gcc',
   'g++',
   'pkg-config',
   'libfuse-dev',
   'libxml2-dev',
   'zip',
   'libtool',
   'memcached',
   'xvfb',
   'bison',
   'libffi-dev',
   'libpng-dev',
   'openssl',
   'mysql-client',
   # 'mysql-server',
   'mime-support',
   'automake',
   'ruby-dev',
   'nodejs-legacy'
  ].each_with_index do |package, index|
    comment "<<-----------------#{index+1} Installing (#{package}) ------------------>>"
    command %[sudo -A apt-get install -y #{package}]

  end
  comment '<<*************************************************************************>>'
  comment '<<************** Setup Prerequisites installation (End) *******************>>'
  comment '<<*************************************************************************>>'


  comment '<<*********** Creating Project Folder and installing BUNDLER **************>>'
  command %[mkdir "#{fetch(:deploy_to)}"]
  command %[chown -R "#{fetch(:user)}" "#{fetch(:deploy_to)}"]


  comment '<<*************************************************************************>>'
  comment '<<******************* Installing NGINX (Start)  ***************************>>'
  comment '<<*************************************************************************>>'
  invoke :'nginx:install'
  invoke :'nginx:setup'
  invoke :'nginx:restart'
  comment '<<*************************************************************************>>'
  comment '<<******************* Installing NGINX (End)  *****************************>>'
  comment '<<*************************************************************************>>'
end

# ================================================================================================================= #
task setup: :environment do
  invoke :set_sudo_password

  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[mkdir -p "#{fetch(:shared_path)}/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]

  invoke :setup_prerequisites
  invoke :'use:rvm', "ruby-#{fetch(:ruby_version)}@#{fetch(:gemset)}"
  invoke :setup_yml

  comment '<<*************************************************************************>>'
  comment '<<************** Installing BUNDLER in Setup ******************************>>'
  comment '<<*************************************************************************>>'

  command %[gem install bundler --no-ri --no-rdoc]
  command %[sudo -A chown -R deploy /var/lib/gems]
  command %[sudo -A chown -R deploy /usr/local/bin]

  comment '<<*************************************************************************>>'
  comment '<<************** Installing BUNDLER and permissions done ******************>>'
  comment '<<*************************************************************************>>'

  command %[sudo -A reboot]
end

# ================================================================================================================= #
desc 'Deploys the current version to the server.'
task :deploy => :environment do
  comment '<<*************************************************************************>>'
  comment '<<************** Deployment Started ***************************************>>'
  comment '<<*************************************************************************>>'
  deploy do
    invoke :'check:revision'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'mysql:create_database'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
  end
  on :launch do
  end
  invoke :restart
end
# ================================================================================================================= #  
```

##### Now prepare the directory structure in your project   

* Create a deploy folder in config folder in project root.
* Create an environment(Staging in our case) configuration folder in this deploy folder.
* Create following files here.

App -> config -> deploy -> staging_configuraion_files -> staging.rb

```
# Instance Details
set :host_ip, 'your_machine_ip'
set :domain, host_ip
# Rails Environment
set :rails_env, 'staging'
set :ssl_enabled, false
```

App -> config -> deploy -> staging_configuration_files -> sudo_password.erb

```
#!/bin/bash
echo "your deploy user password"
```

* Create recipes folder in config folder (App -> config -> recipes)
* Create following files in recipe folder (App -> config -> recipe -> base.rb)

```
def repository_url
  STDOUT.puts '------------------------------------------------'
  STDOUT.puts '********* Please authenticate yourself! ********'
  STDOUT.puts '------------------------------------------------'
  STDOUT.print "\nEnter username for the code source repository: "
  _user_name = STDIN.gets.strip
  STDOUT.print "Enter password for user [#{_user_name}] :"
  _password = STDIN.noecho(&:gets).strip
  STDOUT.puts "\n\nThanks!"
  "https://#{_user_name}:#{_password}@gitlab.com/path_to/repository.git"
end

def set_branch
  default_branch = `git rev-parse --abbrev-ref HEAD`.chomp
  STDOUT.puts "\nDefault selected Branch for deployment is -> \n"
  STDOUT.puts '------------------------------------------------'
  STDOUT.puts default_branch
  STDOUT.puts '------------------------------------------------'
  STDOUT.print "\nBranch OK ?? If Yes then press [ENTER] else [enter your branch name] :"
  branch = STDIN.gets.strip
  branch = default_branch if branch.empty?
  branch
end

def ask_sudo
  STDOUT.puts '------------------------------------------------'
  STDOUT.print "\n\nEnter the password for SERVER access for user [#{fetch(:user)}]: "
  STDIN.gets.strip
end

def set_user
  default_user = 'deploy'
  STDOUT.puts "username (Default is #{default_user}) :"
  user = STDIN.gets.strip
  user = default_user if user.empty?
  user
end
```

App -> config -> recipe -> check.rb

```
namespace :check do
  desc 'Make sure local git is in sync with remote.'
  task :revision => :environment do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
      puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
      puts 'Run `git push` to sync changes.'
      exit
    end
  end
end
```

App -> config -> recipe -> mysql.rb

```
namespace :mysql do

  desc 'Create a database for this application.'
  task :create_database => :environment do
    command %[echo "cd  #{fetch(:current_path)}; RAILS_ENV=#{fetch(:rails_env)} bundle exec rake db:create"]
  end
end
```

App -> config -> recipe -> nginx.rb

```
namespace :nginx do

  desc 'Install passenger with nginx module'
  task :install => :environment do
    command %[sudo apt-get update]

    command %[sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7]
    command %[sudo -A apt-get install -y apt-transport-https ca-certificates]

    # Add Passenger APT repository
    command %[sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger #{fetch(:ubuntu_code_name)} main > /etc/apt/sources.list.d/passenger.list']
    command %[sudo apt-get update]

    command %[sudo apt-get install -y nginx-extras passenger]
    comment %['-------------------------------------------------------->>>']
    comment %["edit /etc/nginx/nginx.conf and uncomment passenger_root and passenger_ruby. For example, you may see this:"]
    comment %[#passenger_root /some-filename/locations.ini;]
    comment %[#passenger_ruby /usr/bin/passenger_free_ruby;]
    comment %[ '-------------------------------------------------------->>>']
  end

  desc "Setup nginx configuration for this application"
  task :setup => :environment do
    command %[sudo -A su -c "echo '#{erb(File.join(__dir__, 'templates', 'nginx_passenger.erb'))}' > /etc/nginx/sites-enabled/#{fetch(:application)}"]
    command %[sudo -A rm -f /etc/nginx/sites-enabled/default]
  end

  %w[start stop restart].each do |command|
    # command "#{command} nginx"
    task command.to_sym => :environment do
      comment %[sudo service nginx #{command}]
    end
  end
end
```

* Create a new folder templates in recipe folder
* Create file nginx_passenger.erb in templates folder here (App -> config -> recipe -> templates -> nginx_passenger.erb)

```
<% if fetch(:ssl_enabled) %>
    server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    server_name _;

    # SSL configuration
    ssl on;
    ssl_certificate <%= fetch(:cert_path) %>;
    ssl_certificate_key <%= fetch(:cert_key_path) %>;
    ssl_prefer_server_ciphers On;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;

    #Enabling application to being included via the iframes
    add_header X-Frame-Options ALLOW;

    # Enabling passenger for application
    passenger_enabled on;
    # Rails environment for application
    passenger_app_env <%= fetch(:rails_env).to_s %>;


    # Applications root
    root <%= fetch(:deploy_to)%>/current/public;

    location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
    }
    error_page 500 502 504 /500.html;
    error_page 503 @maintenance;

    location @maintenance {
    rewrite ^(.*)\$ /503.html break;
    }

    if (-f \$document_root/../tmp/maintenance.txt) {
    return 503;
    }
    }

    server {
    listen 80;
    rewrite ^/(.*) https://\$host\$request_uri permanent;
    }

<% else %>
    server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    passenger_enabled on;
    passenger_app_env <%= fetch(:rails_env).to_s %>;

    root <%= fetch(:deploy_to)%>/current/public;

    location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
    }
    error_page 500 502 504 /500.html;
    error_page 503 @maintenance;

    location @maintenance {
    rewrite ^(.*)\$ /503.html break;
    }

    if (-f \$document_root/../tmp/maintenance.txt) {
    return 503;
    }
    }
<% end %>

```

###### Now we are ready for the deployment.  

##### Now go the application directory on terminal.

Login to the machine and create the required database manually.

```
  mysql -uroot -p12345
  create database staging_database;
```

##### Run Setup 

```
  $ mina setup on=staging
```

##### Deploy

```
  $ mina deploy on=staging
```
