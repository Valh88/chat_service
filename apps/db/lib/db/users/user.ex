defmodule Db.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Db.Users.Contact
  alias Db.Users.User
  alias Db.Messages.Message

  # @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:username, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)

    many_to_many(:contacts, User,
      join_through: Contact,
      join_keys: [user_id: :id, contact_id: :id]
    )

    many_to_many(:messages, User,
      join_through: Message,
      join_keys: [user: :id, from_user: :id]
    )

    timestamps()
  end

  def changeset(data_user_creation, attrs) do
    data_user_creation
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 8)
    |> validate_length(:username, max: 20, message: "max len 20")
    |> unique_constraint(:username, message: "already taken.")
    |> _put_password_hash()
  end

  defp _put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp _put_password_hash(changeset), do: changeset
end
