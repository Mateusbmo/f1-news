defmodule F1NewsWeb.NewsControllerTest do
  use F1NewsWeb.ConnCase

  import F1News.ContentFixtures

  @create_attrs %{title: "some title", author: "some author", content: "some content", published_at: ~U[2025-04-15 02:49:00Z], image_url: "some image_url"}
  @update_attrs %{title: "some updated title", author: "some updated author", content: "some updated content", published_at: ~U[2025-04-16 02:49:00Z], image_url: "some updated image_url"}
  @invalid_attrs %{title: nil, author: nil, content: nil, published_at: nil, image_url: nil}

  describe "index" do
    test "lists all news", %{conn: conn} do
      conn = get(conn, ~p"/news")
      assert html_response(conn, 200) =~ "Listing News"
    end
  end

  describe "new news" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/news/new")
      assert html_response(conn, 200) =~ "New News"
    end
  end

  describe "create news" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/news", news: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/news/#{id}"

      conn = get(conn, ~p"/news/#{id}")
      assert html_response(conn, 200) =~ "News #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/news", news: @invalid_attrs)
      assert html_response(conn, 200) =~ "New News"
    end
  end

  describe "edit news" do
    setup [:create_news]

    test "renders form for editing chosen news", %{conn: conn, news: news} do
      conn = get(conn, ~p"/news/#{news}/edit")
      assert html_response(conn, 200) =~ "Edit News"
    end
  end

  describe "update news" do
    setup [:create_news]

    test "redirects when data is valid", %{conn: conn, news: news} do
      conn = put(conn, ~p"/news/#{news}", news: @update_attrs)
      assert redirected_to(conn) == ~p"/news/#{news}"

      conn = get(conn, ~p"/news/#{news}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, news: news} do
      conn = put(conn, ~p"/news/#{news}", news: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit News"
    end
  end

  describe "delete news" do
    setup [:create_news]

    test "deletes chosen news", %{conn: conn, news: news} do
      conn = delete(conn, ~p"/news/#{news}")
      assert redirected_to(conn) == ~p"/news"

      assert_error_sent 404, fn ->
        get(conn, ~p"/news/#{news}")
      end
    end
  end

  defp create_news(_) do
    news = news_fixture()
    %{news: news}
  end
end
