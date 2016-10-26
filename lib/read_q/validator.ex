defmodule ReadQ.Validator do
  import Ecto.Changeset

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn(_, url) ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, message} -> [{field, options[:message] || "invalid url: #{inspect message}"}]
      end
    end
  end

end
