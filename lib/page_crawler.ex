defmodule PageCrawler do

  def crawl(url) do
    case HttpClient.fetch(url) do
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
end
