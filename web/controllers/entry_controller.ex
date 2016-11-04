defmodule ReadQ.EntryController do
  use ReadQ.Web, :controller

  alias ReadQ.Entry

  plug PolicyWonk.Enforce, :current_user

  defp user_entries(user) do
    assoc(user, :entries)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    entries = user_entries(user)
    render conn, data: Repo.all(entries)
  end

  def show(conn, %{"id" => id}, user) do
    entries = user_entries(user)
    render conn, data: Repo.get!(entries, id)
  end

  def create(conn, %{"data" => data}, user) do
    attrs = JaSerializer.Params.to_attributes(data)

    changeset =
      user
      |> build_assoc(:entries)
      |> Entry.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, entry} ->
        conn
        |> put_status(:created)
        |> render(:show, data: entry)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end
  def create(conn, %{}, _user) do
    conn
      |> put_status(400)
      |> render(:errors, data: %{detail: "Missing data", code: 400})
  end

  def update(conn, %{"data" => data}, user) do
    entry = user_entries(user) |> Repo.get!(data["id"])
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = Entry.changeset(entry, attrs)

    case Repo.update(changeset) do
      {:ok, entry} ->
        conn
        |> render(:show, data: entry)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    entry = user_entries(user) |> Repo.get!(id)

    Repo.delete!(entry)

    send_resp(conn, :no_content, "")

  end
end
