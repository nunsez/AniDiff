defmodule Mix.Tasks.Diff do
  @moduledoc false

  use Mix.Task

  @requirements ["app.start"]

  @impl Mix.Task
  def run(args) do
    Mix.shell().info(Enum.join(args, " "))
  end
end
