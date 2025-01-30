defmodule Anidiff.Comparator do
  @moduledoc false

  alias Anidiff.MangaEntry
  alias Anidiff.AnimeEntry
  alias Anidiff.Mal
  alias Anidiff.Shiki

  @type entry() :: map()

  @type entry_eql() :: (entry(), entry() -> boolean())

  @spec anime() :: [entry()]
  def anime do
    mal_entries = to_map_as(Mal.anime_list(), AnimeEntry)
    shiki_entries = to_map_as(Shiki.anime_list(), AnimeEntry)
    uniq_diff(mal_entries, shiki_entries, &AnimeEntry.equals?/2)
  end

  @spec manga() :: [entry()]
  def manga do
    mal_entries = to_map_as(Mal.manga_list(), MangaEntry)
    shiki_entries = to_map_as(Shiki.manga_list(), MangaEntry)
    uniq_diff(mal_entries, shiki_entries, &MangaEntry.equals?/2)
  end

  @spec uniq_diff(%{pos_integer() => entry()}, %{pos_integer() => entry()}, entry_eql()) ::
          [map()]
  def uniq_diff(entries1, entries2, test) do
    diff1 = diff(entries1, entries2, test)
    diff2 = diff(entries2, entries1, test)
    Enum.uniq_by(diff1 ++ diff2, fn e -> e.id end)
  end

  @spec diff(%{pos_integer() => entry()}, %{pos_integer() => entry()}, entry_eql()) :: [entry()]
  def diff(entries1, entries2, test) do
    entries1
    |> Task.async_stream(fn entry1 -> compare(entry1, entries2, test) end)
    |> to_list()
  end

  @spec compare({pos_integer(), entry()}, %{pos_integer() => entry()}, entry_eql()) ::
          entry() | nil
  def compare({entry_id, entry}, other_entries, test) do
    other_entry = Map.get(other_entries, entry_id)

    if not test.(entry, other_entry), do: entry
  end

  @spec to_list(Enumerable.t()) :: [entry()]
  def to_list(stream) do
    stream
    |> Stream.map(fn {:ok, term} -> term end)
    |> Stream.reject(&is_nil/1)
    |> Enum.to_list()
  end

  @spec to_map_as([entry()], module()) :: %{pos_integer() => entry()}
  def to_map_as(map_list, struct) do
    map_list
    |> Enum.map(&struct.new/1)
    |> Enum.into(%{}, fn e -> {e.id, e} end)
  end
end
