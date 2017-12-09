defmodule HttpClient do
  #TODO Use Behaviour
  def fetch(url) do

    case HTTPoison.get(url, [], [follow_redirect: true]) do
  {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    {:ok, body}
  {:ok, %HTTPoison.Response{status_code: 404}} ->
    {:error, "Not Found"}
  {:error, %HTTPoison.Error{reason: reason}} ->
    {:error, reason}
end
  end

end
