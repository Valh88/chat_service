defmodule Db.Messages.Message do
  use Ecto.Schema
  # import Ecto.Changeset
  alias Db.Users.User

  schema "private_messages" do
    belongs_to(:user, User)
    belongs_to(:from_user, User)
    field(:message, :string)
    # TODO  доставлено-не доставлено
    field(:status, :string)

    timestamps()
  end
end
