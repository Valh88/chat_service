defmodule Db.Messages.Message do
  use Ecto.Schema
  # import Ecto.Changeset
  alias Db.Users.User

  schema "private_messages" do
    belongs_to :user, User
    belongs_to :from_user, User
    field :message, :string
    field :status, :string #TODO  доставлено-не доставлено

    timestamps()
  end

end
