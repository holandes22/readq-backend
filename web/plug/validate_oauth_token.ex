defmodule ReadQ.Plug.Authenticate do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with {:ok, token} <- get_token(conn),
         {:ok, user}  <- get_user(token) do
        assign(conn, :curent_user, user)
    else
      {:error, _} ->
        assign(conn, :curent_user, %{email: "Anon"})
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        {:ok, token}
      _ ->
        {:error, nil}
    end
  end

  defp get_user(token) do
    GitHub.client(token) |> GitHub.get_user()
  end
end
