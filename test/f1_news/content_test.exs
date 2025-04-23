defmodule F1News.ContentTest do
  use F1News.DataCase

  alias F1News.Content

  describe "news" do
    alias F1News.Content.News

    import F1News.ContentFixtures

    @invalid_attrs %{title: nil, author: nil, content: nil, published_at: nil, image_url: nil}

    test "list_news/0 returns all news" do
      news = news_fixture()
      assert Content.list_news() == [news]
    end

    test "get_news!/1 returns the news with given id" do
      news = news_fixture()
      assert Content.get_news!(news.id) == news
    end

    test "create_news/1 with valid data creates a news" do
      valid_attrs = %{title: "some title", author: "some author", content: "some content", published_at: ~U[2025-04-15 02:49:00Z], image_url: "some image_url"}

      assert {:ok, %News{} = news} = Content.create_news(valid_attrs)
      assert news.title == "some title"
      assert news.author == "some author"
      assert news.content == "some content"
      assert news.published_at == ~U[2025-04-15 02:49:00Z]
      assert news.image_url == "some image_url"
    end

    test "create_news/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_news(@invalid_attrs)
    end

    test "update_news/2 with valid data updates the news" do
      news = news_fixture()
      update_attrs = %{title: "some updated title", author: "some updated author", content: "some updated content", published_at: ~U[2025-04-16 02:49:00Z], image_url: "some updated image_url"}

      assert {:ok, %News{} = news} = Content.update_news(news, update_attrs)
      assert news.title == "some updated title"
      assert news.author == "some updated author"
      assert news.content == "some updated content"
      assert news.published_at == ~U[2025-04-16 02:49:00Z]
      assert news.image_url == "some updated image_url"
    end

    test "update_news/2 with invalid data returns error changeset" do
      news = news_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_news(news, @invalid_attrs)
      assert news == Content.get_news!(news.id)
    end

    test "delete_news/1 deletes the news" do
      news = news_fixture()
      assert {:ok, %News{}} = Content.delete_news(news)
      assert_raise Ecto.NoResultsError, fn -> Content.get_news!(news.id) end
    end

    test "change_news/1 returns a news changeset" do
      news = news_fixture()
      assert %Ecto.Changeset{} = Content.change_news(news)
    end
  end

  describe "news" do
    alias F1News.Content.News

    import F1News.ContentFixtures

    @invalid_attrs %{index: nil}

    test "list_news/0 returns all news" do
      news = news_fixture()
      assert Content.list_news() == [news]
    end

    test "get_news!/1 returns the news with given id" do
      news = news_fixture()
      assert Content.get_news!(news.id) == news
    end

    test "create_news/1 with valid data creates a news" do
      valid_attrs = %{index: "some index"}

      assert {:ok, %News{} = news} = Content.create_news(valid_attrs)
      assert news.index == "some index"
    end

    test "create_news/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_news(@invalid_attrs)
    end

    test "update_news/2 with valid data updates the news" do
      news = news_fixture()
      update_attrs = %{index: "some updated index"}

      assert {:ok, %News{} = news} = Content.update_news(news, update_attrs)
      assert news.index == "some updated index"
    end

    test "update_news/2 with invalid data returns error changeset" do
      news = news_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_news(news, @invalid_attrs)
      assert news == Content.get_news!(news.id)
    end

    test "delete_news/1 deletes the news" do
      news = news_fixture()
      assert {:ok, %News{}} = Content.delete_news(news)
      assert_raise Ecto.NoResultsError, fn -> Content.get_news!(news.id) end
    end

    test "change_news/1 returns a news changeset" do
      news = news_fixture()
      assert %Ecto.Changeset{} = Content.change_news(news)
    end
  end
end
