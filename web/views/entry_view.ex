defmodule ReadQ.EntryView do

  def render("index.json", %{data: entries}) do
    %{
      entries: Enum.map(entries, &entry_json/1)
    }
  end

  def entry_json(entry) do
    %{
      link: entry.link,
      notes: entry.notes,
      archived: entry.archived,
      inserted_at: entry.inserted_at,
      tags: entry.tags
    }
  end
end
