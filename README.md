# Shortme

## Install

First, install Elixir:

* Mac

      brew install elixir

* Ubuntu

      wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
        && sudo dpkg -i erlang-solutions_1.0_all.deb
      sudo apt-get update
      sudo apt-get install -y elixir

## Run
To run against a local version of DynamoDB:

  * Install [Dynamodb local](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html)
      * Mac

            brew install dynamodb-local
            dynamodb-local -sharedDb -inMemory
    * Linux

          wget http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz \
            && tar -xvf dynamodb_local_2015-07-16_1.0.tar.gz
          java -jar DynamoDBLocal.jar -sharedDb -inMemory

  * `export USE_DYNAMODB_LOCAL=true` so that the app knows to connect to the development database.


To start the app:

  1. Install dependencies with `mix deps.get`
  2. Start Phoenix endpoint with `mix phoenix.server`


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
