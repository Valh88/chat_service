defmodule Db.Contacts do
    import Ecto.Query
    alias Db.Repo
    alias Db.Users.Contact

    def create(user_id, contact_id) do
      %Contact{}
      |> Contact.changeset(%{user_id: user_id, contact_id: contact_id})
      |> Repo.insert()
    end

    def contact_users_by_contact_id(user_id) do
      query = from c in Contact,
              where: c.contact_id == ^user_id,
              select: c.user_id
      Repo.all(query)
    end

  end
