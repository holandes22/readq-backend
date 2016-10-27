defmodule ReadQ.EntryController do
  use ReadQ.Web, :controller

  alias ReadQ.Entry

  def index(conn, _params) do
    render conn, data: Repo.all(Entry)
  end

  def show(conn, params) do
    render conn, data: Repo.get!(Entry, params["id"])
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = Entry.changeset(%Entry{}, attrs)

    case Repo.insert(changeset) do
      {:ok, entry} ->
        conn
        |> put_status(201)
        |> render(:show, data: entry)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def update(conn, %{"data" => data}) do
    entry = Repo.get!(Entry, data["id"])
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

  def delete(conn, %{"id" => id}) do
    entry = Repo.get!(Entry, id)

    Repo.delete!(entry)

    send_resp(conn, :no_content, "")

  end
end
