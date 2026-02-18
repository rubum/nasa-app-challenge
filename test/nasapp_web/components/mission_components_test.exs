defmodule NasappWeb.MissionComponentsTest do
  use NasappWeb.ConnCase, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import NasappWeb.MissionComponents

  alias Nasapp.Mission.{Plan, Step}

  describe "mission_header/1" do
    test "renders default header" do
      assigns = %{}
      html = render_component(&mission_header/1, assigns)
      assert html =~ "MISSION CONTROL"
      assert html =~ "NASA Interplanetary Fuel Calculation Subsystem"
    end

    test "renders custom title" do
      assigns = %{title: "APOLLO 11"}
      html = render_component(&mission_header/1, assigns)
      assert html =~ "APOLLO 11"
    end
  end

  describe "mission_console/1" do
    test "renders mass input and fuel output" do
      plan = %Plan{mass: 1000}
      changeset = Plan.changeset(plan, %{})
      form = to_form(changeset)

      assigns = %{form: form, total_fuel: 500}
      html = render_component(&mission_console/1, assigns)

      assert html =~ "SPACECRAFT MASS"
      assert html =~ "Total Fuel Required"
      assert html =~ "500"
      assert html =~ "KG"
    end

    test "renders mass errors" do
      plan = %Plan{}
      changeset = Plan.changeset(plan, %{mass: -10})
      form = to_form(Map.put(changeset, :action, :validate))

      assigns = %{form: form, total_fuel: 0}
      html = render_component(&mission_console/1, assigns)

      assert html =~ "must be a positive integer"
    end
  end

  describe "mission_stats/1" do
    test "renders formatted fuel value" do
      assigns = %{total_fuel: 1_234_567}
      html = render_component(&mission_stats/1, assigns)
      assert html =~ "1,234,567"
      assert html =~ "KG"
    end
  end

  describe "trajectory_card/1" do
    test "renders with inner block" do
      assigns = %{
        inner_block: [
          %{
            __slot__: :inner_block,
            inner_block: fn _, _ -> "Trajectory Content" end
          }
        ]
      }

      html = render_component(&trajectory_card/1, assigns)

      assert html =~ "MISSION TRAJECTORY"
      assert html =~ "Append Stage"
      assert html =~ "Trajectory Content"
    end
  end

  describe "trajectory_stage_row/1" do
    test "renders select inputs for index 0" do
      step = %Step{action: :launch, planet: "earth"}
      changeset = Step.changeset(step, %{})
      step_field = to_form(changeset)

      assigns = %{
        index: 0,
        field: step_field,
        actions: [:launch, :land],
        planets: ["earth", "moon"]
      }

      html = render_component(&trajectory_stage_row/1, assigns)

      # Counter starts at index + 1
      assert html =~ "1"
      assert html =~ "Protocol"
      assert html =~ "Destination"
      assert html =~ "Launch"
      assert html =~ "Earth"
    end
  end

  describe "trajectory_error_panel/1" do
    test "renders when error is present" do
      assigns = %{error: ["Some error occurred"]}
      html = render_component(&trajectory_error_panel/1, assigns)
      assert html =~ "Trajectory Alert"
      assert html =~ "Some error occurred"
    end

    test "does not render when error list is empty" do
      assigns = %{error: []}
      html = render_component(&trajectory_error_panel/1, assigns)
      refute html =~ "Trajectory Alert"
    end
  end
end
