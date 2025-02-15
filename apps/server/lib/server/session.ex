defmodule Server.Session do
  @table :session

  def init() do
    :ets.new(@table, [:named_table, :public, read_concurrency: true])
  end

  def put_session(token, data) do
    :ets.insert(@table, {token, data})
    :ok
  end

  def get_session(key) do
    case :ets.lookup(@table, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  def delete_session(key) do
    :ets.delete(@table, key)
  end
end
