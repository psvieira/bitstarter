#!/bin/bash

echo -e "\n\nNOW ENTER YOUR HEROKU PASSWORD"
# Set up heroku - staging and production evironments.
# - devcenter.heroku.com/articles/config-vars
# - devcenter.heroku.com/articles/heroku-postgresql

# This set of commands only needed if the environments do not exist already
# heroku login
# ssh-keygen -t rsa
# heroku keys:add
# heroku apps:create vegapi-s --remote heroku-staging
# heroku addons:add heroku-postgresql:dev
# heroku plugins:install git://github.com/ddollar/heroku-config.git
# heroku pg:promote `heroku config  --app vegapi-s | grep HEROKU_POSTGRESQL | cut -f1 -d':'` --app vegapi-s

# heroku apps:create vegapi --remote heroku-production
# heroku addons:add heroku-postgresql:dev
# heroku plugins:install git://github.com/ddollar/heroku-config.git
# heroku pg:promote `heroku config  --app vegapi | grep HEROKU_POSTGRESQL | cut -f1 -d':'` --app vegapi

# Setup heroku configuration variables for COINBASE_API_KEY and PORT from .env-heroku
# https://devcenter.heroku.com/articles/config-vars
cp .env-heroku .env

STRING=$( cat <<EOF
Now do the following:\n\n

1) To deploy to heroku-staging\n
     $ git push heroku-staging staging:master\n
     $ heroku config:push --app vegapi-s\n
   Then check the corresponding Heroku URL\n\n
2) To deploy to heroku-production\n
	 $ git push heroku-production master:master\n
	 $ heroku config:push --app vegapi\n
EOF
)
echo -e $STRING
