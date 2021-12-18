defmodule Test1805Web.PageController do
  use Test1805Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
