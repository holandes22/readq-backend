defmodule ReadQ.ErrorHandlers do
  use Phoenix.Controller

  def unauthorized(conn, _error_str \\ nil ) do
    conn
    |> put_status(:unauthorized)
    |> render(ReadQ.ErrorView, "401.json-api")
    |> halt()
  end

end
