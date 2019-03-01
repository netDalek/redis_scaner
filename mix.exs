defmodule RedisScaner.Mixfile do
  use Mix.Project

  @name :redis_scaner
  @version "0.1.0"

  @deps [
    {:eredis_sync, "~> 0.1.2"}
    # { :earmark, ">0.1.5" },                      
    # { :ex_doc,  "1.2.3", only: [ :dev, :test ] }
    # { :my_app:  path: "../my_app" },
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      elixir:  ">= 1.7.4",
      deps:    @deps,
      escript: escript(),
      build_embedded:  in_production,
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def escript() do
    [main_module: RedisScaner.CLI]
  end
end
