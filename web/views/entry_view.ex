defmodule ReadQ.EntryView do
  use JaSerializer.PhoenixView

  attributes [:link, :notes, :archived, :inserted_at, :tags]
end
