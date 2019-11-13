defmodule DatabaseWorker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    database_path = Application.get_env(:database_worker, :lmdb)[:database_path]

    children = [
      {DatabaseWorker.Storage, [database_path]},
      worker(DatabaseWorker.AmqpConnection, [])
    ]

    opts = [strategy: :one_for_one, name: DatabaseWorker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
