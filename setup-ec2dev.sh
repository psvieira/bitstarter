#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# sudo apt-get install -y git
# sudo apt-get install -y curl

# Install nvm: node-version manager - https://github.com/creationix/nvm
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs - http://jshint.com/
sudo npm install -g jshint

# Install rlwrap to provide readline features with node - http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install node packages - requires updated package.json file
npm install

# Install Heroku toolbelt - https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# export PATH=/usr/local/heroku/bin:$PATH # Heroku: https://toolbelt.heroku.com/standalone

# Set up postgres db for local debugging. Unlike MySQL, PostgreSQL makes it harder to set 
# blank passwords or set passwords from the command line. See here for background:
# stackoverflow.com/questions/5421807/set-blank-password-for-postgresql-user
# dba.stackexchange.com/questions/14740/how-to-use-psql-with-no-password-prompt
# postgresql.1045698.n5.nabble.com/assigning-password-from-script-td1884293.html
#
# Thus what we'll do is use the .pgpass file as our single point of
# truth, for both setting up postgres and then accessing it later via
# sequelize. We can also symlink this file into the home directory.

# Install postgres
sudo apt-get install -y postgresql postgresql-contrib

# Set environment variables for ec2dev from .env-local file (not under git control)
source .env-local

# Now set up the users
#
# If you don't type in the password right, easiest is to change the value in
# pgpass and try again. You can also delete the local postgres db
# if you know how to do that. 
echo -e "\n\nINPUT THE FOLLOWING PASSWORD TWICE BELOW: "${DB_PASS}
sudo -u postgres createuser -U postgres -E -P -s $DB_USER
sudo -u postgres createdb -U postgres -O $DB_USER $DB_NAME

# Test that it works.
# Note that the symlinking of pgpass into $HOME should pass the password to psql and make these commands work. 
echo "CREATE TABLE phonebook(phone VARCHAR(32), firstname VARCHAR(32), lastname VARCHAR(32), address VARCHAR(64));" | psql -d $PG_DB -U $PG_USER
echo "INSERT INTO phonebook(phone, firstname, lastname, address) VALUES('+1 123 456 7890', 'John', 'Doe', 'North America');" | psql -d $PG_DB -U $PG_USER
