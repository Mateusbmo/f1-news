defmodule F1NewsWeb.PageController do
  use F1NewsWeb, :controller
  alias F1News.News

  def home(conn, _params) do
    news = News.list_news()
    render(conn, :home, news: news)
  end

  def about(conn, _params) do
    render(conn, :about)
  end

  def contact(conn, _params) do
    render(conn, :contact)
  end
end
