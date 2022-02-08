defmodule Patreon.API.V2.Resource.SocialConnections.Discord do

  @type t :: %__MODULE__{
    scopes: list(String.t) | nil,
    url: String.t | nil,
    user_id: String.t | nil
  }

  defstruct [
    :scopes,
    :url,
    :user_id
  ]
end
