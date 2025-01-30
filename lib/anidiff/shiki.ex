defmodule Anidiff.Shiki do
  @moduledoc false

  alias Anidiff.Env
  alias Anidiff.Http

  @shikimori_prefix "https://shikimori.one"

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
    response = http_client.get(url)
    JSON.decode!(response.body)
  end
end
