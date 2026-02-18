defmodule Nasapp.Mission do
  @moduledoc """
  Public context for mission domain.
  Handles mission plan changesets and fuel calculation orchestration.
  """
  alias Nasapp.Mission.Plan
  alias Nasapp.FuelCalculator

  @doc """
  Returns a changeset for tracking plan changes.
  """
  @spec change_plan(Plan.t(), map()) :: Ecto.Changeset.t()
  def change_plan(%Plan{} = plan, attrs \\ %{}) do
    Plan.changeset(plan, attrs)
  end

  @doc """
  Calculates the total fuel required for a valid mission plan.
  Delegates the core calculation to `FuelCalculator`.
  """
  @spec calculate_fuel(Plan.t()) :: non_neg_integer()
  def calculate_fuel(%Plan{} = plan) do
    path =
      Enum.map(plan.steps, fn step -> {step.action, step.planet} end)

    FuelCalculator.calculate_flight_fuel(plan.mass, path)
  end
end
