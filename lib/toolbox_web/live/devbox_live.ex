defmodule ToolboxWeb.DevBoxLive do
  use ToolboxWeb, :live_view
  alias Toolbox.Devbox
  alias Toolbox.Gcp.CloudEngine.InstanceStatus

  @status_interval 1000

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(@status_interval, self(), :status)
    end

    {:ok, assign(socket, devbox: nil, status: nil, id: nil)}
  end

  def render(assigns) do
    ~L"""
      <div>
        <%= unless @devbox == nil do %>
          <p style="color:#CCC"><%= @id %></p>
          <p>DevBox Status: <%= @status %></p>

          <%= if InstanceStatus.is_booting(@status) do %>
            <p> DevBox is booting... please wait.
          <% end %>

          <%= if InstanceStatus.is_running(@status) do %>
            <p> DevBox is running!
            <button phx-click="off">Turn Off</button>
          <% end %>

          <%= if InstanceStatus.is_stopping(@status) do %>
            <p> DevBox is shutting down... please wait.
          <% end %>

          <%= if InstanceStatus.is_terminated(@status) do %>
            <p> DevBox is off.
            <button phx-click="on">Turn On</button>
          <% end %>
        <% end %>
      </div>
    """
  end

  def handle_info(:status, socket) do
    {:ok, devbox} = Devbox.get_status()
    socket = assign(socket, devbox: devbox, status: devbox["status"], id: Ecto.UUID.generate())

    {:noreply, socket}
  end

  def handle_event("on", _value, socket) do
    Devbox.start()
    {:noreply, socket}
  end

  def handle_event("off", _value, socket) do
    Devbox.stop()
    {:noreply, socket}
  end

  def handle_event("status", socket) do
    {:noreply, socket}
  end
end
