defmodule Shortme.PageController do
  use Shortme.Web, :controller
  alias Shortme.Endpoint
  require Logger

  def index(conn, %{"url" => url}) do
    result = Shortme.Dynamo.insert(url)
    case result do
      {:ok, id} ->
        url = "#{page_url(Endpoint, :index)}#{id}"
        conn
        |> put_flash(:info, "Your short link is: <a href=#{url}>#{url}</a>")
        |> render("index.html", :short_link => url)

      {:error, _} ->
        conn
        |> put_flash(:error, "Unable to shorten your link! Try again later")
        |> render("index.html")
    end
  end

  def index(conn, _params) do
    render conn, "index.html"
  end


  # Lookup key in Dynamo and redirect if found, otherwise render base page with an error
  def show(conn, %{"id" => id}) do
    case Shortme.Dynamo.retrieve(id) do
      :error ->
          conn
          |> put_flash(:error, "Looks like we're having a problem right now. Try again later!")
          |> render("index.html")
      [] ->
          conn
          |> put_flash(:error, "Unable to find #{id}. Want to create a new short link?")
          |> render("index.html")
      result ->
          r = Enum.into(result, %{})
          conn
          |> redirect external: r["Url"]
      end
  end
end
