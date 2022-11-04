defmodule Patreon do
  @moduledoc false
  use Tesla

  plug Tesla.Middleware.BaseUrl, Patreon.Config.base_url()
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.DecodeJson

  @type refresh_response() :: %{
    "access_token": String.t(),
    "refresh_token": String.t(),
    "expires_in": any(),
    "scope": any(),
    "token_type": String.t()
}

  def validate_authorization_code(code) do
    case post("/api/oauth2/token", Patreon.Config.authorization_code_form(code)) do
      {:ok, resp} ->
        case resp.status do
          code when code >= 200 and code <= 229 ->
             {:ok, resp.body}
          err ->
            {:error, %{error: Patreon.ErrorCode.status_to_error(err)}}
          end
      {:error, err} -> {:error, err.body}
    end
  end

  @spec refresh_oauth2_token(String.t()) :: refresh_response()
  def refresh_oauth2_token(refresh_token) do
    case post("/api/oauth2/token", Patreon.Config.refresh_token_form(refresh_token)) do
      {:ok, resp} ->
        case resp.status do
          code when code >= 200 and code <= 229 ->
             {:ok, resp.body}
          err ->
            {:error, %{error: Patreon.ErrorCode.status_to_error(err)}}
          end
      {:error, err} -> {:error, err.body}
    end
  end
end
