defmodule ShorturlWeb.LinkController do
  use ShorturlWeb, :controller

  alias Shorturl.Links
  alias Shorturl.Links.Link

  def new(conn, _params) do
    changeset = Links.change_link(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    key = random_string(8)
    params = Map.put_new(link_params, "id", key)

    case Links.create_link(params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: Routes.link_path(conn, :show, link))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def redirect_to(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    # TODO: Add async function to update visit count of the link
    Task.start(fn -> update_visits_for_link(link) end)
    redirect(conn, external: link.url)
  end

  def show(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    domain = System.get_env("APP_DOMAIN") || nil
    render(conn, "show.html", link: link, domain: domain)
  end

  defp update_visits_for_link(link) do
    Links.update_link(link, %{visits: link.visits + 1})
  end

  defp random_string(string_length) do
    :crypto.strong_rand_bytes(string_length)
    |> Base.url_encode64()
    |> binary_part(0, string_length)
  end
end
