defmodule WebCrawler.Storage do
  use Agent, restart: :temporary

  @agent_update_timeout 5000
  defstruct [visited: MapSet.new, to_visit: [], pages: []]
  @moduledoc """

  """

  @doc """
    Starts our agent
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %WebCrawler.Storage{} end, name: __MODULE__)
  end

  @doc """
      Submits the result of a crawl for a single page.
      Page might look like:
        {:my_test_page, %{:a => ["bbc.com"], :link => []}}
  """
  def submit_page(agent, {page_url, page_data}) do
    fun = fn data ->
      #Work out which of the submitted anchors haven't been visited
      not_yet_visited = Map.get(page_data, :a)
        |> Enum.filter(fn elem -> !Enum.member?(MapSet.put(data.visited, page_url), elem) end)

      uniq_to_visit = Enum.uniq(not_yet_visited ++ data.to_visit)

      #Update data
      %{data | pages: [{page_url, page_data}] ++ data.pages,
               to_visit: uniq_to_visit,
               visited: MapSet.put(data.visited, page_url)
             }
    end
    Agent.update(agent, fun, @agent_update_timeout)
  end

  @doc """
    Returns all our stored pages
  """
  def get_pages(agent) do
    Agent.get(agent, fn data -> {:ok, data.pages} end, @agent_update_timeout)
  end

  @doc """
    Returns the next URL to crawl
  """
  def get_next_page_to_crawl(agent) do
    fun = fn data ->
      case data.to_visit do
          [head | rest] ->
            #IO.inspect("Returning #{head}, with #{rest} still to crawl")
            {{:ok, head}, %{data | to_visit: rest}}
          [] -> {{:error, "Empty"}, %{data | to_visit: []}}
      end
    end
    Agent.get_and_update(agent, fun, @agent_update_timeout)
  end

  def get_all_pages_to_visit(agent) do
    Agent.get(agent, fn data -> data.to_visit end, @agent_update_timeout)
  end
end
