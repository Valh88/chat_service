defmodule Db.Users.Contact do
  use Ecto.Schema
  # # import Ecto.Changeset
  alias Db.Users.User

  schema "contacts" do
    belongs_to(:user, User)
    belongs_to(:contact, User)

    timestamps()
  end
end
