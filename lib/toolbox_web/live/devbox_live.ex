defmodule ToolboxWeb.DevBoxLive do
  use ToolboxWeb, :live_view
  alias Toolbox.Devbox
  alias Toolbox.Gcp.CloudEngine.InstanceStatus

  @status_interval 1000

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(@status_interval, self(), :status)
    end

    {:ok, assign(socket, devbox: nil, status: nil, status_color: "coolGray")}
  end

  def render(assigns) do
    ~L"""
      <div class="bg-coolGray-100 py-10 px-4 min-h-full">
        <%= unless @devbox == nil do %>
          <div class="flex justify-center align-center items-center">

            <svg class="text-<%=#{@status_color}%>-500 h-6 animate-pulse" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M2 5a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2V5zm14 1a1 1 0 11-2 0 1 1 0 012 0zM2 13a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2v-2zm14 1a1 1 0 11-2 0 1 1 0 012 0z" clip-rule="evenodd" />
            </svg>

            <h2 class="ml-2 text-3xl text-coolGray-500 font-semibold"> DevBox </h2>
          </div>

          <div class="my-10 mx-2 flex flex-col">
            <p> <%= @status %> </p>
            <button phx-click="off" class="my-4 px-4 py-2 bg-lightBlue-500 text-coolGray-100">Turn Off</button>
          </div>

          <%# if InstanceStatus.is_booting(@status) do %>

          <%# if InstanceStatus.is_running(@status) do %>

          <%# if InstanceStatus.is_stopping(@status) do %>

          <%# if InstanceStatus.is_terminated(@status) do %>

          <button phx-click="on" class="my-4 px-4 py-2 bg-lightBlue-500 text-coolGray-100">Turn On</button>
          <button phx-click="off" class="my-4 px-4 py-2 bg-lightBlue-500 text-coolGray-100">Turn Off</button>
      <% end %>
      </div>
    """
  end

  def handle_info(:status, socket) do
    {:ok, devbox} = Devbox.get_status()
    status = devbox["status"]

    status_color =
      cond do
        InstanceStatus.is_booting(status) -> "amber"
        InstanceStatus.is_running(status) -> "green"
        InstanceStatus.is_stopping(status) -> "orange"
        InstanceStatus.is_terminated(status) -> "red"
        true -> "red"
      end

    socket = assign(socket, devbox: devbox, status: devbox["status"], status_color: status_color)

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
