defmodule ChatService.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      include_erts: true,  # Включаем ERTS в релиз
      include_executables_for: [:unix],  # Включаем исполняемые файлы для Unix
      steps: [:assemble, :tar], #
      deps: deps(),
      releases: [
        rel_v1: [
          applications: [
            service: :permanent,
            db: :permanent,
            pub_sub: :permanent,
            server: :permanent
          ],
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end
end
