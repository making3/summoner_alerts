defmodule SummonerBackend.ThreadTest do
  use ExUnit.Case
  doctest SummonerBackend.Thread
  alias SummonerBackend.Thread

  test "reddit_thread get_created_utc" do
    thread = %{"created_utc" => 1509421584.2}
    result = Thread.get_created_utc(thread)
    assert Ecto.DateTime.to_string(result) == "2017-10-31 03:46:24"
  end

  test "get_tags_in_thread" do
    group_tags = %{
      "first": [
        %{name: "foo"},
        %{name: "tag1"},
        %{name: "many tag"},
        %{name: "other"},
        %{name: "not found"},
        %{name: "found"}
      ]
    }

    thread = %{
      "selftext" => "this text might have many tags with values no greater than foo",
      "title" => "found tags only"
    }

    actual = Thread.get_tags_in_thread(group_tags, thread)
    expected = [
      %{name: "foo"},
      %{name: "many tag"},
      %{name: "found"}
    ]

    assert actual == expected
  end
end
