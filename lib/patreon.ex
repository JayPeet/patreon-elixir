defmodule Patreon do
  @moduledoc false
  use Tesla

  plug Tesla.Middleware.BaseUrl, Patreon.Config.base_url()
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.DecodeJson

  def validate_authorization_code(code) do
    case post("/api/oauth2/token", Patreon.Config.authorization_code_form(code)) do
      {:ok, resp} ->
        case resp.status do
          code when code >= 200 and code <= 229 ->
             {:ok, resp.body}
          err ->
            IO.inspect err
            {:error, %{error: Patreon.ErrorCode.status_to_error(err)}}
          end
      {:error, err} -> {:error, err.body}
    end
  end
end
