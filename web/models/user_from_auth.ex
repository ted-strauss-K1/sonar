defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """

  alias Ueberauth.Auth

  import Ecto.Query, only: [from: 2]
  alias Sonar.Repo
  alias Sonar.User
  alias Sonar.FacebookAccount

  def find_or_create(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}
      {:error, reason} -> {:error, reason}
    end
  end

  def find_or_create(%Auth{provider: :facebook} = auth) do
    query = from u in User,
      join: a in FacebookAccount, on: a.user_id == u.id,
      where: a.facebook_id == ^auth.uid

    case Repo.one(query) do
      nil -> create_user(auth)
      user -> {:ok, user.id}
    end
  end

  def find_or_create(%Auth{} = auth) do
    {:ok, basic_info(auth)}
  end

  def create_user(%Auth{provider: :facebook} = auth) do
    user = %User{
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      display_name: auth.info.first_name,
      email: auth.info.email,
      avatar: auth.info.image
    }
    case Repo.insert user do
      {:ok, struct} -> create_account(struct.id, auth)
      {:error, changeset} -> {:error, "User creation failed"}
    end
  end

  def create_account(uid, %Auth{provider: :facebook} = auth) do
    account = %FacebookAccount{
      user_id: uid,
      facebook_id: auth.uid,
      facebook_email: auth.info.email
    }
    case Repo.insert account do
      {:ok, struct} -> {:ok, uid}
      {:error, changeset} -> {:error, "Account creation failed"}
    end
  end

  defp basic_info(auth) do
    %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image, email: auth.info.email}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end
  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end
  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end
  defp validate_pass(_), do: {:error, "Password Required"}
end
