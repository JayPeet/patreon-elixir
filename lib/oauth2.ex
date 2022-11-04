defmodule Patreon.OAuth2 do
  require Logger

  def oauth2_url() do
    "#{Patreon.Config.base_url()}/oauth2/authorize?response_type=code&client_id=#{Patreon.Config.client_id()}&redirect_uri=#{Patreon.Config.redirect_url()}"
  end

  def authorize_url() do
    oauth2_url()
  end

  def authorize_url([scope: scope]) do
    "#{oauth2_url()}&scope=#{scope}"
  end

  def authorize_url([state: state]) do
    "#{oauth2_url()}&state=#{state}"
  end

  def authorize_url([scope: scope, state: state]) do
    "#{oauth2_url()}&scope=#{scope}&state=#{state}"
  end

  def validate_authorization_code(code) do
    Patreon.validate_authorization_code(code)
  end

  def refresh_oauth2_token(refresh_token) do
    Patreon.refresh_oauth2_token(refresh_token)
  end
end
