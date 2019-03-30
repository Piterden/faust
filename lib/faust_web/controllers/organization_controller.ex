defmodule FaustWeb.OrganizationController do
  use FaustWeb, :controller

  alias Faust.Accounts
  alias Faust.Accounts.Organization
  alias Faust.Repo

  def index(conn, _params) do
    organization = Accounts.list_organization()
    render(conn, "index.html", organization: organization)
  end

  def new(conn, _params) do
    changeset = Accounts.change_organization(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    case Accounts.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: Routes.organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Accounts.get_organization!(id)
    render(conn, "show.html", organization: organization)
  end

  def edit(conn, %{"id" => id}) do
    organization = get_organization_with_preloads(id, :credential)
    changeset = Accounts.change_organization(organization)
    render(conn, "edit.html", organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = get_organization_with_preloads(id, :credential)

    case Accounts.update_organization(organization, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: Routes.organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Accounts.get_organization!(id)
    {:ok, _organization} = Accounts.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: Routes.organization_path(conn, :index))
  end

  # Private functions ----------------------------------------------------------

  defp get_organization_with_preloads(id, preloads) do
    id
    |> Accounts.get_organization!()
    |> Repo.preload(preloads)
  end
end
