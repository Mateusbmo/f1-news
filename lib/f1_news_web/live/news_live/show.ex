defmodule F1NewsWeb.NewsLive.Show do
  use F1NewsWeb, :live_view

  alias F1News.Content

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:news, Content.get_news!(id))}
  end

  defp page_title(:show), do: "Show News"
  defp page_title(:edit), do: "Edit News"
end
