defmodule Nasapp.FuelCalculatorTest do
  use ExUnit.Case, async: true
  alias Nasapp.FuelCalculator

  describe "formula calculation" do
    test "Apollo 11 landing on Earth" do
      # Formula check: 28801 * 9.807 * 0.033 - 42 = 9278
      # 9278 + 2960 + 915 + 254 + 40 = 13447
      assert FuelCalculator.calculate_fuel(28801, 9.807, :land) == 13447
    end
  end

  describe "mission scenarios" do
    test "Apollo 11 Mission" do
      mass = 28801

      path = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "earth"}
      ]

      assert FuelCalculator.calculate_flight_fuel(mass, path) == 51898
    end

    test "Mars Mission" do
      mass = 14606

      path = [
        {:launch, "earth"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculator.calculate_flight_fuel(mass, path) == 33388
    end

    test "Passenger Ship Mission" do
      mass = 75432

      path = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculator.calculate_flight_fuel(mass, path) == 212_161
    end
  end
end
