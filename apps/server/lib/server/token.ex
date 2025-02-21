defmodule Server.Token do
  use Joken.Config

  # Конфигурация токена
  def token_config() do
    default_claims()
    # TODO session check
    |> add_claim("user_id", fn -> false end)
    |> add_claim("role", fn -> "USER" end, &(&1 in ["ADMIN"]))
  end

  def generate_token(data) do
    data
    |> Jason.encode!()
    |> Base.url_encode64()
  end

  def verify_token(token) do
    case Base.url_decode64(token) do
      {:ok, decoded} ->
        Jason.decode(decoded)

      :error ->
        {:error, :invalid_token}
    end
  end

  def check_token?(token) do
    case token do
      nil -> false
      _ -> true
    end
  end
end
