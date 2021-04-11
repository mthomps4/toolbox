defmodule ToolboxWeb.PageController do
  use ToolboxWeb, :controller
  alias Toolbox.Devbox

  def index(conn, _params) do
    # info = Devbox.get_status()
    # status = info["status"]
    status = 2
    render(conn, "index.html", %{devbox_status: status})
  end
end
