defmodule WebCrawler do
  use Application

  defp poolboy_config do
    [
      {:name, {:local, :worker}},
      {:worker_module, WebCrawler.PoolboyWorker},
      {:size, 3},
      {:max_overflow, 1}
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config()),
      {WebCrawler.Storage, [%WebCrawler.Storage{}, name: WebCrawler.Storage]}
    ]

    opts = [strategy: :one_for_one, name: Webcrawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
