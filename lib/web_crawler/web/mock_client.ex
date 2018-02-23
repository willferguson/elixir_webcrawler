defmodule WebCrawler.Web.MockClient do
  @behaviour WebCrawler.Web.HttpClientBehaviour
  def fetch(url) do

    html = ~s(<html>
            <head>
              <link rel = "a_local_css.css"/>
              <script src = "a_local_js.js"/>
              <link rel = "http://test.com/a_remote_css.css"/>
              <script src = "http://test.com/a_remote_js.js"/>
            <body>
              <section id="content">
                <p class="headline">Test</p>
                <span class="headline">Enables search using CSS selectors</span>
                <a href="https://github.com/philss/floki">Github page</a>
                <a href="internal">Github page</a>
                <span data-model="user">philss</span>
              </section>
              <a href="https://hex.pm/packages/floki">Hex package</a>
            </body>
            </html>)

      {:ok, ""}

  end

  defp mock(_) do
    {:ok, html}
  end

  defp mock("internal") do

  end


end
