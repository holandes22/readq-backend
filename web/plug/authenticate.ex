defmodule ReadQ.Plug.Authenticate do
  import Plug.Conn
  require Logger

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    with {:ok, token} <- get_token(conn),
         {:ok, %{email: email}}  <- get_remote_user(token),
         {:ok, user} <- get_user(repo, email) do
        Logger.info "Authenticated user with email #{email}"
        assign(conn, :current_user, user)
    else
      {:error, _} -> conn
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

  defp get_remote_user(token) do
    GitHub.client(token) |> GitHub.get_user()
  end

  defp get_user(repo, email) do
    case repo.get_by(ReadQ.User, email: email) do
      nil  -> {:error, nil}
      user -> {:ok, user}
    end

  end
end
