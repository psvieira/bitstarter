#!/bin/bash

echo -e "\n\nNOW ENTER YOUR HEROKU PASSWORD"
# Set up heroku.
# - devcenter.heroku.com/articles/config-vars
# - devcenter.heroku.com/articles/heroku-postgresql
heroku login
heroku create
ssh-keygen -t rsa
heroku keys:add
heroku addons:add heroku-postgresql:dev
heroku pg:promote `heroku config  | grep HEROKU_POSTGRESQL | cut -f1 -d':'`
heroku plugins:install git://github.com/ddollar/heroku-config.git

# Set up heroku configuration variables
# https://devcenter.heroku.com/articles/config-vars
# - Edit .env to include your own COINBASE_API_KEY and HEROKU_POSTGRES_URL.
# - Modify the .env.dummy file, and DO NOT check .env into the git repository.
# - See .env.dummy for details.

# Set environment variables from .env-heroku file (not under git control)
source .env-heroku

STRING=$( cat <<EOF
Now do the following:\n\n

1) To run the server locally, do:\n
     $ foreman start\n
   Then check your EC2 URL, e.g. ec2-54-213-131-228.us-west-2.compute.amazonaws.com:8080 \n
   Try placing some orders and then clicking '/orders' at the top.\n\n
2) To deploy to heroku\n
     $ git push heroku master\n
     $ heroku config:push\n
   Then check the corresponding Heroku URL\n\n
   Try placing some orders and then clicking '/orders' at the top.\n
EOF
)
echo -e $STRING
