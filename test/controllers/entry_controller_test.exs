defmodule ReadQ.EntryControllerTest do
  use ReadQ.ConnCase

  @email "eder@caed-nua.com"

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    user = insert(:user, email: @email)

    {:ok, conn: conn, user: user}
  end

  def log_user_in(%{conn: conn, user: user}) do
    %{conn: assign(conn, :current_user, user), user: user}
  end

  describe "when user is authenticated" do
    setup [:log_user_in]

    test "index returns a list of entries", %{conn: conn, user: user} do
      insert(:entry)
      insert(:entry, user: user)

      conn = get conn, entry_path(conn, :index)
      assert Enum.count(json_response(conn, 200)["data"]) == 1
    end

    test "show returns an entry", %{conn: conn, user: user} do
      insert(:entry)
      entry = insert(:entry, user: user)

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

    test "create adds an entry in the database and renders resource", %{conn: conn, user: user} do
      data = %{type: "entry", attributes: %{link: "http://example.com"}}
      conn = post conn, entry_path(conn, :create), data: data

      data = json_response(conn, 201)["data"]
      entry =
        Repo.get!(ReadQ.Entry, data["id"])
        |> Repo.preload(:user)
      assert entry.user == user
      assert entry.link == data["attributes"]["link"]
    end

    test "update modifies the entry in the database and renders resource", %{conn: conn, user: user} do
      entry = insert(:entry, user: user, archived: false)

      data = %{
        type: "entry",
        id: entry.id,
        attributes: %{link: "http://new-url.com", archived: true}
      }
      conn = patch conn, entry_path(conn, :update, entry), data: data

      data = json_response(conn, 200)["data"]
      entry = Repo.get!(ReadQ.Entry, data["id"])

      assert entry.link == data["attributes"]["link"]
      assert entry.archived
    end

    test "delete removes the entry from the database", %{conn: conn, user: user} do
      entry = insert(:entry, user: user)

      conn = delete conn, entry_path(conn, :delete, entry)

      assert response(conn, 204)
      refute Repo.get(ReadQ.Entry, entry.id)
    end

    for action <- [:show, :update, :delete] do
      @action action

      test "#{action} returns 404 if no such entry", %{conn: conn} do
        assert_error_sent 404, fn ->
          get conn, entry_path(conn, @action, -1)
        end
      end
    end

  end

  describe "when unauthenticated" do
    test "index returns 401 if no authorization header", %{conn: conn} do
      conn = get conn, entry_path(conn, :index)
      assert response(conn, 401)
    end

    test "index returns 401 if bad authorization header", %{conn: conn} do
      put_req_header(conn, "authorization", "bad token")
      conn = get conn, entry_path(conn, :index)
      assert response(conn, 401)
    end

    for action <- [:show, :update, :delete] do
      @action action

      test "#{action} returns 401 if no authorization header", %{conn: conn} do
        conn = get conn, entry_path(conn, @action, 1)
        assert response(conn, 401)
      end
    end

  end

  describe "when user requests resource that does not own" do
    setup [:log_user_in]

    for action <- [:show, :update, :delete] do
      @action action

      test "#{action} returns 404", %{conn: conn} do
        another_user = insert(:user)
        entry = insert(:entry, user: another_user)

        assert_error_sent 404, fn ->
          get conn, entry_path(conn, @action, entry)
        end
      end
    end

  end

  describe "entry validation" do
    setup [:log_user_in]

    test "returns error if invalid data", %{conn: conn} do
      data = %{
        type: "entry",
        attributes: %{link: 1, notes: ["a"], archived: "string", tags: [1, 2]}
      }
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert length(errors) == 4
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
      tags = ["valid-one", "invalid.slug--"]
      data = %{
        type: "entry",
        attributes: %{link: "http://a.com", tags: tags}
      }
      conn = post conn, entry_path(conn, :create), data: data

      errors = json_response(conn, 422)["errors"]
      assert Enum.at(errors, 0)["source"]["pointer"] == "/data/attributes/tags"
    end

  end

end
