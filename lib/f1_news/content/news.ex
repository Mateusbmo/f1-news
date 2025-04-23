defmodule F1News.News do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias F1News.Repo

  schema "news" do
    field :title, :string
    field :content, :string
    field :author, :string
    field :published_at, :utc_datetime
    field :image_url, :string
    timestamps()
  end

  @doc """
  Changeset for creating or updating news.
  """
  def changeset(news, attrs \\ %{}) do
    news
    |> cast(attrs, [:title, :content, :author, :published_at, :image_url])
    |> validate_required([:title, :content, :author, :published_at])
    |> validate_length(:title, max: 255)
    |> validate_length(:content, min: 10)
  end

  def list_news do
    Repo.all(from n in __MODULE__, order_by: [desc: n.published_at])
  end
end
