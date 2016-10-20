defmodule ReadQ.Router do
  use ReadQ.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ReadQ do
    pipe_through :api

    resources "/entries", EntryController, only: [:index]
  end
end
