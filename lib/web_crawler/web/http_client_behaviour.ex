defmodule WebCrawler.Web.HttpClientBehaviour do
  @callback fetch(url :: String.t) :: {:ret, String.t}

end
