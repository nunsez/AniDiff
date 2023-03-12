defmodule Anidiff.MalTest do
  @moduledoc false

  use ExUnit.Case, async: true
  doctest Anidiff.Mal

  alias Anidiff.Mal
  alias Anidiff.TestHelper, as: H

  describe "anime_total/1" do
    test "provides correct value" do
      doc = H.doc("mal/profile.html")
      value = Mal.anime_total(doc)

      assert value === 1042
    end
  end

  describe "manga_total/1" do
    test "provides correct value" do
      doc = H.doc("mal/profile.html")
      value = Mal.manga_total(doc)

      assert value === 542
    end
  end
end
