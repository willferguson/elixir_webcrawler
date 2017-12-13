defmodule QueueWorker do

  @timeout 5000
  @no_url_sleep_time 2500

  @doc """


  If ready and no running workers
    Grab a url
      if URL is error - exit.
      if URL is good -> dispatch, recurse.


  If ready and running workers
    Grab URL
      if URL is error -> sleep, recurse
      if URL is good -> dispatch, resurse

  if full - sleep recurse


  """
  def process do
    {pool_state, _, _, running_workers} = :poolboy.status(:worker)
    process(pool_state, running_workers)
  end

  #Worker pool is idle
  defp process(pool_state, running_workers) when (pool_state == :ready) and (running_workers == 0) do
    url = WebCrawler.Storage.get_next_page_to_crawl(WebCrawler.Storage)
    case url do
      {:ok, url} ->
        dispatch(url)
        process()
      {:error, _} -> {:ok}
    end
  end

  defp process(pool_state, running_workers) when (pool_state == :ready) and (running_workers > 0) do
    url = WebCrawler.Storage.get_next_page_to_crawl(WebCrawler.Storage)
    case url do
      {:ok, url} ->
        dispatch(url)
        process()
      {:error, _} ->
        :timer.sleep(@no_url_sleep_time)
        process()
    end
  end

  defp process(pool_state, _) when pool_state == :full do
    :timer.sleep(@no_url_sleep_time)
    process()
  end

  defp dispatch(url) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid ->
          GenServer.call(pid, {:crawl, url})
         end,
        @timeout)
    end)
  end

end
