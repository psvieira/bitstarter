#!/bin/bash

echo -e "\n\nNOW ENTER YOUR HEROKU PASSWORD"
# Set up heroku.
# - devcenter.heroku.com/articles/config-vars
# - devcenter.heroku.com/articles/heroku-postgresql
heroku login
# heroku create
# ssh-keygen -t rsa
# heroku keys:add
heroku addons:add heroku-postgresql:dev
heroku plugins:install git://github.com/ddollar/heroku-config.git

# Setup heroku configuration variables from 2 sources:
# - from .env-heroku for COINBASE_API_KEY and PORT
# - from heroku pg:promote command for DATABASE_URL
# https://devcenter.heroku.com/articles/config-vars
cp .env-heroku .env
heroku pg:promote `heroku config  | grep HEROKU_POSTGRESQL | cut -f1 -d':'`

STRING=$( cat <<EOF
Now do the following:\n\n

1) To deploy to heroku-staging\n
     $ git push heroku-staging\n
     $ heroku config:push --app heroku-staging\n
   Then check the corresponding Heroku URL\n\n
2) To deploy to heroku-production\n
	 $ git push heroku-production\n
	 $ heroku config:push --app heroku-production\n
EOF
)
echo -e $STRING
