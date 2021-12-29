defmodule Patreon.API.V2.Resources.User do

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
    social_connections: any,
    thumb_url: String.t | nil,
    url: String.t | nil,
    vanity: String.t | nil,
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
  ]

  @spec from_response(map) :: %__MODULE__{}
  def from_response(response_map) do
    user =
      %{id: response_map.id}
      |> Map.merge(response_map.attributes)

      Kernel.struct(__MODULE__, user)
  end
end
