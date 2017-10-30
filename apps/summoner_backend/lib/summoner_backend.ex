require Poison
require ExReddit
require ExRedditTagger

defmodule SummonerBackend do
  use Application

  @moduledoc """
  Documentation for SummonerBackend.
  """

  def start(_, _) do
    IO.puts "starting"
    SummonerBackend.Supervisor.start_link(name: ServiceSupervisor)
  end
end
