defmodule Patreon.API.V2 do
  @api_url "#{Patreon.Config.base_url()}/api/oauth2/v2"

  def get_identity(token) do
    middleware =[
      {Tesla.Middleware.BaseUrl, @api_url},
      Tesla.Middleware.DecodeJson,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{token}"}]}
    ]

    {:ok, resp} =
    Tesla.client(middleware)
    |> Tesla.get("#{@api_url}/identity")

    resp.body
  end
end
