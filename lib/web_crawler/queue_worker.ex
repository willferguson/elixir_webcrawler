 defmodule WebCrawler.QueueWorker do
  use GenServer
  require Logger
  alias WebCrawler.Storage

  @no_url_sleep_time 1000
  @pool_name "crawler_pool"

  @moduledoc """
    State is name of pool
  """
  def start_link(seed_page) do
    GenServer.start_link(__MODULE__, seed_page)
  end

  def init(seed_page) do
    Logger.info("Creating pool: #{@pool_name} with 5 workers")
    Waterpark.create_pool(@pool_name, 5, {WebCrawler.PageCrawler, :start_link, []})
    Logger.info("Starting QueueWorker with seed page #{seed_page}")

    dispatch(seed_page)
    poll()
    {:ok, @pool_name}
  end

  def handle_info(:poll, state) do
    process()
    {:noreply, state}
  end

  #Kicks off a loop of the server
  defp poll() do
    send(self(), :poll)
    end

  @doc """
  If ready and no running workers
    Grab a url
      if URL is error - exit.
      if URL is good -> dispatch, recurse.
  If ready and running workers
    Grab URL
      if URL is error -> sleep, recurse
      if URL is good -> dispatch, resurse
  If full -> sleep recurse
  """
  def process() do
    [
       free_workers: _free_workers,
       busy_workers: busy_workers,
       queue_size: _queue_size
     ] = Waterpark.status(@pool_name)

    Logger.debug("Current Pool State busy workers: #{busy_workers}")
    process(busy_workers)
  end

  #Worker pool is idle - if we don't have a page to crawl, exit
  defp process(0) do
    url = Storage.get_next_page_to_crawl(WebCrawler.Storage)
    case url do
      {:ok, url} ->
        IO.puts("Found URL #{url}")
        dispatch(url)
        poll()
      {:error, _} ->
        IO.puts("No URLs to crawl, finishing")
        {:ok}
    end
  end

  #Worker pool is working - if we don't have a page to crawl, sleep and try again - we might have something later
  defp process(_busy_workers) do
    url = Storage.get_next_page_to_crawl(WebCrawler.Storage)
    case url do
      {:ok, url} ->
        IO.puts("Found URL #{url}")
        dispatch(url)
        poll()
      {:error, _} ->
        IO.puts("No URLs to crawl but workers still working. Sleeping...")
        :timer.sleep(@no_url_sleep_time)
        poll()
    end
  end

  defp dispatch(url) do
    Logger.info("Dispatching #{url} for crawling")
    Waterpark.enqueue(@pool_name, url)
  end

end
