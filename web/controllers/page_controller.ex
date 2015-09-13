defmodule Shortme.PageController do
  use Shortme.Web, :controller
  alias Shortme.PageController, as: SMPC

  # The Erlcloud AWS library is awful and we need to grab the Erlang record like so
  require Record
  Record.defrecord :aws_config, Record.extract(:aws_config, from_lib: "erlcloud/include/erlcloud_aws.hrl")

  def index(conn, _params) do
    render conn, "index.html"
  end

  defp insert(url) do
    #id = generate_hash
    case :erlcloud_ddb2.put_item(SMPC.table_name(), [{"Id", {:s, id}}, {"Url", {:s, url}], [],
      get_aws_config) do
      end
  end

  # Lookup key in Dynamo and redirect if found, otherwise render base page with an error
  def show(conn, %{"id" => id}) do
    case :erlcloud_ddb2.get_item(SMPC.table_name(), {"Id", {:s, id}}, [],
      get_aws_config) do
        {:ok, []} ->
          conn
          |> put_flash(:error, "Unable to find #{id}. Want to create a new short link?")
          |> render("index.html")
        {:ok, x} ->
          result = Enum.into(x, %{})
          conn
          |> redirect external: "http://#{result["Url"]}"
        {:error, _} ->
          conn
          |> put_flash(:error, "Looks like we're having a problem right now. Try again later!")
          |> render("index.html")
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
  defp get_aws_config do
    case System.get_env("USE_DYNAMODB_LOCAL") do
      _ ->
        SMPC.aws_config(ddb_host: '127.0.0.1',
          ddb_scheme: 'http://',
          ddb_port: 8000,
          access_key_id: '123',
          secret_access_key: '123')
      nil -> SMPC.aws_config()
    end
  end

end
