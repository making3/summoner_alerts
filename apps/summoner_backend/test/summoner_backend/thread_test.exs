defmodule SummonerBackend.ThreadTest do
  use ExUnit.Case
  doctest SummonerBackend.Thread
  alias SummonerBackend.Thread

  test "reddit_thread get_created_utc" do
    thread = %{"created_utc" => 1509421584.2}
    result = Thread.get_created_utc(thread)
    assert Ecto.DateTime.to_string(result) == "2017-10-31 03:46:24"
  end
end
