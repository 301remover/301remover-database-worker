defmodule DatabaseWorker.AmqpConnection do
  def start_link() do
    params = Application.get_env(:database_worker, :amqp)

    unless "#{Mix.env()}" === "test" do
      {:ok, conn} = Freddy.Connection.start_link(params)
      {:ok, _server} = DatabaseWorker.RPCServer.start_link(conn)
      {:ok, _client} = DatabaseWorker.RPCClient.start_link(conn)
    else
      {:ok, conn} = Freddy.Connection.start_link(adapter: :sandbox)
      {:ok, _server} = MockServer.start_link(conn)
    end
  end
end
