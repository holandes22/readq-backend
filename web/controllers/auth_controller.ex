defmodule ReadQ.AuthController do
  use ReadQ.Web, :controller
  alias ReadQ.{Repo, User}

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    %{email: email} = get_remote_user!(provider, client)

    user = case Repo.get_by(User, email: email) do
      nil  -> register_new_user(email)
      user -> user
    end

    json conn, %{user: %{email: user.email}, token: client.token.access_token}

  end

  defp get_token!("github", code),   do: GitHub.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_remote_user!("github", client), do: GitHub.get_user!(client)

  defp register_new_user(email) do
    changeset = User.changeset(%User{}, %{email: email})
    {:ok, user} = Repo.insert(changeset)
    user
  end

end
