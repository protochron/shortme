defmodule Shortme.Dynamo do
  require Logger

  @default_length 6
  @salt "8229953145"

  # The Erlcloud AWS library is awful and we need to grab the Erlang record like so
  require Record
  Record.defrecord :aws_config, Record.extract(:aws_config, from_lib: "erlcloud/include/erlcloud_aws.hrl")

  require Hashids
  def insert(url) do
    hashlib = Hashids.new(salt: @salt)

    case :erlcloud_ddb2.update_item("ShortmeCounter", [{"Id", {:n, 0}}], "set UrlCount = UrlCount + :num", [{:expression_attribute_values, [{":num", 1}]}, {:return_values, :all_old}], Shortme.Dynamo.get_aws_config()) do
      {:ok, x} ->
        id = Enum.into(x, %{})["UrlCount"]
    end

    # Get the short URL we should use here
    key = Hashids.encode(hashlib, id)

    case :erlcloud_ddb2.put_item(table_name(), [{"Id", {:s, key}}, {"Url", {:s, url}}], [],
      get_aws_config) do
        {:ok, []} ->
          {:ok, key}
        {:error, x} ->
          {:error, x}
      end

  end

  def retrieve(key) do
    case :erlcloud_ddb2.get_item(table_name(), {"Id", {:s, key}}, [],
      get_aws_config) do
        {:ok, []} ->
          []
        {:ok, x} ->
          x
        {:error, _} ->
          :error
      end
  end

  # Get the name of the DynamoDB table to use for the app.
  # Defaults to 'Shortme' unless the 'DYNAMO_TABLE_NAME' environment variable is set.
  defp table_name do
    case System.get_env("DYNAMO_TABLE_NAME") do
      nil -> "Shortme"
      name -> name
    end
  end

  # Get the AWS config from the environment
  # Override it and use an instance of DynamoDB Local if an environment variable is set.
  def get_aws_config do
    case System.get_env("USE_DYNAMODB_LOCAL") do
      nil -> aws_config()
      _ ->
        aws_config(ddb_host: '127.0.0.1',
          ddb_scheme: 'http://',
          ddb_port: 8000,
          access_key_id: '123',
          secret_access_key: '123')
    end
  end
end
