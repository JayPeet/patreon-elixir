defmodule Test do
  def list_members_by_lifetime_payment(oauth2_token) do
    [campaign] = Patreon.API.V2.Oauth2.get_campaigns(oauth2_token, [])
    members = Patreon.API.V2.Oauth2.get_campaigns_members(oauth2_token, campaign, [])
    Enum.sort_by(members, &(&1.campaign_lifetime_support_cents))
    |> Enum.each(fn(v) -> IO.puts "#{v.full_name} : #{v.campaign_lifetime_support_cents}" end)
  end
end
