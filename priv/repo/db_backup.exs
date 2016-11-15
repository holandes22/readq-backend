alias ReadQ.{Repo, User}
import Ecto, only: [assoc: 2]

{:ok, file} = File.open("/tmp/db.backup", [:write])

for user <- Repo.all User do
  entries = assoc(user, :entries) |> Repo.all

  IO.binwrite file, "---user--- #{user.email}\n"
  for entry <- entries do
    IO.binwrite file, "#{entry.link}:::#{entry.notes || "NULL_V"}:::#{entry.archived}:::#{entry.tags}\n"
  end

end
