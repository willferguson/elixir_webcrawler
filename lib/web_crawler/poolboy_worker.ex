defmodule WebCrawler.PoolboyWorker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  #TODO - this should be handle_cast
  def handle_call({:crawl, url}, _from, state) do
    IO.puts("process #{inspect(self())} crawling #{url}")
    results = WebCrawler.PageCrawler.crawl(url)

    WebCrawler.Storage.submit_page(WebCrawler.Storage, results)

    {:reply, [], state}
  end

end
