defmodule Db.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table :users do
      add :username, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
