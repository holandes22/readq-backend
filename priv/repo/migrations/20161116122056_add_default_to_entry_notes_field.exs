defmodule ReadQ.Repo.Migrations.AddDefaultToEntryNotesField do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      modify :notes, :string, default: ""
    end

  end
end
