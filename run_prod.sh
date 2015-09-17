#!/bin/bash
mix deps.get
mix deps.compile

npm install
./node_modules/brunch/bin/brunch build --production

sudo MIX_ENV=prod mix phoenix.digest
sudo PORT=80 MIX_ENV=prod mix phoenix.server
