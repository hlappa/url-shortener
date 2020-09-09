defmodule ShorturlWeb.LinkControllerTest do
  use ShorturlWeb.ConnCase

  alias Shorturl.Links

  @create_attrs %{id: "dkljd34g", url: "some url", visits: 42}
  @invalid_attrs %{url: nil, visits: nil}

  def fixture(:link) do
    {:ok, link} = Links.create_link(@create_attrs)
    link
  end

  describe "new link" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :new))
      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "create link" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @create_attrs)

      assert %{id: "dkljd34g"} = redirected_params(conn)
      assert redirected_to(conn) == Routes.link_path(conn, :show, "dkljd34g")

      conn = get(conn, Routes.link_path(conn, :show, "dkljd34g"))
      assert html_response(conn, 200) =~ "Show Link"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Link"
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    %{link: link}
  end
end
