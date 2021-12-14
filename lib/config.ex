defmodule Patreon.Config do
  @base_url Application.get_env(:patreon, :base_url, "https://www.patreon.com")
  @client_secret Application.get_env(:patreon, :client_secret, nil)
  @client_id Application.get_env(:patreon, :client_id, nil)
  @redirect_url Application.get_env(:patreon, :redirect_url, nil)
  @authorization_code_form %{
    code: nil,
    grant_type: "authorization_code",
    client_id: @client_id,
    client_secret: @client_secret,
    redirect_uri: @redirect_url
  }

  def base_url, do: @base_url
  def client_secret, do: @client_secret
  def client_id, do: @client_id
  def redirect_url, do: @redirect_url
  def authorization_code_form, do: @authorization_code_form
  def authorization_code_form(code), do: Map.replace!(@authorization_code_form, :code, code)
end
