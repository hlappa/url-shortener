defmodule ShorturlWeb.PageController do
  use ShorturlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
