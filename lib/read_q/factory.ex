defmodule ReadQ.Factory do
  use ExMachina.Ecto, repo: ReadQ.Repo

  def entry_factory do
    %ReadQ.Entry{
      link: sequence(:link, &"http://a#{&1}.com"),
      notes: "some notes",
      tags: ["a", "b", "c"]
    }
  end
end
