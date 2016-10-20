defmodule ReadQ.EntryController do
  use ReadQ.Web, :controller

  alias ReadQ.Entry

  def index(conn, _params) do
    render conn, data: Repo.all(Entry)
  end
end
