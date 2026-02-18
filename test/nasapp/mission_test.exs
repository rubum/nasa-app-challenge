defmodule Nasapp.MissionTest do
  use ExUnit.Case, async: true
  import Ecto.Changeset

  alias Nasapp.Mission
  alias Nasapp.Mission.{Plan, Step}

  describe "validation" do
    test "validates mass is present and positive" do
      changeset = Mission.change_plan(%Plan{}, %{mass: -100})
      refute changeset.valid?
      assert "must be a positive integer" in errors_on(changeset).mass

      changeset = Mission.change_plan(%Plan{}, %{mass: 100})
      assert changeset.valid?
    end

    test "validates steps" do
      changeset =
        Mission.change_plan(%Plan{}, %{
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
        Mission.change_plan(%Plan{}, %{
          mass: 100,
          steps: [
            %{action: :launch, planet: "earth"},
            %{action: :launch, planet: "moon"}
          ]
        })

      refute changeset.valid?
      assert "must follow a landing step" in errors_on(changeset).steps

      # Example: Launch Earth -> Land Moon -> Land Mars (mismatch planet)
      changeset =
        Mission.change_plan(%Plan{}, %{
          mass: 100,
          steps: [
            %{action: :launch, planet: "earth"},
            %{action: :land, planet: "moon"},
            %{action: :land, planet: "mars"}
          ]
        })

      refute changeset.valid?
      assert "must follow a launch step" in errors_on(changeset).steps
    end
  end

  describe "mission planning" do
    test "calculates Apollo 11 Mission fuel correctly" do
      plan = %Plan{
        mass: 28801,
        steps: [
          %Step{action: :launch, planet: "earth"},
          %Step{action: :land, planet: "moon"},
          %Step{action: :launch, planet: "moon"},
          %Step{action: :land, planet: "earth"}
        ]
      }

      assert Mission.calculate_fuel(plan) == 51898
    end

    test "calculates fuel for mission with no steps" do
      plan = %Plan{mass: 100, steps: []}
      assert Mission.calculate_fuel(plan) == 0
    end

    test "allows removing flight path steps" do
      plan = %Plan{
        mass: 100,
        steps: [
          %Step{action: :launch, planet: "earth"},
          %Step{action: :land, planet: "moon"}
        ]
      }

      # Simulate removing the second step (leaving only the launcher)
      params = %{
        "steps" => [%{"action" => "launch", "planet" => "earth"}]
      }

      changeset = Mission.change_plan(plan, params)
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
