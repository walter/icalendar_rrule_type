defmodule ICalendar.RRULE.Type do
  alias ICalendar.RRULE

  use Timex

  @moduledoc """
  Defines `ICalendar.RRULE.Type` Ecto.Type.
  """

  @behaviour Ecto.Type

  @doc """

  The Ecto primitive type.

  """

  def type, do: :map

  @doc """

  Casts the given value to `ICalendar.RRULE` struct.

  It supports:

    * A map with valid `RRULE` keys in either string or atom form
    * A valid `RRULE` in string form (aka serialized version)
    * An `ICalendar.RRULE` struct.

  All other inputs will return :error

  ## Examples

      iex> Type.cast(%{frequency: :weekly}) == {:ok, %RRULE{frequency: :weekly}}
      true
      iex> Type.cast("FREQ=WEEKLY") == {:ok, %RRULE{frequency: :weekly}}
      true
      iex> Type.cast(%RRULE{frequency: :weekly}) == {:ok, %RRULE{frequency: :weekly}}
      true
      iex> Type.cast(:garbage) == :error
      true
  """
  @spec cast(map | String.t | %RRULE{}) :: {:ok, %RRULE{}}
  def cast(%RRULE{} = rrule) do
    {:ok, rrule}
  end

  def cast(%{} = params) do
    # string keys should match existing atoms since they should match struct keys
    # some pairs also have values that should be atoms from valid options
    params = params_strings_to_atoms(params)

    rrule = struct(RRULE, params)
    {:ok, rrule}
  end

  # assumes serialized icalendar rrule
  def cast(value) when is_bitstring(value) do
    RRULE.deserialize(value)
  end

  def cast(_), do: :error

  @doc """

  Converts an `ICalendar.RRULE` struct into a map saving to the db.

  ## Examples

      iex> Type.dump(%RRULE{frequency: :weekly}) == {:ok, %RRULE{frequency: :weekly}}
      true
      iex> Type.dump(:garbage) == :error
      true
  """
  @spec dump(%RRULE{}) :: {:ok, %RRULE{}}
  def dump(%RRULE{} = rrule) do
    {:ok, rrule}
  end

  def dump(_), do: :error

  @doc """

  Converts a map as saved to the db into a `ICalendar.RRULE` struct.

  ## Examples

      iex> case Type.load(%{"frequency" => "weekly", "until" => "2017-10-31 11:59:00"}) do
      ...> {:ok, %RRULE{}} -> true
      ...> end
      true

  """
  @spec load(map) :: {:ok, %RRULE{}}
  def load(value) do
    params =
      value
      |> params_strings_to_atoms()
      |> load_until()

    rrule = struct(RRULE, params)

    {:ok, rrule}
  end

  defp params_strings_to_atoms(params) do
    # ensure key atoms have been declared
    # Code.ensure_loaded(RRULE) didn't solve problem
    Map.keys(%RRULE{})

    for {k, v} <- params, into: %{} do
      k = if is_binary(k) do
        k |> String.to_existing_atom()
      else
        k
      end

      # WARN: lists values may trip this up
      v = if is_binary(v) and k in [:frequency, :by_day, :by_month, :week_start] do
        v |> String.downcase() |> String.to_atom()
      else
        v
      end

      {k, v}
    end
  end

  defp load_until(%{until: nil} = params), do: params
  defp load_until(%{until: %DateTime{}} = params), do: params
  defp load_until(%{until: until} = params) do
    {:ok, until} = until |> NaiveDateTime.from_iso8601()
    until = until |> Timex.to_datetime("Etc/UTC")

    params |> Map.put(:until, until)
  end
end
