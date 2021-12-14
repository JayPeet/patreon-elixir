defmodule Patreon.ErrorCode do
  @moduledoc false
  def status_to_error(400) do
    "Bad Request -- Something was wrong with your request (syntax, size too large, etc.)"
  end

  def status_to_error(401) do
    "Unauthorized -- Authentication failed (bad API key, invalid OAuth token, incorrect scopes, etc.)"
  end

  def status_to_error(403) do
    "Forbidden -- The requested is hidden for administrators only."
  end

  def status_to_error(404) do
    "Not Found -- The specified resource could not be found."
  end

  def status_to_error(405) do
    "Method Not Allowed -- You tried to access a resource with an invalid method."
  end

  def status_to_error(406) do
    "Not Acceptable -- You requested a format that isn't json."
  end

  def status_to_error(410) do
    "Gone -- The resource requested has been removed from our servers."
  end

  def status_to_error(429) do
    "Too Many Requests -- Slow down!"
  end

  def status_to_error(500) do
    "Internal Server Error -- Our server ran into a problem while processing this request. Please try again later."
  end

  def status_to_error(503) do
    "Service Unavailable -- We're temporarily offline for maintenance. Please try again later."
  end

  def status_to_error(unknown) do
    "Unknown error code #{unknown}"
  end
end
