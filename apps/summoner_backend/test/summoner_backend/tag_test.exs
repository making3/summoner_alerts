defmodule SummonerBackend.TagTest do
  use ExUnit.Case
  doctest SummonerBackend.Tag
  alias SummonerBackend.Tag

  test "get_unique_tags test" do
    actual = Tag.get_unique_tags([
      %{name: "tag1"},
      %{name: "tag1"},
      %{name: "bar"},
      %{name: "foo"},
      %{name: "foo"},
      %{name: "foo"}
    ])
    |> MapSet.to_list()

    expected = MapSet.new()
    |> MapSet.put("tag1")
    |> MapSet.put("bar")
    |> MapSet.put("foo")
    |> MapSet.to_list()

    assert actual == expected
  end

  test "get_group_tags_from_unique single group" do
    found_tags = MapSet.new()
    |> MapSet.put("foo")
    |> MapSet.put("tag1")
    |> MapSet.put("many tag")
    |> MapSet.put("found")
    group_tags = [
      %{name: "foo"},
      %{name: "tag1"},
      %{name: "many tag"},
      %{name: "other"},
      %{name: "not found"},
      %{name: "found"}
    ]

    actual = Tag.get_group_tags_from_unique(found_tags, group_tags)
    expected = [
      %{name: "foo"},
      %{name: "tag1"},
      %{name: "many tag"},
      %{name: "found"}
    ]
    assert actual == expected
  end
end
