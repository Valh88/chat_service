defmodule Db.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Db.Users.User

  schema "private_messages" do
    belongs_to(:user, User)
    belongs_to(:from_user, User)
    field(:message, :string)
    # TODO  доставлено-не доставлено delivered undelivered
    field(:status, :string)

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :message, :from_user_id, :status])
    |> validate_required([:user_id, :message, :from_user_id, :status])

    # |> put_change(:status, "undelivered")
  end
end
