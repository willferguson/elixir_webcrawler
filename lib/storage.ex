defmodule Storage do
  use Agent

  defstruct [visited: MapSet.new, to_visit: [], pages: %{}]
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
        %{:a => ["abc.com", "bbc.com"], :img => []}
  """
  def submit_page(agent, {page_name, page_data}) do
    fun = fn data ->
      new_map = Map.put(data.pages, page_name, page_data)
      %{data | pages: new_map}
    end
    Agent.update(agent, fun, 5000)
  end

  def get_pages(agent) do
    Agent.get(agent, fn data -> data.pages end, 5000)
  end
end
