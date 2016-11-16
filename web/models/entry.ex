defmodule ReadQ.Entry do
  use ReadQ.Web, :model
  import ReadQ.Validator

  schema "entries" do
    field :archived, :boolean, default: false
    field :notes, :string, default: ""
    field :link, :string
    field :tags, {:array, :string}
    belongs_to :user, ReadQ.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:archived, :notes, :link, :tags])
    |> validate_required([:link])
    |> validate_url(:link)
    |> validate_length(:tags, max: 10)
    |> validate_slug_list(:tags)
  end

end
