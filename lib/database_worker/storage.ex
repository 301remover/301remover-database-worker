defmodule DatabaseWorker.Storage do
  use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def get_url(shortener, shortcode) do
    GenServer.call(__MODULE__, {:get_url, shortener, shortcode})
  end

  def put_url(shortener, shortcode, url) do
    GenServer.call(__MODULE__, {:put_url, shortener, shortcode, url})
  end

  # Server (callbacks)

  @impl true
  def init(path) do
    # TODO: these domain names should be fetched from the server
    dbs = %{
      "bit.ly" => [],
      "tinyurl.com" => [],
      "adf.ly" => []
    }

    # always force creation of the enviroment so new DBs can be added. this
    # will not delete the existing DB, it will only recreate the
    # config.exmdb file
    Exmdb.create(path, force: true, dbs: dbs)
  end

  @impl true
  def handle_call({:get_url, shortener, shortcode}, _from, env) do
    res = Exmdb.get(env, shortcode, nil, db: shortener)
    {:reply, res, env}
  end

  @impl true
  def handle_call({:put_url, shortener, shortcode, url}, _from, env) do
    Exmdb.put(env, shortcode, url, db: shortener)
    {:reply, nil, env}
  end
end
