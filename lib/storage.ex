defmodule Storage do
  use Agent

  defstruct [visited: MapSet.new, to_visit: [], pages: []]
  @moduledoc """

  """

  @doc """
    Starts our agent
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %Storage{} end)
  end

  @doc """
      Submits the result of a crawl for a single page.
      Page might look like:
        {:my_test_page, %{:a => ["bbc.com"], :link => []}}
  """
  def submit_page(agent, {page_name, page_data}) do
    fun = fn data ->
      %{data | pages: [{page_name, page_data}] ++ data.pages}
    end
    Agent.update(agent, fun, 5000)
  end

  def get_pages(agent) do
    Agent.get(agent, fn data -> data.pages end, 5000)
  end
end
