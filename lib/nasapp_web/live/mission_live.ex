defmodule NasappWeb.MissionLive do
  use NasappWeb, :live_view

  alias Nasapp.Mission
  alias Nasapp.Mission.{Plan, Step}

  import NasappWeb.MissionComponents

  @impl true
  def mount(_params, _session, socket) do
    plan = %Plan{steps: [%Step{}]}
    changeset = Mission.change_plan(plan)

    {:ok,
     socket
     |> assign(plan: plan)
     |> assign(form: to_form(changeset))
     |> assign(total_fuel: 0)
     |> assign(planets: Step.available_planets())
     |> assign(actions: Step.available_actions())}
  end

  @impl true
  def handle_event("validate", %{"plan" => params}, socket) do
    changeset =
      socket.assigns.plan
      |> Mission.change_plan(params)
      |> Map.put(:action, :validate)

    total_fuel =
      if changeset.valid? do
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Mission.calculate_fuel()
      else
        socket.assigns.total_fuel
      end

    {:noreply, assign(socket, form: to_form(changeset), total_fuel: total_fuel)}
  end

  @impl true
  def handle_event("add-step", _params, socket) do
    # Get current steps from the form's source
    current_steps = get_steps(socket.assigns.form.source)

    # Use actual current steps to find the next index and maintain sync
    params = socket.assigns.form.params || %{}
    existing_steps_params = Map.get(params, "steps", %{})

    # Ensure all existing steps have placeholders in params before adding new one
    # This prevents Ecto from pruning steps that aren't in the params map
    new_index = length(current_steps)

    updated_steps_params =
      0..new_index
      |> Enum.map(&to_string/1)
      |> Enum.reduce(existing_steps_params, fn idx, acc ->
        Map.put_new(acc, idx, %{})
      end)

    updated_params = Map.put(params, "steps", updated_steps_params)

    # Add to struct as well for immediate calculation if valid
    new_step = %Step{action: :launch, planet: "earth"}
    updated_struct_steps = current_steps ++ [new_step]
    plan = %{socket.assigns.plan | steps: updated_struct_steps}

    changeset =
      plan
      |> Mission.change_plan(updated_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, plan: plan, form: to_form(changeset))}
  end

  @impl true
  def handle_event("remove-step", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)

    # Get current steps from the struct
    current_steps = get_steps(socket.assigns.form.source)
    updated_steps = List.delete_at(current_steps, index)
    plan = %{socket.assigns.plan | steps: updated_steps}

    # Remove the step from params as well to keep the UI in sync
    params = socket.assigns.form.params || %{}

    updated_params =
      if steps_params = params["steps"] do
        # We need to re-index the steps params after deletion to satisfy Ecto's expectations
        new_steps_params =
          steps_params
          |> Map.delete(to_string(index))
          |> Map.values()
          |> Enum.with_index()
          |> Map.new(fn {val, i} -> {to_string(i), val} end)

        Map.put(params, "steps", new_steps_params)
      else
        params
      end

    changeset =
      plan
      |> Mission.change_plan(updated_params)
      |> Map.put(:action, :validate)

    total_fuel =
      if changeset.valid?,
        do: Mission.calculate_fuel(Ecto.Changeset.apply_changes(changeset)),
        else: socket.assigns.total_fuel

    {:noreply, assign(socket, plan: plan, form: to_form(changeset), total_fuel: total_fuel)}
  end

  defp get_steps(changeset) do
    Ecto.Changeset.get_field(changeset, :steps) || []
  end
end
