defmodule DatabaseWorker.RPCServer do
  use Freddy.RPC.Server
  alias DatabaseWorker.Storage
  alias DatabaseWorker.RPCClient

  import Freddy.RPC.Server, only: [ack: 1, reply: 2]

  def start_link(conn) do
    config = [
      exchange: [name: "301remover", type: :direct, opts: [durable: false]],
      queue: [name: "bit.ly"],
      routing_keys: ["bit.ly"],
      binds: [[routing_key: "bit.ly"]],
      # this is protection from DoS
      qos: [prefetch_count: 100],
      # this enables manual acknowledgements
      consumer: [no_ack: false]
    ]

    Freddy.RPC.Server.start_link(__MODULE__, conn, config, [])
  end

  @impl true
  def handle_request(request, meta, state) do
    shortener = meta[:routing_key]
    resolved = Storage.get_url(shortener, request)

    resolved =
      case resolved do
        nil ->
          task = Task.async(RpcClient, :request, [RpcClient, shortener, request])

          case Task.await(task) do
            {:ok, i} ->
              Storage.put_url(shortener, request, i)
              i

            {:error, msg} ->
              # TODO: Return an error thru RPC to the server
              IO.puts(msg)
              nil
          end

        _ ->
          resolved
      end

    ack(meta)
    {:reply, resolved, state}
  end
end
