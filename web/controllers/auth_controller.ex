defmodule ReadQ.AuthController do
  use ReadQ.Web, :controller

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    user = get_user!(provider, client)

    json conn, %{user: user, token: client.token.access_token}
  end

  defp get_token!("github", code),   do: GitHub.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("github", client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"]}
  end
end
