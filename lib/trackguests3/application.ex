defmodule Trackguests3.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Trackguests3Web.Telemetry,
      Trackguests3.Repo,
      {DNSCluster, query: Application.get_env(:trackguests3, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Trackguests3.PubSub},
      # Start a worker by calling: Trackguests3.Worker.start_link(arg)
      # {Trackguests3.Worker, arg},
      # Start to serve requests, typically the last entry
      Trackguests3Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trackguests3.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Trackguests3Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
