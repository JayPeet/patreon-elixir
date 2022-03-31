defmodule Patreon.API.V2.Resource.Campaign do

  @type t :: %__MODULE__{
    created_at: DateTime.t,
    creation_name: String.t | nil,
    discord_server_id: String.t | nil,
    google_analytics_id: String.t | nil,
    has_rss: boolean,
    has_sent_rss_notify: boolean,
    image_small_url: String.t,
    image_url: String.t,
    is_charged_immediately: boolean | nil,
    is_monthly: boolean | nil,
    is_nsfw: boolean,
    main_video_embed: String.t | nil,
    main_video_url: String.t | nil,
    one_liner: String.t | nil,
    patron_count: integer,
    pay_per_name: String.t | nil,
    published_at: DateTime.t,
    rss_artwork_url: String.t | nil,
    rss_feed_title: String.t,
    show_earnings: boolean,
    summary: String.t | nil,
    thanks_embed: String.t | nil,
    thanks_msg: String.t | nil,
    thanks_video_url: String.t | nil,
    url: String.t,
    vanity: String.t | nil
  }

  @derive Jason.Encoder
  defstruct [
    :id,
    :created_at,
    :creation_name,
    :discord_server_id,
    :google_analytics_id,
    :has_rss,
    :has_sent_rss_notify,
    :image_small_url,
    :image_url,
    :is_charged_immediately,
    :is_monthly,
    :is_nsfw,
    :main_video_embed,
    :main_video_url,
    :one_liner,
    :patron_count,
    :pay_per_name,
    :pledge_url,
    :published_at,
    :rss_artwork_url,
    :rss_feed_title,
    :show_earnings,
    :summary,
    :thanks_embed,
    :thanks_msg,
    :thanks_video_url,
    :url,
    :vanity,
  ]

  @spec from_response(map) :: %__MODULE__{}
  def from_response(%{data: data} = decoded) when is_list(data) do
    Enum.map(decoded.data, &from_response/1)
  end

  @spec from_response(map) :: %__MODULE__{}
  def from_response(%{data: data}) do
    from_response(data)
  end

  @spec from_response(map) :: %__MODULE__{}
  def from_response(data) do
    campaign =
      %{id: data.id}
      |> Map.merge(data.attributes)

      Kernel.struct(__MODULE__, campaign)
  end

  def opts_to_query([]) do
    []
  end

  def opts_to_query(include_fields) do
    Enum.reduce(include_fields, ["fields[campaign]": "", "fields[tiers]": "", "fields[creator]": "", "fields[benefits]": "", "fields[goals]": ""], &generate_query_option/2)
    |> Keyword.filter(fn({_key, val}) -> val != "" end)
  end

  defp generate_query_option({:campaign, []}, acc) do
    acc
  end

  defp generate_query_option({:campaign, campaign_fields}, acc) do
    Keyword.put(acc, :"fields[campaign]", Enum.join(campaign_fields, ","))
  end

  defp generate_query_option(_todo, acc) do
    acc
  end
end
