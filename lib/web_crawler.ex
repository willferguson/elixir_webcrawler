defmodule WebCrawler do
  use Application



  def start(_type, _args) do
    children = [
      Waterpark.Owner,
      WebCrawler.Storage
    ]

    opts = [strategy: :one_for_one, name: Webcrawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
