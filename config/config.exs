import Config

if Mix.env() == :test do
  config :scrivener_list, Scrivener.Repo, adapter: Ecto.Adapters.Postgres
end
