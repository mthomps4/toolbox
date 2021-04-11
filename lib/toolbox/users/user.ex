defmodule Toolbox.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  def create_user(email, password) do
    Toolbox.Users.User.changeset(%Toolbox.Users.User{}, %{
      email: email,
      password: password,
      password_confirmation: password
    })
    |> Toolbox.Repo.insert()
  end
end
