defmodule Db.Users do
  import Ecto.Query
  alias Db.Users.{User}
  alias Db.Repo

  def create(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def delete_by_username(username) do
    User
    |> where(username: ^username)
    |> Repo.delete()
  end

  def get_by_username(username) do
    User
    |> where(username: ^username)
    |> Repo.one()
  end

  def get_by_id(user_id) do
    User
    |> where(id: ^user_id)
    |> Repo.one()
  end

  def get_by_id(user_id, :preload) do
    User
    |> where(id: ^user_id)
    |> Repo.one()
    |> Repo.preload(:contacts)
  end

  def delete(user) do
    user
    |> Repo.delete()
  end

  def add_contact(user_id, contact_id) do
    user = get_by_id(user_id, :preload)
    contact = get_by_id(contact_id)

    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:contacts, [contact])
    |> Repo.update()
  end

  def check_username_password?(password, password_hash) do
    Argon2.verify_pass(password, password_hash)
  end

  def changeset_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&translate_error/1)
  end

  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
