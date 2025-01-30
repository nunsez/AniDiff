defmodule Anidiff.Release do
  @moduledoc false

  alias Anidiff.Comparator

  @app :anidiff

  def main(args \\ []) do
    System.no_halt(true)

    case args do
      ["anime" | _] ->
        diff_anime()

      ["manga" | _] ->
        diff_manga()

      [] ->
        diff_anime()
        diff_manga()

      _ ->
        IO.puts("Available arguments: anime, manga or no arg")
    end

    System.stop(0)
  end

  @spec diff_anime() :: any()
  def diff_anime do
    start_app()

    report(Comparator.anime())
  end

  @spec diff_manga() :: any()
  def diff_manga do
    start_app()

    report(Comparator.manga())
  end

  @spec start_app() :: :ok | {:error, any()}
  defp start_app do
    Application.ensure_all_started(@app)
  end

  @spec report(any()) :: any()
  # credo:disable-for-next-line Credo.Check.Warning.IoInspect
  defp report(data), do: IO.inspect(data)
end
