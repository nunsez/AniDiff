defmodule Anidiff.AnimeEntry do
  @moduledoc false

  defstruct [
    :id,
    :title,
    :status,
    :score,
    :episodes_watched,
    :source
  ]

  @type t() :: %__MODULE__{
          id: pos_integer(),
          title: String.t(),
          status: integer(),
          score: integer(),
          episodes_watched: non_neg_integer(),
          source: :shiki | :mal
        }

  # Mal constructor
  @spec new(map()) :: t()
  def new(%{
        "anime_id" => id,
        "anime_title" => title,
        "status" => status,
        "score" => score,
        "num_watched_episodes" => episodes_watched
      })
      when not is_nil(id) do
    %__MODULE__{
      id: id,
      title: title,
      status: format_status(status),
      score: score,
      episodes_watched: episodes_watched,
      source: :mal
    }
  end

  # Shiki constructor
  def new(%{
        "target_id" => id,
        "target_title" => title,
        "status" => status,
        "score" => score,
        "episodes" => episodes_watched
      })
      when not is_nil(id) do
    %__MODULE__{
      id: id,
      title: title,
      status: status,
      score: score,
      episodes_watched: episodes_watched,
      source: :shiki
    }
  end

  @spec equals?(t(), t()) :: boolean()
  def equals?(a, b) when is_struct(a, __MODULE__) and is_struct(b, __MODULE__) do
    a.status == b.status and
      a.score == b.score and
      a.episodes_watched == b.episodes_watched
  end

  def equals?(_, _), do: false

  @spec format_status(any()) :: String.t()
  defp format_status(1), do: "watching"
  defp format_status(2), do: "completed"
  defp format_status(3), do: "on_hold"
  defp format_status(4), do: "dropped"
  defp format_status(6), do: "planned"
  defp format_status(x), do: to_string(x)
end
