defmodule Patreon.API.V2.Oauth2 do
  require Patreon.TypeSpecHelpers

  @typedoc """
  Allowed fields for querying patreons User resource
  """
  Patreon.TypeSpecHelpers.struct_to_option_list(valid_user_scope_fields, Patreon.API.V2.Resources.User, [:id])
  Patreon.TypeSpecHelpers.struct_to_option_list(valid_campaign_resource_fields, Patreon.API.V2.Resources.Campaign, [:id])

  defp oauth2_scope() do
    "#{Patreon.Config.base_url()}/api/oauth2/v2"
  end

  defp client(oauth2_token) do
    middleware =[
      {Tesla.Middleware.BaseUrl, oauth2_scope()},
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{oauth2_token}"}]}
    ]

    Tesla.client(middleware)
  end

  @doc """
    Returns the user associated with `oauth2_token`. By default, all user fields will be returned unless specified.
  """
  @spec get_identity(String.t, valid_user_scope_fields) :: Patreon.API.V2.Resources.User.t
  def get_identity(oauth2_token, user_fields \\ [:about,:can_see_nsfw,:created,:email,:first_name,:full_name,:hide_pledges,:image_url,:is_email_verified,:last_name,:like_count,:social_connections,:thumb_url,:url,:vanity]) do
    {:ok, resp} =
    client(oauth2_token)
    |> Tesla.get("/identity", query: ["fields[user]": Enum.join(user_fields, ",")])

    Jason.decode!(resp.body, keys: :atoms)
    |> Map.get(:data)
    |> Patreon.API.V2.Resources.User.from_response()
  end

  @spec get_campaigns(String.t, valid_campaign_resource_fields) :: any
  @doc """
    Returns the campaigns for the user associated with `oauth2_token`.
  """
  def get_campaigns(oauth2_token, campaign_fields \\ [:created_at,:creation_name,:discord_server_id,:google_analytics_id,:has_rss,:has_sent_rss_notify,:image_small_url,:image_url,:is_charged_immediately,:is_monthly,:is_nsfw,:main_video_embed,:main_video_url,:one_liner,:patron_count,:pay_per_name,:pledge_url,:published_at,:rss_artwork_url,:rss_feed_title,:show_earnings,:summary,:thanks_embed,:thanks_msg,:thanks_video_url,:url,:vanity]) do
    {:ok, resp} =
      client(oauth2_token)
      |> Tesla.get("/campaigns", query: ["fields[campaign]": Enum.join(campaign_fields, ",")])

      Jason.decode!(resp.body, keys: :atoms)
      |> Map.get(:data)
      |> Enum.map(&Patreon.API.V2.Resources.Campaign.from_response/1)
  end
end
