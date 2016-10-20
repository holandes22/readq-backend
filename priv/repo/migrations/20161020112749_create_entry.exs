defmodule ReadQ.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :archived, :boolean, default: false, null: false
      add :notes, :string
      add :link, :string
      add :tags, {:array, :string}

      timestamps()
    end

  end
end
