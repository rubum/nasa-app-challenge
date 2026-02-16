defmodule Nasapp.MissionPlanning.Mission do
  @moduledoc """
  Represents a mission plan containing the spacecraft mass and the complete flight path.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Nasapp.MissionPlanning.FlightStep

  embedded_schema do
    field(:mass, :integer)
    embeds_many(:steps, FlightStep, on_replace: :delete)
  end

  @type t :: %__MODULE__{
          mass: non_neg_integer() | nil,
          steps: [FlightStep.t()]
        }

  @doc """
  Creates a changeset for a mission, validating mass and casting nested steps.
  """
  @spec changeset(t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset(mission, attrs) do
    mission
    |> cast(attrs, [:mass])
    |> validate_required([:mass])
    |> validate_number(:mass, greater_than_or_equal_to: 0, message: "must be a positive integer")
    |> cast_embed(:steps)
    |> validate_continuity()
  end

  defp validate_continuity(changeset) do
    steps = get_field(changeset, :steps) || []

    case check_steps(steps) do
      :ok -> changeset
      {:error, message} -> add_error(changeset, :steps, message)
    end
  end

  defp check_steps([]), do: :ok

  defp check_steps(steps) do
    steps
    |> Enum.reduce_while({nil, nil}, fn step, {prev_action, prev_planet} ->
      case {prev_action, step.action} do
        {nil, :land} ->
          {:halt, {:error, "first step must be a launch"}}

        {:launch, :launch} ->
          {:halt, {:error, "must follow a landing"}}

        {:land, :land} ->
          {:halt, {:error, "must follow a launch"}}

        {:launch, :land} when step.planet != prev_planet ->
          {:halt, {:error, "landing planet must match previous launch"}}

        _ ->
          {:cont, {step.action, step.planet}}
      end
    end)
    |> case do
      {:error, _} = err -> err
      _ -> :ok
    end
  end
end
