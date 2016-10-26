defmodule ReadQ.ValidatorTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset
  import ReadQ.Validator

  defmodule Entry do
    use Ecto.Schema

    schema "entries" do
      field :link, :string
    end
  end

  defp assert_url(url, expected \\ true) do
    changeset = cast(%Entry{}, %{"link" => url}, ~w(link))
    assert validate_url(changeset, :link).valid? == expected
  end

  describe "validate_url" do

    test "with valid url" do
      assert_url("http://a.com")
    end

    test "with sub domain and uri" do
      assert_url("http://www.my-domain.co.il/api/vvv-aa")
    end

    test "with port" do
      assert_url("http://a.b.com:80")
    end

    test "with https scheme" do
      assert_url("https://1.0.0.1:80")
    end

    test "with invalid url" do
      assert_url("http://a:80.com", false)
    end

    test "with invalid scheme" do
      assert_url("htt://a.com", false)
    end

  end

end
