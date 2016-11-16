alias ReadQ.{Repo, User}
import Ecto, only: [assoc: 2]

Logger.configure(level: :info)

for user <- Repo.all User do
  entries = assoc(user, :entries) |> Repo.all

  IO.puts "---user--- #{user.email}"
  for entry <- entries do
    IO.puts "#{entry.link}|#{entry.notes || "NULL_V"}|#{entry.archived}|#{entry.tags}|"
  end

end
