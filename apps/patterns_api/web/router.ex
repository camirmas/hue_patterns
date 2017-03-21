defmodule PatternsApi.Router do
  use PatternsApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PatternsApi do
    pipe_through :api
  end
end
