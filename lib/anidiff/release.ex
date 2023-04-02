defmodule Anidiff.Release do
  @moduledoc false

  alias Anidiff.Comparator

  @app :anidiff

  @spec diff_anime() :: any()
  def diff_anime do
    start_app()

    Comparator.anime()
    |> report()
  end

  @spec diff_manga() :: any()
  def diff_manga do
    start_app()

    Comparator.manga()
    |> report()
  end

  @spec start_app() :: :ok | {:error, any()}
  defp start_app do
    Application.ensure_all_started(@app)
  end

  @spec report(any()) :: any()
  # credo:disable-for-next-line Credo.Check.Warning.IoInspect
  defp report(data), do: IO.inspect(data)
end
