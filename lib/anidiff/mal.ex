defmodule Anidiff.Mal do
  @moduledoc false

  alias Anidiff.Env
  alias Anidiff.Http
  alias Anidiff.Html
  alias Anidiff.Json

  def anime_list do
    offsets =
      profile_doc()
      |> anime_total()
      |> offsets()

    Task.async_stream(offsets, &anime_list_chunk(&1))
    |> Stream.flat_map(fn {:ok, list} -> list end)
    |> Enum.into([])
  end

  def manga_list do
    offsets =
      profile_doc()
      |> manga_total()
      |> offsets()

    Task.async_stream(offsets, &manga_list_chunk(&1))
    |> Stream.flat_map(fn {:ok, list} -> list end)
    |> Enum.into([])
  end

  def profile_doc(http_client \\ Http) do
    Env.mal_username()
    |> then(&("https://myanimelist.net/profile/#{&1}"))
    |> http_client.get()
    |> then(&(&1.body))
    |> Html.parse()
  end

  def anime_total(doc) do
    doc
    |> Html.find(".stats.anime ul.stats-data li")
    |> Enum.find(&total_entries?/1)
    |> get_value()
  end

  def manga_total(doc) do
    doc
    |> Html.find(".stats.manga ul.stats-data li")
    |> Enum.find(&total_entries?/1)
    |> get_value()
  end

  defp total_entries?(list_element) do
    list_element
    |> Html.find("span:first-of-type")
    |> text_matches?("Total Entries")
  end

  defp text_matches?([{_, _, [node_text]}], text) when node_text == text, do: true
  defp text_matches?(_, _), do: false

  defp get_value(list_element) do
    [{_, _, [value]}] = Html.find(list_element, "span:last-of-type")

    value
    |> String.replace(~r/\D/, "")
    |> String.to_integer()
  end

  @chunk_size 300

  def offsets(total) do
    iterations = ceil(total / @chunk_size)

    for i <- 0..iterations, do: i * @chunk_size
  end

  def anime_list_chunk(offset, http_client \\ Http) do
    url = "https://myanimelist.net/animelist/#{Env.mal_username()}/load.json?offset=#{offset}"

    fetch_chunk(url, http_client)
  end

  def manga_list_chunk(offset, http_client \\ Http) do
    url = "https://myanimelist.net/mangalist/#{Env.mal_username()}/load.json?offset=#{offset}"

    fetch_chunk(url, http_client)
  end

  def fetch_chunk(url, http_client) do
    url
    |> http_client.get()
    |> then(&(&1.body))
    |> Json.parse()
  end
end
