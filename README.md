# ICalendar RRULE Type

This adds an Ecto custom type for RRULE for use in your schemas.

## Usage

```Elixir

  # for a single RRULE
  schema "somethings" do
    field :rrule, ICalendar.RRULE.Type
    ...
  end

  # or when allowing for multiple rrules
  schema "somethings" do
    field :rrules, {:array, ICalendar.RRULE.Type}, default: []
    ...
  end

```

## WARNING

This is a pre-release work-in-progress that has a dependency on an
unmerged walter/icalendar:feature/rrule branch version of
icalendar. Use at your own risk.

## Installation

The package can be installed by adding `icalendar_rrule_type` to your
list of dependencies in `mix.exs` via github:

```elixir
def deps do
  [
    {:icalendar_rrule_type, github: "walter/icalendar_rrule_type"}
  ]
end
```
