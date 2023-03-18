defmodule Anidiff.Shiki do
  @moduledoc false

  alias Anidiff.Env
  alias Anidiff.Http
  alias Anidiff.Json

  def anime_list do
    url = "https://shikimori.one/#{Env.shiki_username()}/list_export/animes.json"

    fetch(url, Http)
  end

  def manga_list do
    url = "https://shikimori.one/#{Env.shiki_username()}/list_export/mangas.json"

    fetch(url, Http)
  end

  def fetch(url, http_client) do
    url
    |> http_client.get()
    |> then(&(&1.body))
    |> Json.parse()
  end
end
