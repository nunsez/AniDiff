defmodule Anidiff.Http do
  @moduledoc false

  @type response() :: map()

  @callback get(String.t()) :: response()

  @callback post(String.t(), map()) :: response()

  @behaviour __MODULE__

  @impl __MODULE__
  def get(url) do
    headers = [
      {"content-type", "text/html"}
    ]

    request = Finch.build(:get, url, headers)
    Finch.request!(request, MyFinch)
  end

  @impl __MODULE__
  def post(url, data) do
    body = JSON.encode!(data)

    headers = [
      {"content-type", "application/json"}
    ]

    request = Finch.build(:post, url, headers, body)
    Finch.request!(request, MyFinch)
  end
end
