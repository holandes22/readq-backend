defmodule ReadQ.Entry do
  use ReadQ.Web, :model

  schema "entries" do
    field :archived, :boolean, default: false
    field :notes, :string
    field :link, :string
    field :tags, {:array, :string}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:archived, :notes, :link])
    |> validate_required([:link])
  end
end
