defmodule F1News.Content do
  import Ecto.Query, warn: false
  alias F1News.Repo
  alias F1News.News

  def list_news do
    Repo.all(from n in News, order_by: [desc: n.published_at])
  end

  def get_news(id), do: Repo.get(News, id)
  def get_news!(id), do: Repo.get!(News, id)

  def create_news(attrs \\ %{}) do
    %News{}
    |> News.changeset(attrs)
    |> Repo.insert()
  end

  def update_news(%News{} = news, attrs) do
    news
    |> News.changeset(attrs)
    |> Repo.update()
  end

  def delete_news(%News{} = news) do
    Repo.delete(news)
  end

  def change_news(%News{} = news, attrs \\ %{}) do
    News.changeset(news, attrs)
  end
end
