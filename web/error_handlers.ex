defmodule ReadQ.ErrorHandlers do
  use Phoenix.Controller
  import ReadQ.Router.Helpers

  def unauthorized(conn, error_str \\ nil ) do
    conn
    |> put_status(:unauthorized)
    |> render(ReadQ.ErrorView, "401.json")
    |> halt()
  end

end
