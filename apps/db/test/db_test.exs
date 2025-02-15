defmodule DbTest do
  use ExUnit.Case
  alias Db.Users
  doctest Db

  test "greets the world" do
    assert Db.hello() == :world
  end

  test "assoc" do
    Users.add_contact(10, 12)
    IO.inspect(Users.get_by_id(4))
  end
end
