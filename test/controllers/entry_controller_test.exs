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

    test "returns error if invalid params", %{conn: conn} do
      data = %{type: "entry", attributes: %{link: ""}}
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      IO.inspect errors
    end
  end

end
