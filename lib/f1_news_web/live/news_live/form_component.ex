defmodule F1NewsWeb.NewsLive.FormComponent do
  use F1NewsWeb, :live_component

  alias F1News.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage news records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="news-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:index]} type="text" label="Index" />
        <:actions>
          <.button phx-disable-with="Saving...">Save News</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{news: news} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Content.change_news(news))
     end)}
  end

  @impl true
  def handle_event("validate", %{"news" => news_params}, socket) do
    changeset = Content.change_news(socket.assigns.news, news_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"news" => news_params}, socket) do
    save_news(socket, socket.assigns.action, news_params)
  end

  defp save_news(socket, :edit, news_params) do
    case Content.update_news(socket.assigns.news, news_params) do
      {:ok, news} ->
        notify_parent({:saved, news})

        {:noreply,
         socket
         |> put_flash(:info, "News updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_news(socket, :new, news_params) do
    case Content.create_news(news_params) do
      {:ok, news} ->
        notify_parent({:saved, news})

        {:noreply,
         socket
         |> put_flash(:info, "News created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
