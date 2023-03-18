defmodule Anidiff.MangaEntry do
  @moduledoc false

  defstruct [
    :id,
    :title,
    :status,
    :score,
    :chapters_read,
    :volumes_read,
    :source
  ]

  @type t() :: %__MODULE__{
          id: pos_integer(),
          title: String.t(),
          status: integer(),
          score: integer(),
          chapters_read: non_neg_integer(),
          volumes_read: non_neg_integer(),
          source: :shiki | :mal
        }

  # Mal constructor
  @spec new(map()) :: t()
  def new(%{
        "manga_id" => id,
        "manga_title" => title,
        "status" => status,
        "score" => score,
        "num_read_chapters" => chapters_read,
        "manga_num_volumes" => volumes_read
      })
      when not is_nil(id) do
    %__MODULE__{
      id: id,
      title: title,
      status: format_status(status),
      score: score,
      chapters_read: chapters_read,
      volumes_read: volumes_read,
      source: :mal
    }
  end

  # Shiki constructor
  def new(%{
        "target_id" => id,
        "target_title" => title,
        "status" => status,
        "score" => score,
        "chapters" => chapters_read,
        "volumes" => volumes_read
      })
      when not is_nil(id) do
    %__MODULE__{
      id: id,
      title: title,
      status: status,
      score: score,
      chapters_read: chapters_read,
      volumes_read: volumes_read,
      source: :shiki
    }
  end

  @spec equals?(t(), t()) :: boolean()
  def equals?(a, b) when is_struct(a, __MODULE__) and is_struct(b, __MODULE__) do
    (a.chapters_read == b.chapters_read or a.volumes_read == b.volumes_read) and
      a.status == b.status and
      a.score == b.score
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
