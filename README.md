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

## Run locally
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

## Run in EC2
To run the app in EC2, use the included cfn.json file to spin up the required AWS resources.
The template provisions:

* A t2.micro instance with a mounted 10gb gp2 (SSD) volume
* 2 DynamoDB tables (ShortmeDynamo and ShortmeDynamoCounter)
* An EC2 instance role with the following permissions on the two DynamoDB tables:
  * CreateTable
  * GetItem
  * PutItem
  * UpdateItem
* A security group with the following open ports:
  * 22
  * 80

