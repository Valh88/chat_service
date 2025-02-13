defmodule Db.Repo.Migrations.CreateMessagesTable do
  use Ecto.Migration

  def change do
    create table :private_messages do
      add :user_id, references(:users)
      add :from_user, references(:users)
      add :message, :string
      add :status, :string

      timestamps()
    end
  end
end
