defmodule ReadQ.EntryTest do
  use ReadQ.ModelCase

  alias ReadQ.Entry

  @valid_attrs %{archived: true, link: "some content", notes: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Entry.changeset(%Entry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Entry.changeset(%Entry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
