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

  @derive Jason.Encoder
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
  def from_response(%{data: data} = decoded) when is_list(data) do
    Enum.map(decoded.data, &from_response/1)
  end

  @spec from_response(map) :: %__MODULE__{}
  def from_response(%{data: data}) do
    from_response(data)
  end

  @spec from_response(map) :: %__MODULE__{}
  def from_response(data) do
    IO.inspect data
    campaign =
      %{id: data.id}
      |> Map.merge(data.attributes)

      Kernel.struct(__MODULE__, campaign)
  end



  def opts_to_query([]) do
    []
  end

  def opts_to_query(include_fields) do
    Enum.reduce(include_fields, ["fields[member]": ""], &generate_query_option/2)
    |> Keyword.filter(fn({_key, val}) -> val != "" end)
    |> IO.inspect
  end

  defp generate_query_option({:member, []}, acc) do
    acc
  end

  defp generate_query_option({:member, member_fields}, acc) do
    Keyword.put(acc, :"fields[member]", Enum.join(member_fields, ","))
  end

  defp generate_query_option(_todo, acc) do
    acc
  end
end
