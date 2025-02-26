defmodule Db.Messages do
  import Ecto.Query
  alias Db.Repo
  alias Db.Messages.Message

  def create_undelivered(user_id, message, from_id) do
    %Message{}
    |> Message.changeset(%{
      user_id: user_id,
      message: message,
      from_user_id: from_id,
      status: "undelivered"
    })
    |> Repo.insert()
  end

  def create_delivered(user_id, message, from_id) do
    %Message{}
    |> Message.changeset(%{
      user_id: user_id,
      message: message,
      from_user_id: from_id,
      status: "delivered"
    })
    |> Repo.insert()
  end

  def check_new_messages(user_id) do
    query =
      from(m in Message,
        where:
          m.user_id == ^user_id and
            m.status == "undelivered",
        select: m
      )

    Repo.all(query)
  end

  def update_status_delivered(user_id) do
    from(m in Message,
      where:
        m.user_id == ^user_id and
          m.status == "undelivered",
      update: [set: [status: "delivered"]]
    )
    |> Repo.update_all([])
  end
end
