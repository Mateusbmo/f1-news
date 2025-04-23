defmodule F1NewsWeb.NewsHTML do
  use F1NewsWeb, :html

  embed_templates "news_html/*"

  @doc """
  Renders a news form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def news_form(assigns)
end
