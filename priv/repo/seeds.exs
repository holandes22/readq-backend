# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReadQ.Repo.insert!(%ReadQ.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import ReadQ.Factory
alias ReadQ.Repo

Repo.delete_all(ReadQ.Entry)
Repo.delete_all(ReadQ.User)

user1 = insert(:user)
user2 = insert(:user)

insert(:entry, user: user1)
insert(:entry, user: user1)
insert(:entry, user: user1)
insert(:entry, user: user2)
insert(:entry, user: user2)
