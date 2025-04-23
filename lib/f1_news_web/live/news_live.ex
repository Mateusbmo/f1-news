defmodule F1NewsWeb.NewsLive do
  use F1NewsWeb, :live_view
  alias F1News.Content

  @impl true
  def mount(_params, _session, socket) do
    news = Content.list_news()
    {:ok, assign(socket, news: news)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <h1 class="text-3xl font-bold mb-4 text-center">F1 News</h1>

      <!-- Carousel for featured news -->
      <div class="carousel swiper w-full mb-8">
        <div class="swiper-wrapper">
          <%= for n <- Enum.take(@news, 3) do %>
            <div class="swiper-slide">
              <div class="card w-full bg-base-100 shadow-xl">
                <figure>
                  <img src={n.image_url || "/images/placeholder.jpg"} alt={n.title} class="w-full h-64 object-cover rounded-t-lg" />
                </figure>
                <div class="card-body">
                  <h2 class="card-title text-xl"><%= n.title %></h2>
                  <p class="text-gray-600"><%= String.slice(n.content, 0, 100) %>...</p>
                  <div class="card-actions justify-end">
                    <.link href={~p"/news/#{n.id}"} class="btn btn-primary">Read More</.link>
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </div>
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
      </div>

      <!-- List of recent news -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for n <- @news do %>
          <div class="card bg-base-100 shadow-md hover:shadow-lg transition-shadow">
            <figure>
              <img src={n.image_url || "/images/placeholder.jpg"} alt={n.title} class="w-full h-48 object-cover rounded-t-lg" />
            </figure>
            <div class="card-body">
              <h2 class="card-title text-lg"><%= n.title %></h2>
              <p class="text-sm text-gray-500">By <%= n.author %> on <%= DateTime.to_date(n.published_at) %></p>
              <p class="text-gray-600"><%= String.slice(n.content, 0, 100) %>...</p>
              <div class="card-actions justify-end">
                <.link href={~p"/news/#{n.id}"} class="btn btn-primary">Read More</.link>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
