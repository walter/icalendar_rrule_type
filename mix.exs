defmodule IcalendarRruleType.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :icalendar_rrule_type,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      name: "ICalendar RRULE Type",
      source_url: "https://github.com/lpil/icalendar_rrule_type",
      description: "An ICalendar RRULE ecto type for use with schemas.",
      package: [
        maintainers: ["Walter McGinnis"],
        licenses: ["MIT"],
        links: %{ "GitHub" => "https://github.com/lpil/icalendar_rrule_type" },
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:icalendar, github: "walter/icalendar", branch: "feature/rrule"}
    ]
  end
end
