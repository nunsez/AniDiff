defmodule Mix.Tasks.Diff do
  @moduledoc false

  use Mix.Task

  alias Anidiff.Comparator

  @requirements ["app.start"]

  @impl Mix.Task
  def run(["anime" | _]) do
    Comparator.anime() |> IO.inspect()
  end

  def run(["manga" | _]) do
    Comparator.manga() |> IO.inspect()
  end
end
