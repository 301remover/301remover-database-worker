defmodule DatabaseWorker.AmqpConnection do
  def start_link() do
    params = Application.get_env(:database_worker, :amqp)
    {:ok, conn} = Freddy.Connection.start_link(params)
    {:ok, _server} = DatabaseWorker.RPCServer.start_link(conn)
  end
end
