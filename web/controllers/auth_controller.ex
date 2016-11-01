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
    %{body: emails} = OAuth2.Client.get!(client, "/user/emails")

    %{email: get_primary_email(emails)}
  end

  def get_primary_email(emails) do
    email = Enum.find(emails, Enum.at(emails, 0), fn(email) -> email["primary"] == true end)
    email["email"]
  end
end
