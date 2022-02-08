defmodule Patreon.API.V2.Resource.Member do

  @type t :: %__MODULE__{
    id: String.t,
    campaign_lifetime_support_cents: integer | nil,
    currently_entitled_amount_cents: integer | nil,
    email: String.t | nil,
    full_name: String.t | nil,
    is_follower: boolean | nil,
    last_charge_date: DateTime.t | nil,
    last_charge_status: String.t | nil,
    lifetime_support_cents: integer | nil,
    next_charge_date: DateTime.t | nil,
    note: String.t | nil,
    patreon_status: String.t | nil,
    pledge_candence: integer | nil,
    pledge_relationship_start: DateTime.t | nil,
    will_pay_amount_cents: integer | nil,
  }

  defstruct [
    :id,
    :campaign_lifetime_support_cents,
    :currently_entitled_amount_cents,
    :email,
    :full_name,
    :is_follower,
    :last_charge_date,
    :last_charge_status,
    :lifetime_support_cents,
    :next_charge_date,
    :note,
    :patreon_status,
    :pledge_candence,
    :pledge_relationship_start,
    :will_pay_amount_cents,
  ]

  @spec from_response(map) :: %__MODULE__{}
  def from_response(response_map) do
    IO.inspect response_map
    campaign =
      %{id: response_map.id}
      |> Map.merge(response_map.attributes)

      Kernel.struct(__MODULE__, campaign)
  end
end
