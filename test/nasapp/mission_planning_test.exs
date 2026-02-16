defmodule Nasapp.MissionPlanningTest do
  use ExUnit.Case, async: true
  import Ecto.Changeset

  alias Nasapp.MissionPlanning
  alias Nasapp.MissionPlanning.{Mission, FlightStep}

  describe "validation" do
    test "validates mass is present and positive" do
      changeset = MissionPlanning.change_mission(%Mission{}, %{mass: -100})
      refute changeset.valid?
      assert "must be a positive integer" in errors_on(changeset).mass

      changeset = MissionPlanning.change_mission(%Mission{}, %{mass: 100})
      assert changeset.valid?
    end

    test "validates steps" do
      changeset =
        MissionPlanning.change_mission(%Mission{}, %{
          mass: 100,
          steps: [
            # Invalid action and planet
            %{action: :fly, planet: "pluto"},
            # Valid
            %{action: :launch, planet: "mars"}
          ]
        })

      refute changeset.valid?

      [step1, _step2] = changeset.changes.steps
      refute step1.valid?
      assert "is invalid" in errors_on(step1).action
      assert "is invalid" in errors_on(step1).planet
    end

    test "validates path continuity" do
      # Example: Launch Earth -> Launch Moon (missing landing)
      changeset =
        MissionPlanning.change_mission(%Mission{}, %{
          mass: 100,
          steps: [
            %{action: :launch, planet: "earth"},
            %{action: :launch, planet: "moon"}
          ]
        })

      refute changeset.valid?
      assert "must follow a landing" in errors_on(changeset).steps

      # Example: Launch Earth -> Land Moon -> Land Mars (mismatch planet)
      changeset =
        MissionPlanning.change_mission(%Mission{}, %{
          mass: 100,
          steps: [
            %{action: :launch, planet: "earth"},
            %{action: :land, planet: "moon"},
            %{action: :land, planet: "mars"}
          ]
        })

      refute changeset.valid?
      assert "landing planet must match previous launch" in errors_on(changeset).steps
    end
  end

  describe "mission planning" do
    test "calculates Apollo 11 Mission fuel correctly" do
      mission = %Mission{
        mass: 28801,
        steps: [
          %FlightStep{action: :launch, planet: "earth"},
          %FlightStep{action: :land, planet: "moon"},
          %FlightStep{action: :launch, planet: "moon"},
          %FlightStep{action: :land, planet: "earth"}
        ]
      }

      assert MissionPlanning.calculate_mission_fuel(mission) == 51898
    end

    test "calculates fuel for mission with no steps" do
      mission = %Mission{mass: 100, steps: []}
      assert MissionPlanning.calculate_mission_fuel(mission) == 0
    end

    test "allows removing flight path steps" do
      mission = %Mission{
        mass: 100,
        steps: [
          %FlightStep{action: :launch, planet: "earth"},
          %FlightStep{action: :land, planet: "moon"}
        ]
      }

      # Simulate removing the second step (leaving only the launcher)
      params = %{
        "steps" => [%{"action" => "launch", "planet" => "earth"}]
      }

      changeset = MissionPlanning.change_mission(mission, params)
      steps = get_field(changeset, :steps)
      [step] = steps

      assert changeset.valid?
      assert length(steps) == 1
      assert step.action == :launch
    end
  end

  # Helper for error messages
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
