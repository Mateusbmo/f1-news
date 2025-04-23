defmodule F1NewsWeb.NewsLiveTest do
  use F1NewsWeb.ConnCase

  import Phoenix.LiveViewTest
  import F1News.ContentFixtures

  @create_attrs %{index: "some index"}
  @update_attrs %{index: "some updated index"}
  @invalid_attrs %{index: nil}

  defp create_news(_) do
    news = news_fixture()
    %{news: news}
  end

  describe "Index" do
    setup [:create_news]

    test "lists all news", %{conn: conn, news: news} do
      {:ok, _index_live, html} = live(conn, ~p"/news")

      assert html =~ "Listing News"
      assert html =~ news.index
    end

    test "saves new news", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/news")

      assert index_live |> element("a", "New News") |> render_click() =~
               "New News"

      assert_patch(index_live, ~p"/news/new")

      assert index_live
             |> form("#news-form", news: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#news-form", news: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/news")

      html = render(index_live)
      assert html =~ "News created successfully"
      assert html =~ "some index"
    end

    test "updates news in listing", %{conn: conn, news: news} do
      {:ok, index_live, _html} = live(conn, ~p"/news")

      assert index_live |> element("#news-#{news.id} a", "Edit") |> render_click() =~
               "Edit News"

      assert_patch(index_live, ~p"/news/#{news}/edit")

      assert index_live
             |> form("#news-form", news: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#news-form", news: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/news")

      html = render(index_live)
      assert html =~ "News updated successfully"
      assert html =~ "some updated index"
    end

    test "deletes news in listing", %{conn: conn, news: news} do
      {:ok, index_live, _html} = live(conn, ~p"/news")

      assert index_live |> element("#news-#{news.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#news-#{news.id}")
    end
  end

  describe "Show" do
    setup [:create_news]

    test "displays news", %{conn: conn, news: news} do
      {:ok, _show_live, html} = live(conn, ~p"/news/#{news}")

      assert html =~ "Show News"
      assert html =~ news.index
    end

    test "updates news within modal", %{conn: conn, news: news} do
      {:ok, show_live, _html} = live(conn, ~p"/news/#{news}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit News"

      assert_patch(show_live, ~p"/news/#{news}/show/edit")

      assert show_live
             |> form("#news-form", news: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#news-form", news: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/news/#{news}")

      html = render(show_live)
      assert html =~ "News updated successfully"
      assert html =~ "some updated index"
    end
  end
end
