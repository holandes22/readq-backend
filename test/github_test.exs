defmodule ReadQ.GitHubTest do
  use ExUnit.Case

  describe "get_primary_email" do

    test "returns the primary email" do
      emails = [
        %{"email" => "pabloklijnjan@a.c", "primary" => true, "verified" => true},
        %{"email" => "pabloklijnjan@a.b", "primary" => false, "verified" => true}
      ]

      assert "pabloklijnjan@a.c" == GitHub.get_primary_email(emails)
    end

    test "returns the first email if no primary" do
      emails = [
        %{"email" => "pabloklijnjan@a.b", "primary" => false, "verified" => true}
      ]

      assert "pabloklijnjan@a.b" == GitHub.get_primary_email(emails)
    end
  end

end
