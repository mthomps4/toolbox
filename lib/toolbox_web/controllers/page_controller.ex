defmodule ToolboxWeb.PageController do
  use ToolboxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
