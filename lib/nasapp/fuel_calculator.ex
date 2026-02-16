defmodule Nasapp.FuelCalculator do
  @moduledoc """
  Calculates fuel requirements for interplanetary travel based on mass, gravity, and launch/land actions.
  Uses a simplified model of the Tsiolkovsky rocket equation.
  """

  # Gravity constants for supported planets (m/s^2)
  @gravities %{
    "earth" => 9.807,
    "moon" => 1.62,
    "mars" => 3.711
  }

  # Formula Coefficients
  @launch_factor 0.042
  @launch_base_cost 33
  @land_factor 0.033
  @land_base_cost 42

  @type action :: :launch | :land
  @type planet :: String.t()
  @type path_step :: {action(), planet()}
  @type path :: [path_step()]
  @type mass :: non_neg_integer()

  @doc """
  Calculates the total fuel required for a given spacecraft mass and flight path.

  The path is processed in reverse order because fuel required for later stages must be carried
  as additional mass during earlier stages.

  ## Examples

      iex> Nasapp.FuelCalculator.calculate_flight_fuel(28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}])
      51898

  """
  @spec calculate_flight_fuel(mass(), path()) :: non_neg_integer()
  def calculate_flight_fuel(mass, path) when is_integer(mass) and mass >= 0 do
    path
    |> Enum.reverse()
    |> Enum.reduce(0, fn {action, planet}, accumulated_fuel ->
      gravity = get_gravity(planet)

      # The mass for the current stage includes the spacecraft mass plus fuel needed for subsequent stages
      current_mass = mass + accumulated_fuel
      fuel = calculate_fuel(current_mass, gravity, action)

      accumulated_fuel + fuel
    end)
  end

  @doc """
  Calculates the fuel required for a single stage, accounting for the additional fuel needed
  to carry the fuel itself (recursive calculation).

  ## Examples

      iex> Nasapp.FuelCalculator.calculate_fuel(28801, 9.807, :land)
      13447
  """
  @spec calculate_fuel(mass(), float(), action()) :: non_neg_integer()
  def calculate_fuel(mass, gravity, action) do
    initial_fuel = apply_formula(mass, gravity, action)
    calculate_additional_fuel(initial_fuel, gravity, action)
  end

  # ---------------------------------------------------------------------------
  # Private helper functions
  # ---------------------------------------------------------------------------

  # Recursively calculates additional fuel needed to carry fuel mass
  defp calculate_additional_fuel(fuel, _gravity, _action) when fuel <= 0, do: 0

  defp calculate_additional_fuel(fuel, gravity, action) do
    additional_fuel = apply_formula(fuel, gravity, action)
    fuel + calculate_additional_fuel(additional_fuel, gravity, action)
  end

  # Core formula implementation
  defp apply_formula(mass, gravity, :launch) do
    floor(mass * gravity * @launch_factor - @launch_base_cost)
  end

  defp apply_formula(mass, gravity, :land) do
    floor(mass * gravity * @land_factor - @land_base_cost)
  end

  defp get_gravity(planet) do
    Map.get(@gravities, String.downcase(planet)) ||
      raise ArgumentError, "Unknown planet: #{planet}"
  end
end
