defmodule URLUtils do

  @doc """
    Ensures that the passed list of urls are fully qualified.
    If they are not, the base_url is used to provide host / paths etc.
  """
  @spec ensure_fully_qualified([], String.t) :: []
  def ensure_fully_qualified(urls, base_url) do
      Enum.map(urls, &URI.merge(base_url, &1) |> URI.to_string)
  end

  @doc """
    Determines whether one URL is local to the other.
    IE they share the same host.
  """
  @spec is_local?(String.t, String.t) :: boolean
  def is_local?(url1, url2) do
    %URI{host: host1} = URI.parse(url1)
    %URI{host: host2} = URI.parse(url2)
    String.equivalent?(host1, host2)
  end


end
