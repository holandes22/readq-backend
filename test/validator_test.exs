defmodule ReadQ.ValidatorTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset
  import ReadQ.Validator

  defmodule Entry do
    use Ecto.Schema

    schema "entries" do
      field :link, :string
      field :tags, {:array, :string}
    end
  end

  @valid_urls [
    "http://a.com",
    "http://a.b.com:80",
    "https://1.0.0.1:80",
    "http://www.my-domain.co.il/api/vvv-aa"
  ]
  @invalid_urls [
    "http://a:80.com",
    "htt://a.com"
  ]

  @valid_slugs ["a", "a-b", "a1", "b-2", "2"]
  @invalid_slugs [".a", "a-", "a_b", "#aa", "a.b", "a!", "a--b", "very-long-tag-about-functional-programming"]

  describe "validate_url" do

    test "with valid urls" do
      for url <- @valid_urls do
        changeset = cast(%Entry{}, %{"link" => url}, ~w(link))
        assert validate_url(changeset, :link).valid?
      end
    end

    test "with invalid urls" do
      for url <- @invalid_urls do
        changeset = cast(%Entry{}, %{"link" => url}, ~w(link))
        refute validate_url(changeset, :link).valid?
      end
    end

  end

  describe "validate_slug_list" do

    test "with valid slugs" do
      for slug <- @valid_slugs do
        changeset = cast(%Entry{}, %{"tags" => [slug]}, ["tags"])
        assert validate_slug_list(changeset, :tags).valid?
      end
    end

    test "with invalid slugs" do
      for slug <- @invalid_slugs do
        changeset = cast(%Entry{}, %{"tags" => [slug]}, ["tags"])
        refute validate_slug_list(changeset, :tags).valid?
      end
    end

  end

end
