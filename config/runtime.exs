import Config

if config_env() == :prod do
  config :anidiff, :mal_username, System.fetch_env!("MAL_USERNAME")
  config :anidiff, :shiki_username, System.fetch_env!("SHIKI_USERNAME")
end
