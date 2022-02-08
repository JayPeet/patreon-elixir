defmodule Patreon.API.V2.Resource.SocialConnections do

  @type t :: %__MODULE__{
    deviantart: map | nil,
    discord: Patreon.API.V2.Resource.SocialConnections.Discord.t | nil,
    facebook: map | nil,
    google: map | nil,
    instagram: map | nil,
    reddit: map | nil,
    spotify: map | nil,
    twitch: map | nil,
    twitter: map | nil,
    vimeo: map | nil,
    youtube: map | nil,
  }

  defstruct [
    :deviantart,
    :discord,
    :facebook,
    :google,
    :instagram,
    :reddit,
    :spotify,
    :twitch,
    :twitter,
    :vimeo,
    :youtube,
  ]
end
