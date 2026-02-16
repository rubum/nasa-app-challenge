defmodule Nasapp.MissionPlanning.FlightStep do
  @moduledoc """
  Represents a single step in a flight path.
  A step consists of an action (launch/land) and a target planet.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @available_planets ~w(earth moon mars)
  @available_actions [:launch, :land]

  @primary_key false
  embedded_schema do
    field(:action, Ecto.Enum, values: @available_actions, default: :launch)
    field(:planet, :string, default: "earth")
  end

  @type t :: %__MODULE__{
          action: :launch | :land,
          planet: String.t()
        }

  @doc "Returns the list of supported planets for mission planning."
  @spec available_planets() :: [String.t()]
  def available_planets, do: @available_planets

  @doc "Returns the list of supported actions."
  @spec available_actions() :: [atom()]
  def available_actions, do: @available_actions

  @doc """
  Creates a changeset for a flight path step.
  """
  @spec changeset(t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:action, :planet])
    |> validate_required([:action, :planet])
    |> validate_inclusion(:planet, @available_planets)
  end
end
