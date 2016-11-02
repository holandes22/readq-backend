defmodule ReadQ.Router do
  use ReadQ.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
    plug ReadQ.Plug.Authenticate
  end

  pipeline :auth do
    plug :accepts, ["json"]
  end

  scope "/auth", ReadQ do
    pipe_through :auth

    get "/:provider/callback", AuthController, :callback
  end

  scope "/api", ReadQ do
    pipe_through :api

    resources "/entries", EntryController, only: [:index, :show, :create, :update, :delete]
  end

end
