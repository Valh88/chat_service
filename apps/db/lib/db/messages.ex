defmodule Db.Messages do
  # import Ecto.Query
  alias Db.Repo
  alias Db.Messages.Message

  def create(user_id, message, from_id) do
    %Message{}
    |> Message.changeset(%{user_id: user_id, message: message, from_user_id: from_id})
    |> Repo.insert()
  end
end
