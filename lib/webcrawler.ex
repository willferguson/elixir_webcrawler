defmodule Webcrawler do
  @moduledoc """
  Documentation for Webcrawler.
  """

  @doc """
  """
  def crawl do
    html = ~S(<!doctype html>
<html>
<body>
  <section id="content">
    <p class="headline">Floki</p>
    <a href="http://github.com/philss/floki">Github page</a>
    <span data-model="user">philss</span>
  </section>
</body>
</html>)

   Floki.find(html, ".headline")
  end
end
