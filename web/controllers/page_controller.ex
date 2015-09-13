defmodule Shortme.PageController do
  use Shortme.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
