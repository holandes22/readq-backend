defmodule ReadQ.Entry do
  use ReadQ.Web, :model
  import ReadQ.Validator

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
    |> cast(params, [:archived, :notes, :link, :tags])
    |> validate_required([:link])

  # link is a valid URL
  # Validate notes length
  # Validate tags length
  # Validate each tag is a slug
  end

end
