defmodule Sonar.Mixfile do
  use Mix.Project

  def project do
    [app: :sonar,
     version: "0.0.9",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Sonar, []},
     extra_applications: [:logger, :erlport]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.7"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.12"},
     {:cowboy, "~> 1.0"},
     {:money, "~> 1.2"},
     {:facebook, "~> 0.12"},
     {:tzdata, "0.5.11"},
     {:timex, "~> 3.1"},
     {:timex_ecto, "~> 3.0"},
     {:export, "~> 0.1"},
     {:comeonin, "~> 3.0"},
     {:ueberauth, "~> 0.4"},
     {:ueberauth_identity, "~> 0.2"},
     {:ueberauth_facebook, "~> 0.5"},
     {:cors_plug, "~> 1.1"},
     {:edeliver, "~> 1.4"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
