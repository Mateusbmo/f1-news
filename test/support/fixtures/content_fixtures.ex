defmodule F1News.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `F1News.Content` context.
  """

  @doc """
  Generate a news.
  """
  def news_fixture(attrs \\ %{}) do
    {:ok, news} =
      attrs
      |> Enum.into(%{
        author: "some author",
        content: "some content",
        image_url: "some image_url",
        published_at: ~U[2025-04-15 02:49:00Z],
        title: "some title"
      })
      |> F1News.Content.create_news()

    news
  end

  @doc """
  Generate a news.
  """
  def news_fixture(attrs \\ %{}) do
    {:ok, news} =
      attrs
      |> Enum.into(%{
        index: "some index"
      })
      |> F1News.Content.create_news()

    news
  end
end
