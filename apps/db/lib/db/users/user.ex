defmodule Db.Users.User do
  use Ecto.Schema
  # import Ecto.Changeset
  alias Db.Users.Contact
  alias Db.Users.User
  alias Db.Messages.Message

  # @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :username, :string
    field :password_hash, :string
    many_to_many :contacts, User,
      join_through: Contact,
      join_keys: [user_id: :id, contact_id: :id]

    many_to_many :messages, User,
      join_through: Message,
      join_keys: [user: :id, from_user: :id]

    timestamps()
  end
end
