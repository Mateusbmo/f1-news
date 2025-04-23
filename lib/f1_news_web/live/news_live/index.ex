defmodule F1NewsWeb.NewsLive.Index do
  use F1NewsWeb, :live_view
  alias F1News.Content
  alias F1News.News

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :news_collection, list_news())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit News")
    |> assign(:news, Content.get_news!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New News")
    |> assign(:news, %News{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing News")
    |> assign(:news, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    news = Content.get_news!(id)
    {:ok, _} = Content.delete_news(news)

    {:noreply, assign(socket, :news_collection, list_news())}
  end

  defp list_news do
    Content.list_news()
  end
end
