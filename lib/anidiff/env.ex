defmodule Anidiff.Env do
  @moduledoc false

  @spec mal_username() :: String.t()
  def mal_username do
    fetch_env!(:mal_username)
  end

  @spec shiki_username() :: String.t()
  def shiki_username do
    fetch_env!(:shiki_username)
  end

  @spec fetch_env!(atom()) :: any()
  def fetch_env!(value) do
    __MODULE__
    |> Application.get_application()
    |> Application.fetch_env!(value)
  end
end
