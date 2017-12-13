defmodule WebCrawler.PageCrawler do

  #TODO Need to be able to switch out the HttpClient
  def crawl(url) do
    case WebCrawler.HttpClient.fetch(url) do
      {:ok, body} ->
        {:ok, parse(body)}
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

  defp filter(data) do
    filtered_list = Map.get(data, :a) |>
      Enum.filter(fn url -> !String.starts_with?(url, "http") end)
    Map.put(data, :a, filtered_list)
  end
end
