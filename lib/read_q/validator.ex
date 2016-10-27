defmodule ReadQ.Validator do
  import Ecto.Changeset

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn(_, url) ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, message} -> [{field, "is an invalid URL"}]
      end
    end
  end

  def validate_slug_list(changeset, field, options \\ []) do
    validate_change changeset, field, fn(_, slugs) ->
      case Enum.all?(slugs, fn(slug) -> validate_slug(slug) end) do
        true -> []
        false -> [{field, "should only contain slugs"}]
      end
    end
  end

  defp validate_slug(slug), do: Regex.match?(~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/, slug)
end
