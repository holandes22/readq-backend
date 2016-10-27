defmodule ReadQ.Router do
  use ReadQ.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", ReadQ do
    pipe_through :api

    resources "/entries", EntryController, only: [:index, :show, :create, :update, :delete]
  end
end
