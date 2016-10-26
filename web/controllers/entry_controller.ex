defmodule ReadQ.EntryController do
  use ReadQ.Web, :controller

  alias ReadQ.Entry

  def index(conn, _params) do
    render conn, data: Repo.all(Entry)
  end

  def show(conn, params) do
    render conn, data: Repo.get(Entry, params["id"])
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
        |> put_status(422)
        |> render(:errors, data: changeset)
    end

  end
end
