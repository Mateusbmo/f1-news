defmodule F1NewsWeb.NewsController do
  use F1NewsWeb, :controller
  alias F1News.Content
  alias F1News.News

  def index(conn, _params) do
    news_collection = Content.list_news()
    render(conn, :index, news_collection: news_collection)
  end

  def new(conn, _params) do
    changeset = Content.change_news(%News{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"news" => news_params}) do
    case Content.create_news(news_params) do
      {:ok, news} ->
        conn
        |> put_flash(:info, "News created successfully.")
        |> redirect(to: ~p"/news/#{news}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Content.get_news(id) do
      nil ->
        conn
        |> put_flash(:error, "Notícia não encontrada.")
        |> redirect(to: ~p"/news")
      news ->
        render(conn, :show, news: news)
    end
  end

  def edit(conn, %{"id" => id}) do
    news = Content.get_news!(id)
    changeset = Content.change_news(news)
    render(conn, :edit, news: news, changeset: changeset)
  end

  def update(conn, %{"id" => id, "news" => news_params}) do
    news = Content.get_news!(id)

    case Content.update_news(news, news_params) do
      {:ok, news} ->
        conn
        |> put_flash(:info, "News updated successfully.")
        |> redirect(to: ~p"/news/#{news}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, news: news, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    news = Content.get_news!(id)
    {:ok, _news} = Content.delete_news(news)

    conn
    |> put_flash(:info, "News deleted successfully.")
    |> redirect(to: ~p"/news")
  end
end
