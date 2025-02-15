defmodule Db.Contacts do
    # import Ecto.Query
    alias Db.Repo
    alias Db.Users.Contact

    def create(user_id, contact_id) do
      %Contact{}
      |> Contact.changeset(%{user_id: user_id, contact_id: contact_id})
      |> Repo.insert()
    end

  end
