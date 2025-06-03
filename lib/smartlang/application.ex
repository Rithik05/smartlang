defmodule Smartlang.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        SmartlangWeb.Telemetry,
        Smartlang.Repo,
        {DNSCluster, query: Application.get_env(:smartlang, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: Smartlang.PubSub},
        # Start the Finch HTTP client for sending emails
        {Finch, name: Smartlang.Finch},
        # Start a worker by calling: Smartlang.Worker.start_link(arg)
        # {Smartlang.Worker, arg},
        # Start to serve requests, typically the last entry
        SmartlangWeb.Endpoint
      ]
      |> Enum.concat(maybe_start_goth_child(System.get_env("GOTH_CREDS")))
      |> Enum.concat(concache_config())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Smartlang.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def maybe_start_goth_child(nil) do
    Logger.warning(
      "GOTH_CREDS environment variable missing, you must add it to .env.dev with the entire vault value to test auth locally"
    )

    []
  end

  def maybe_start_goth_child(creds) do
    credentials = Jason.decode!(creds)

    source = {:service_account, credentials}

    child = {Goth, name: Smartlang.Goth, source: source}

    [child]
  end

  def concache_config() do
    [{ConCache, Application.fetch_env!(:smartlang, :concache_config)}]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartlangWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
