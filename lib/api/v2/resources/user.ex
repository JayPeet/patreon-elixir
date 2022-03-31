defmodule Patreon.API.V2.Resource.User do
  require Logger

  @typedoc """
  Represents a Patreon user.

  * `:about` - The user's about text, which appears on their profile.
  * `:can_see_nsfw` - `true` if this user can view nsfw content.
  * `:created` - Datetime of this user's account creation.
  * `:email` - The user's email address. Requires certain scopes to access. See the scopes section of the patreon API documentaiton.
  * `:first_name` - The users first name.
  * `:full_name` - The users full name.
  * `:hide_pledges` - `true` if the user has chosen to keep private which creators they pledge to.
  * `:image_url` - The user's profile picture URL, scaled to width 400px.
  * `:is_email_verified` - `true` if the user has confirmed their email.
  * `:last_name` - The users last name.
  * `:like_count` - How many posts the user has liked.
  * `:social_connections` - Mapping from user's connected app names to external user id on the respective app.
  * `:thumb_url` - The user's profile picture URL, scaled to a square of size 100x100px.
  * `:url` - URL of this user's creator or patron profile.
  * `:vanity` - The public "username" of the user.
  """
  @type t :: %__MODULE__{
    id: String.t,
    about:   String.t | nil,
    can_see_nsfw: boolean | nil,
    created: DateTime.t | nil,
    email: String.t | nil,
    first_name: String.t | nil,
    full_name: String.t | nil,
    hide_pledges: boolean | nil,
    image_url: String.t | nil,
    is_email_verified: boolean | nil,
    last_name: String.t | nil,
    like_count: integer | nil,
    social_connections: Patreon.API.V2.Resource.SocialConnections.t | nil,
    thumb_url: String.t | nil,
    url: String.t | nil,
    vanity: String.t | nil,
    included: %{campaign: Patreon.API.V2.Resource.Campaign.t | nil, memberships: any | []}
  }

  defstruct [
    :id,
    :about,
    :can_see_nsfw,
    :created,
    :email,
    :first_name,
    :full_name,
    :hide_pledges,
    :image_url,
    :is_email_verified,
    :last_name,
    :like_count,
    :social_connections,
    :thumb_url,
    :url,
    :vanity,
    :included,
  ]

  @spec from_response(%{data: map, included: list(map)}) :: %__MODULE__{}
  def from_response(%{data: data, included: includes}) do
    user =
      %{id: data.id}
      |> Map.merge(data.attributes)
      |> Map.put_new(:included, %{campaign: nil, memberships: []})
      |> add_includes(includes)

      Kernel.struct(__MODULE__, user)
  end

  @spec from_response(%{data: map}) :: %__MODULE__{}
  def from_response(%{data: data}) do
    from_response(%{data: data, included: []})
  end

  def add_includes(user, includes) do
    %{user | included: Enum.reduce(includes, user.included, &struct_from_include/2)}
  end

  def struct_from_include(%{type: "campaign"} = include, %{campaign: nil, memberships: _memberships} = user_includes) do
    %{user_includes | campaign: Patreon.API.V2.Resource.Campaign.from_response(include)}
  end

  def struct_from_include(%{type: "campaign"} = _include, %{campaign: _existing_campaign, memberships: _memberships} = user_includes) do
    Logger.warn "User already contained an existing campaign."
    user_includes
  end

  def struct_from_include(%{type: "member"} = include, %{campaign: _campaign, memberships: memberships} = user_includes) do
    %{user_includes | memberships: [Patreon.API.V2.Resource.Member.from_response(include) | memberships]}
  end

  def opts_to_query([]) do
    []
  end

  def opts_to_query(include_fields) do
    Enum.reduce(include_fields, ["fields[user]": "", include: "", "fields[campaign]": "", "fields[memberships]": ""], &generate_query_option/2)
    |> Keyword.filter(fn({_key, val}) -> val != "" end)
  end

  defp generate_query_option({:user, []}, acc) do
    acc
  end

  defp generate_query_option({:user, user_fields}, acc) do
    Keyword.put(acc, :"fields[user]", Enum.join(user_fields, ","))
  end

  defp generate_query_option({:campaign, campaign_fields}, acc) do
    updated_include =
    [Keyword.get(acc, :include), "campaign"]
    |> Enum.filter(fn(val) -> val != "" end)
    |> Enum.join(",")

    Keyword.put(acc, :"fields[campaign]", Enum.join(campaign_fields, ","))
    |> Keyword.put(:include, updated_include)
  end

  defp generate_query_option({:memberships, memberships_fields}, acc) do
    updated_include =
    [Keyword.get(acc, :include), "memberships"]
    |> Enum.filter(fn(val) -> val != "" end)
    |> Enum.join(",")

    Keyword.put(acc, :"fields[memberships]", Enum.join(memberships_fields, ","))
    |> Keyword.put(:include, updated_include)
  end
end
