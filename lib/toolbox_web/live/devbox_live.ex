defmodule ToolboxWeb.DevBoxLive do
  use ToolboxWeb, :live_view
  alias Toolbox.AWS.EC2

  @devbox_id Application.get_env(:toolbox, :debox_id, nil)

  # @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, assign(socket, query: "", results: %{})}
  # end

  # @impl true
  # def handle_event("suggest", %{"q" => query}, socket) do
  #   {:noreply, assign(socket, results: search(query), query: query)}
  # end

  # @impl true
  # def handle_event("search", %{"q" => query}, socket) do
  #   case search(query) do
  #     %{^query => vsn} ->
  #       {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

  #     _ ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:error, "No dependencies found matching \"#{query}\"")
  #        |> assign(results: %{}, query: query)}
  #   end
  # end

  # defp search(query) do
  #   if not ToolboxWeb.Endpoint.config(:code_reloader) do
  #     raise "action disabled when not in development"
  #   end

  #   for {app, desc, vsn} <- Application.started_applications(),
  #       app = to_string(app),
  #       String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
  #       into: %{},
  #       do: {app, vsn}
  # end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :status)
    end

    {:ok, assign(socket, devbox: EC2.instance_by_id(@devbox_id))}
  end

  def render(assigns) do
    ~L"""
      <div>
        <p>DevBox Status: <%= @devbox.instance_state %></p>
        <%= if @devbox == nil do %>
          <p> DevBox Is Asleep... </p>
          <button phx-click="on">Turn On</button>
          <% else %>
          <button phx-click="off">Turn Off</button>
        <% end %>

        <p>
          Live Status Poll: <%= @devbox.req_id %>
        </p>
      </div>
    """
  end

  def handle_info(:status, socket) do
    devbox = EC2.instance_by_id(@devbox_id)
    socket = assign(socket, devbox: devbox)

    {:noreply, socket}
  end

  def handle_event("on", _value, socket) do
    EC2.start(@devbox_id)
    {:noreply, socket}
  end

  def handle_event("off", _value, socket) do
    EC2.stop(@devbox_id)
    {:noreply, socket}
  end

  def handle_event("restart", _value, socket) do
    EC2.reboot(@devbox_id)
    {:noreply, socket}
  end
end
