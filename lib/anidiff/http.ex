defmodule Anidiff.Http do
  @moduledoc false

  @type response() :: map()

  @spec get(String.t()) :: response()
  def get(url) do
    headers = [
      {"content-type", "text/html"}
    ]

    request = Finch.build(:get, url, headers)

    {:ok, response} = Finch.request(request, MyFinch)

    response
  end

  @spec post(String.t(), map()) :: response()
  def post(url, data) do
    body = JSON.encode!(data)

    headers = [
      {"content-type", "application/json"}
    ]

    request = Finch.build(:post, url, headers, body)

    {:ok, response} = Finch.request(request, MyFinch)

    response
  end
end
