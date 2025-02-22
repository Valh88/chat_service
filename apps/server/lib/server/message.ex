defmodule Server.Message do
  alias PubSub.Presence
  alias Server.Message
  alias Db.Messages

  @enforce_keys [:type, :message]
  defstruct [
    :type,
    :message
  ]

  @type t :: %__MODULE__{
          type: :private | :room | :custom,
          message: map()
          # private %{from: from, to: to, message: message}
          # room %{from: from},
          # custom somethink binary
        }

  def json_to_struct(data) do
    case Jason.decode(data) do
      {:ok, mess} ->
        case type(mess["type"]) do
          :private ->
            %Message{
              type: :private,
              message: %{
                from: String.to_integer(mess["message"]["from"]),
                to: String.to_integer(mess["message"]["to"]),
                message: mess["message"]["message"]
              }
            }

          :room ->
            %Message{
              type: :room,
              message: %{
                from: String.to_integer(mess["message"]["from"])
              }
            }

          :custom ->
            %Message{
              type: :custom,
              message: mess["message"]["message"]
            }
        end

      {:error, error} ->
        {:error, error}
    end
  end

  def send_message(message) do
    case Presence.get_online_user(message.message.to) do
      {pid, _user_id} ->
        IO.inspect(pid)
        send(pid, {:broadcast, {:message, message}})

      false ->
        Messages.create_undelivered(message.message.to, message.message.message, message.message.from)
    end
  end

  def to_json_string(%Message{} = message) do
    %{type: message.type, from: message.message.from, message: message.message.message}
    |> Jason.encode!()
  end

  def new_messages(user_id) do
    messages = Messages.check_new_messages(user_id)
    fun = fn message ->
      %{from: message.from_user_id, message: message.message, date: message.inserted_at}
    end
    Messages.update_status_delivered(user_id)
    %{new_messages: Enum.map(messages, fun)}
    |> Jason.encode!()
  end

  defp type(type) do
    case type do
      "private" -> :private
      "room" -> :room
      "custom" -> :custom
    end
  end
end
