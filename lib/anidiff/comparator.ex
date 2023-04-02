defmodule Anidiff.Comparator do
  @moduledoc false

  alias Anidiff.MangaEntry
  alias Anidiff.AnimeEntry
  alias Anidiff.Mal
  alias Anidiff.Shiki

  @spec anime() :: [AnimeEntry.t()]
  def anime do
    mal_entries =
      Mal.anime_list()
      |> to_map_as(AnimeEntry)

    shiki_entries =
      Shiki.anime_list()
      |> to_map_as(AnimeEntry)

    mal_diff =
      Task.async_stream(mal_entries, &compare(&1, shiki_entries))
      |> to_list()

    shiki_diff =
      Task.async_stream(shiki_entries, &compare(&1, mal_entries))
      |> to_list()

    Enum.uniq_by(mal_diff ++ shiki_diff, fn e -> e.id end)
  end

  @spec manga() :: [MangaEntry.t()]
  def manga do
    mal_entries =
      Mal.manga_list()
      |> to_map_as(MangaEntry)

    shiki_entries =
      Shiki.manga_list()
      |> to_map_as(MangaEntry)

    mal_diff =
      Task.async_stream(mal_entries, &compare(&1, shiki_entries))
      |> to_list()

    shiki_diff =
      Task.async_stream(shiki_entries, &compare(&1, mal_entries))
      |> to_list()

    Enum.uniq_by(mal_diff ++ shiki_diff, fn e -> e.id end)
  end

  @spec compare(
          {pos_integer(), AnimeEntry.t() | MangaEntry.t()},
          %{pos_integer() => AnimeEntry.t()} | %{pos_integer() => MangaEntry.t()}
        ) :: AnimeEntry.t() | MangaEntry.t() | nil
  def compare({anime_id, entry}, other_entries) when is_struct(entry, AnimeEntry) do
    equal_result =
      other_entries
      |> Map.get(anime_id)
      |> AnimeEntry.equals?(entry)

    if equal_result, do: nil, else: entry
  end

  def compare({manga_id, entry}, other_entries) when is_struct(entry, MangaEntry) do
    equal_result =
      other_entries
      |> Map.get(manga_id)
      |> MangaEntry.equals?(entry)

    if equal_result, do: nil, else: entry
  end

  @spec to_list(Enumerable.t()) :: [AnimeEntry.t()] | [MangaEntry.t()]
  def to_list(stream) do
    stream
    |> Stream.map(fn {:ok, term} -> term end)
    |> Stream.reject(&is_nil/1)
    |> Enum.to_list()
  end

  @spec to_map_as([map()], module()) ::
          %{pos_integer() => AnimeEntry.t()} | %{pos_integer() => MangaEntry.t()}
  def to_map_as(map_list, struct) do
    map_list
    |> Enum.map(&struct.new/1)
    |> Enum.into(%{}, fn e -> {e.id, e} end)
  end
end
