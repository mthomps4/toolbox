# defmodule ToolboxWeb.DevBoxLive do
#   use ToolboxWeb, :live_view
#   alias Toolbox.AWS.EC2

#   @devbox_id Application.get_env(:toolbox, :debox_id, nil)
#   @status_interval 1000

#   def mount(_params, _session, socket) do
#     if connected?(socket) do
#       :timer.send_interval(@status_interval, self(), :status)
#     end

#     {:ok, assign(socket, devbox: EC2.instance_by_id(@devbox_id))}
#   end

#   def render(assigns) do
#     ~L"""
#       <div>
#         <p>DevBox Status: <%= @devbox.instance_state %></p>
#         <%= if @devbox == nil do %>
#           <p> DevBox Is Asleep... </p>
#           <button phx-click="on">Turn On</button>
#           <% else %>
#           <button phx-click="off">Turn Off</button>
#         <% end %>

#         <p>
#           Live Status Poll: <%= @devbox.req_id %>
#         </p>
#       </div>
#     """
#   end

#   def handle_info(:status, socket) do
#     devbox = EC2.instance_by_id(@devbox_id)
#     socket = assign(socket, devbox: devbox)

#     {:noreply, socket}
#   end

#   def handle_event("on", _value, socket) do
#     EC2.start(@devbox_id)
#     {:noreply, socket}
#   end

#   def handle_event("off", _value, socket) do
#     EC2.stop(@devbox_id)
#     {:noreply, socket}
#   end

#   def handle_event("restart", _value, socket) do
#     EC2.reboot(@devbox_id)
#     {:noreply, socket}
#   end

#   def handle_event("status", socket) do
#     {:noreply, socket}
#   end
# end
