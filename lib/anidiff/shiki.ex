defmodule Anidiff.Shiki do
  @moduledoc false

  alias Anidiff.Env
  alias Anidiff.Http
  alias Anidiff.Json

  @shikimori_prefix "https://shikimori.me"

  @spec anime_list() :: [map()]
  def anime_list do
    url = "#{@shikimori_prefix}/#{Env.shiki_username()}/list_export/animes.json"

    fetch(url, Http)
  end

  @spec manga_list() :: [map()]
  def manga_list do
    url = "#{@shikimori_prefix}/#{Env.shiki_username()}/list_export/mangas.json"

    fetch(url, Http)
  end

  @spec fetch(String.t(), module()) :: [map()]
  def fetch(url, http_client) do
    url
    |> http_client.get()
    |> then(& &1.body)
    |> Json.parse()
  end
end
