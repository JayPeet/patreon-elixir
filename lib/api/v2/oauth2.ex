defmodule Patreon.API.V2.Oauth2 do
  require Patreon.TypeSpecHelpers

  @typedoc """
  Allowed fields for querying patreons User resource
  """
  Patreon.TypeSpecHelpers.struct_to_allowed_option_type(valid_user_resource_fields, Patreon.API.V2.Resource.User, [:id])
  Patreon.TypeSpecHelpers.struct_to_allowed_option_type(valid_campaign_resource_fields, Patreon.API.V2.Resource.Campaign, [:id])
  Patreon.TypeSpecHelpers.struct_to_allowed_option_type(valid_member_resource_fields, Patreon.API.V2.Resource.Member, [:id])

  @type option_test :: [:a | :b | :c | :d]
  @type user_option_test :: :about | :created

  @type get_identity_opts ::
    {:user, [] | [valid_user_resource_fields, ...]}
  | {:campaign, [] | [valid_campaign_resource_fields, ...]}
  | {:memberships, [] | [valid_member_resource_fields, ...]}

  @type get_campaign_opts ::
    {:campaign, [] | [valid_campaign_resource_fields, ...]}
  | {:tiers, []}
  | {:creator, []}
  | {:benefits, []}
  | {:goals, []}

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
  @spec get_identity(String.t, [get_identity_opts]) :: any
  def get_identity(oauth2_token, include_fields \\ [user: [:about,:can_see_nsfw,:created,:email,:first_name,:full_name,:hide_pledges,:image_url,:is_email_verified,:last_name,:like_count,:social_connections,:thumb_url,:url,:vanity]]) do
    {:ok, resp} =
      client(oauth2_token)
      |> Tesla.get("/identity", query: Patreon.API.V2.Resource.User.opts_to_query(include_fields))

    Jason.decode!(resp.body, keys: :atoms)
    |> Map.take([:data, :included])
    |> Patreon.API.V2.Resource.User.from_response()
  end

  @doc """
    Returns the campaigns for the user associated with `oauth2_token`.
  """
  @spec get_campaigns(String.t, [get_campaign_opts]) :: any
  def get_campaigns(oauth2_token, include_fields \\ [campaign: [:created_at,:creation_name,:discord_server_id,:google_analytics_id,:has_rss,:has_sent_rss_notify,:image_small_url,:image_url,:is_charged_immediately,:is_monthly,:is_nsfw,:main_video_embed,:main_video_url,:one_liner,:patron_count,:pay_per_name,:pledge_url,:published_at,:rss_artwork_url,:rss_feed_title,:show_earnings,:summary,:thanks_embed,:thanks_msg,:thanks_video_url,:url,:vanity]]) do
    {:ok, resp} =
      client(oauth2_token)
      |> Tesla.get("/campaigns", query: Patreon.API.V2.Resource.Campaign.opts_to_query(include_fields))

    decode_resp(resp.body, Patreon.API.V2.Resource.Campaign)
  end

  @spec get_campaigns_members(any, any, any) :: [Patreon.API.V2.Resource.Member.t()]
  def get_campaigns_members(oauth2_token, campaign, _include_fields) do
    {:ok, resp} =
      client(oauth2_token)
      |> Tesla.get("/campaigns/#{campaign.id}/members", query: ["fields[member]": "currently_entitled_amount_cents,full_name"])

    decode_resp(resp.body, Patreon.API.V2.Resource.Member)
  end

  defp decode_resp(resp_body, struct_type) do
    with  %{data: d} = _data <- Jason.decode!(resp_body, keys: :atoms),
          return_data <- Enum.map(d, &struct_type.from_response/1)
    do
      {:ok, return_data}
    else
      err -> {:error, err}
    end
  end
end
