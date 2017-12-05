defmodule Storage do
  use Agent

  defstruct [visited: MapSet.new, to_visit: [], results: Map.new]
  @moduledoc """

  """

  @doc """
    Starts our agent
  """
  def start_link do
    Agent.start_link(fn -> %Storage{} end)
  end

  @doc """
      Submits the result of a crawl.
  """
  def submit(agent, results) do
    fun = fn data ->
      #stored_results = data.results
    end
    Agent.update(agent, fun, 5000)

  end



end
