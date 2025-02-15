defmodule Db.Users.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Db.Users.User

  schema "contacts" do
    belongs_to(:user, User)
    belongs_to(:contact, User)

    timestamps()
  end

  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:user_id, :contact_id])
    |> validate_required([:user_id, :contact_id])
  end
end
