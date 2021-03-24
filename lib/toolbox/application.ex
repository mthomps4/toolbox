defmodule Toolbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    credentials =
      "GOOGLE_APPLICATION_CREDENTIALS_JSON"
      |> System.fetch_env!()
      |> Jason.decode!()

    source = {:service_account, credentials, []}

    children = [
      # Start the Ecto repository
      Toolbox.Repo,
      # Start the Telemetry supervisor
      ToolboxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Toolbox.PubSub},
      # Start the Endpoint (http/https)
      ToolboxWeb.Endpoint,
      # Start a worker by calling: Toolbox.Worker.start_link(arg)
      # {Toolbox.Worker, arg}
      {Goth, name: Toolbox.Goth, source: source},
      {NodeJS.Supervisor, path: "./assets/node_scripts/", pool_size: 4}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Toolbox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ToolboxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
