import Config

config_env_path = Path.expand("./#{config_env()}.exs", __DIR__)

if File.exists?(config_env_path) do
  import_config(config_env_path)
end
