defmodule WebCrawler.PageCrawler do
  use GenServer
  require Logger

  @http_client Application.get_env(:web_crawler, :http_client)

  def start_link([url]) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
    send(self(), :crawl)
    {:ok, url}
  end

  def handle_info(:crawl, url) do
    case crawl(url) do
      {:ok, page_data} -> WebCrawler.Storage.submit_page(WebCrawler.Storage, {url, page_data})
      {:error, reason} -> Logger.error("Crawling of #{url} failed with: #{reason}")
    end
    {:stop, :normal, url}
  end

  defp crawl(url) do
    case @http_client.fetch(url) do
      {:ok, body} ->
        parsed_data = parse(body)
        #Filteres and processes the URLs so they are fully qualified and internal
        filtered_links = Map.get(parsed_data, :a)
        |> URLUtils.ensure_fully_qualified(url)
        |> Enum.filter(fn u -> URLUtils.is_local?(url, u) end)
        {:ok, Map.put(parsed_data, :a, filtered_links)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse(body) do
    Map.put(%{}, :a, Floki.find(body, "a") |> Floki.attribute("href")) |>
    Map.put(:img, Floki.find(body, "img") |> Floki.attribute("src")) |>
    Map.put(:script, Floki.find(body, "script") |> Floki.attribute("src")) |>
    Map.put(:link, Floki.find(body, "link") |> Floki.attribute("rel"))
  end


end
