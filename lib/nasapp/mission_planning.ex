defmodule Nasapp.MissionPlanning do
  @moduledoc """
  Public context for mission planning.
  Handles mission changesets and fuel calculation orchestration.
  """
  alias Nasapp.MissionPlanning.Mission
  alias Nasapp.FuelCalculator

  @doc """
  Returns a changeset for tracking mission changes.
  """
  @spec change_mission(Mission.t(), map()) :: Ecto.Changeset.t()
  def change_mission(%Mission{} = mission, attrs \\ %{}) do
    Mission.changeset(mission, attrs)
  end

  @doc """
  Calculates the total fuel required for a valid mission.
  Delegates the core calculation to `FuelCalculator`.
  """
  @spec calculate_mission_fuel(Mission.t()) :: non_neg_integer()
  def calculate_mission_fuel(%Mission{} = mission) do
    path =
      Enum.map(mission.steps, fn step -> {step.action, step.planet} end)

    FuelCalculator.calculate_flight_fuel(mission.mass, path)
  end
end
