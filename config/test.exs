use Mix.Config

config :database_worker, DatabaseWorker.RPCServer,
  host: "localhost",
  username: "301remover",
  password: "your_password_here",
  virtual_host: ""
