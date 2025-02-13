defmodule Db.Repo.Migrations.CreateContactsTable do
  use Ecto.Migration

  def change do
    create table :contacts do
      add :user_id, references(:users)
      add :contact_id, references(:users)

      timestamps()
    end
  end
end
