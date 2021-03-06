defmodule SummonerWebWeb.Router do
  use SummonerWebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SummonerWebWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", SummonerWebWeb do
    pipe_through :api # Use the default browser stack

    get "/threads", ThreadsController, :index

    resources "/tags", TagsController, only: [:create, :delete]
    resources "/tag-groups", TagGroupsController, except: [:new, :edit]
  end
end
