defmodule GitHub do
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: GitHub,
     site: "https://api.github.com",
     authorize_url: "https://github.com/login/oauth/authorize",
     token_url: "https://github.com/login/oauth/access_token"]
  end

  # Public API

  def client do
    [strategy: GitHub,
     site: "https://api.github.com",
     authorize_url: "https://github.com/login/oauth/authorize",
     token_url: "https://github.com/login/oauth/access_token"]
    Application.get_env(:read_q, GitHub)
      |> Keyword.merge(config())
      |> OAuth2.Client.new()
  end
  def client(token) do
    Application.get_env(:read_q, GitHub)
      |> Keyword.merge(config())
      |> Keyword.merge([token: token])
      |> OAuth2.Client.new()
  end

  def get_token!(params \\ []) do
    OAuth2.Client.get_token!(client, Keyword.merge(params, client_secret: client().client_secret))
  end

  def get_user!(client) do
    %{body: emails} = OAuth2.Client.get!(client, "/user/emails")

    %{email: get_primary_email(emails)}
  end
  def get_user(client) do
    case OAuth2.Client.get(client, "/user/emails") do
      {:ok, %OAuth2.Response{status_code: 200, body: emails}} ->
        {:ok, %{email: get_primary_email(emails)}}
      {:ok, %OAuth2.Response{status_code: 401}} ->
        {:error, "Unauthorized token"}
      {:error, %OAuth2.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_primary_email(emails) do
    email = Enum.find(emails, Enum.at(emails, 0), fn(email) -> email["primary"] == true end)
    email["email"]
  end

  # Strategy callbacks

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
