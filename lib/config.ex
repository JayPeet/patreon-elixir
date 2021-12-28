defmodule Patreon.Config do
  def base_url, do: Application.get_env(:patreon, :base_url, "https://www.patreon.com")
  def client_secret, do: Application.get_env(:patreon, :client_secret, nil)
  def client_id, do: Application.get_env(:patreon, :client_id, nil)
  def redirect_url, do: Application.get_env(:patreon, :redirect_url, nil)

  def authorization_code_form() do
    %{
      code: nil,
      grant_type: "authorization_code",
      client_id: client_id(),
      client_secret: client_secret(),
      redirect_uri: redirect_url()
    }
  end

  def authorization_code_form(code) do
    authorization_code_form()
    |> Map.replace!(:code, code)
  end
end
