defmodule ReadQ.EntryControllerTest do
  use ReadQ.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "index returns a list of entries", %{conn: conn} do
    insert(:entry)

    conn = get conn, entry_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 1
  end

  test "show returns an entry", %{conn: conn} do
    entry = insert(:entry)

    conn = get conn, entry_path(conn, :show, entry)

    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(entry.id),
      "type" => "entry",
      "attributes" => %{
        "link" => entry.link,
        "tags" => entry.tags,
        "notes" => entry.notes,
        "archived" => entry.archived,
        "inserted-at" => Ecto.DateTime.to_iso8601(entry.inserted_at)
      }
    }
  end

  describe "entry create" do
    test "adds an entry in the database if valid params", %{conn: conn} do
      data = %{type: "entry", attributes: %{link: "http://example.com"}}
      conn = post conn, entry_path(conn, :create), data: data

      data = json_response(conn, 201)["data"]
      assert Repo.get!(ReadQ.Entry, data["id"])
    end

    test "returns error if invalid data", %{conn: conn} do
      data = %{
        type: "entry",
        #attributes: %{link: 1, notes: ["a"], archived: "string", tags: [1, 2]}
        attributes: %{link: 1, notes: ["a"], archived: "string"}
      }
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert length(errors) == 3
    end


    test "returns error if invalid url", %{conn: conn} do
      data = %{type: "entry", attributes: %{link: "ia:aa"}}
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert Enum.at(errors, 0)["detail"] == "Link is an invalid URL"
    end

    test "returns error if empty url", %{conn: conn} do
      data = %{type: "entry", attributes: %{link: ""}}
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert Enum.at(errors, 0)["detail"] == "Link can't be blank"
    end

    test "returns error if too many tags", %{conn: conn} do
      tags = Enum.map(1..20, fn(n) -> "tag#{n}" end)
      data = %{
        type: "entry",
        attributes: %{link: "http://a.com", tags: tags}
      }
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert Enum.at(errors, 0)["detail"] == "Tags should have at most 10 item(s)"
    end

    test "returns error if tags contains non-slugs", %{conn: conn} do
      tags = ["a-b", "b.a"]
      data = %{
        type: "entry",
        attributes: %{link: "http://a.com", tags: tags}
      }
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert Enum.at(errors, 0)["detail"] == "Tags should only contain slugs"
    end

  end

end
