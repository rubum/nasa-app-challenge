defmodule NasappWeb.MissionComponents do
  use NasappWeb, :html

  @doc """
  Main header for the Mission Control application.
  """
  attr :title, :string, default: "MISSION CONTROL"
  attr :subtitle, :string, default: "NASA Interplanetary Fuel Calculation Subsystem"

  def mission_header(assigns) do
    ~H"""
    <div class="flex-1">
      <div class="flex items-center gap-6 mb-4">
        <div class="p-3.5 bg-white/[0.03] rounded-2xl ring-1 ring-white/10 shadow-xl">
          <.icon name="hero-rocket-launch-solid" class="w-8 h-8 text-white/90" />
        </div>
        <div>
          <h1 class="text-4xl md:text-5xl font-extrabold tracking-tight text-white leading-tight">
            {@title}
          </h1>
        </div>
      </div>
      <p class="text-white/30 font-normal tracking-wide text-sm max-w-xl hidden md:block border-l border-white/10 pl-5 py-1">
        NASA Interplanetary Fuel Calculation Subsystem
      </p>
    </div>
    """
  end

  @doc """
  Integrated console for Mass input and Fuel output.
  """
  attr :form, :any, required: true
  attr :total_fuel, :integer, required: true

  def mission_console(assigns) do
    ~H"""
    <div class="glass-card rounded-[2rem] overflow-hidden border-white/[0.08]">
      <div class="grid grid-cols-1 lg:grid-cols-5 divide-y lg:divide-y-0 lg:divide-x divide-white/[0.05]">
        <!-- Input Section -->
        <div class="p-10 lg:p-12 space-y-8 lg:col-span-3">
          <div class="flex items-center gap-4">
            <div class="w-10 h-10 rounded-xl bg-white/[0.03] flex items-center justify-center ring-1 ring-white/10 shadow-sm">
              <.icon name="hero-cpu-chip-solid" class="w-5 h-5 text-white/40" />
            </div>
            <div>
              <h2 class="font-bold text-xs text-secondary/80 tracking-wider">
                SPACECRAFT MASS
              </h2>
              <p class="text-[10px] font-medium text-white/20 uppercase mt-0.5 tracking-tight">
                System Status: Nominal
              </p>
            </div>
          </div>

          <div class="form-control w-full group">
            <div class="flex items-center justify-between ring-1 ring-white/5 focus-within:ring-white/20 transition-all rounded-2xl overflow-hidden bg-white/[0.02] shadow-inner">
              <div class="flex-1 flex flex-col px-8 py-6">
                <span class="text-[10px] font-bold text-secondary/40 uppercase tracking-widest mb-1.5">
                </span>
                <.input
                  field={@form[:mass]}
                  type="number"
                  placeholder="28801"
                  class="input input-bordered w-full bg-transparent border-none focus:outline-none font-mono text-5xl font-bold p-0 min-h-0 h-auto text-white"
                  phx-debounce="150"
                />
              </div>
              <div class="bg-white/[0.03] self-stretch flex items-center px-10 border-l border-white/[0.05]">
                <span class="font-bold tracking-widest text-sm text-white/40">KG</span>
              </div>
            </div>
            <div
              :if={@form[:mass].errors != []}
              class="mt-4 animate-in fade-in slide-in-from-top-2 duration-200"
            >
              <div class="px-5 py-3 rounded-xl bg-error/5 border border-error/10 text-error text-[11px] font-semibold flex items-center gap-3">
                <.icon name="hero-exclamation-circle-solid" class="w-4 h-4" />
                {render_error(@form[:mass].errors)}
              </div>
            </div>
          </div>
        </div>
        
    <!-- Result Section -->
        <div class="p-10 lg:p-12 bg-white/[0.01] flex flex-col justify-center lg:col-span-2 relative overflow-hidden group/result">
          <div class="relative z-10">
            <div class="text-secondary/40 uppercase tracking-widest text-[10px] font-bold mb-3 flex items-center gap-2">
              <span class="w-3 h-0.5 bg-secondary/30 rounded-full"></span> Total Fuel Required
            </div>
            <div class="flex items-baseline gap-4 mb-8">
              <div class="text-secondary font-mono text-7xl lg:text-8xl font-bold tracking-tighter drop-shadow-[0_0_40px_rgba(255,165,0,0.1)]">
                {format_number(@total_fuel)}
              </div>
              <div class="text-2xl font-bold text-secondary/40 tracking-tighter">
                KG
              </div>
            </div>

            <div class="flex items-center gap-2.5 text-[10px] font-bold text-secondary/50 uppercase tracking-widest bg-secondary/5 px-4 py-2 rounded-lg border border-secondary/10">
              <span class="w-1.5 h-1.5 rounded-full bg-secondary/80 shadow-[0_0_8px_rgba(255,165,0,0.4)]">
              </span>
              Telemetry Sync Active
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mission_stats(assigns) do
    ~H"""
    <div class="glass-card rounded-2xl min-w-[260px] p-6">
      <div class="text-white font-mono text-4xl font-bold tracking-tighter">
        {format_number(@total_fuel)} <span class="text-xl text-white/20">KG</span>
      </div>
    </div>
    """
  end

  @doc """
  Card for spacecraft configuration.
  """
  slot :inner_block, required: true

  def spacecraft_config_card(assigns) do
    ~H"""
    <div class="glass-card rounded-[2rem] overflow-hidden">
      <div class="bg-white/[0.02] px-8 py-5 border-b border-white/[0.05] flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-lg bg-white/[0.03] flex items-center justify-center ring-1 ring-white/10">
            <.icon name="hero-rocket-launch-solid" class="w-4 h-4 text-white/40" />
          </div>
          <div>
            <h2 class="font-bold text-xs text-secondary/80 tracking-wider">
              SPACECRAFT CONFIGURATION
            </h2>
            <p class="text-[10px] font-bold text-white/20 uppercase tracking-tight">Module: PDM-1</p>
          </div>
        </div>
      </div>
      <div class="p-8 lg:p-10">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  Card container for the deployment trajectory.
  """
  attr :on_add, :string, default: "add-step"
  slot :inner_block, required: true

  def trajectory_card(assigns) do
    ~H"""
    <div class="glass-card rounded-[2rem] overflow-hidden border-white/[0.08]">
      <div class="bg-white/[0.02] px-10 py-6 border-b border-white/[0.05] flex items-center justify-between">
        <div class="flex items-center gap-4">
          <div class="w-10 h-10 rounded-xl bg-white/[0.03] flex items-center justify-center ring-1 ring-white/10">
            <.icon name="hero-map-solid" class="w-5 h-5 text-white/50" />
          </div>
          <div>
            <h2 class="font-bold text-xs text-secondary/80 tracking-wider">
              MISSION TRAJECTORY
            </h2>
            <p class="text-[10px] font-medium text-white/20 uppercase mt-0.5 tracking-tight">
              Stage Sequence Configuration
            </p>
          </div>
        </div>
        <button
          type="button"
          phx-click={@on_add}
          class="btn btn-sm px-6 font-bold text-[10px] tracking-[0.1em] uppercase bg-secondary/10 hover:bg-secondary/20 text-secondary border-none rounded-xl transition-all"
          id="add-step-btn"
        >
          <.icon name="hero-plus-solid" class="w-3.5 h-3.5 mr-2 opacity-60" /> Append Stage
        </button>
      </div>
      <div class="card-body p-10 lg:p-12">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  A single row in the trajectory list.
  """
  attr :index, :integer, required: true
  attr :field, :any, required: true
  attr :actions, :list, required: true
  attr :planets, :list, required: true
  attr :on_remove, :string, default: "remove-step"

  def trajectory_stage_row(assigns) do
    ~H"""
    <div class="flex flex-col md:flex-row items-stretch md:items-end gap-10 p-2 group relative">
      <div class="flex items-center gap-6">
        <div class="w-12 h-12 rounded-[1rem] bg-white/[0.02] flex items-center justify-center ring-1 ring-white/10 group-hover:bg-white/[0.04] transition-colors">
          <span class="font-mono font-bold text-sm text-white/40">{@index + 1}</span>
        </div>

        <div class="form-control flex-1 md:w-64">
          <label class="label pt-0 pb-2">
            <span class="label-text text-[10px] font-bold text-secondary/40 uppercase tracking-widest">
              Protocol
            </span>
          </label>
          <select
            name={@field[:action].name}
            class="select select-bordered select-md w-full font-bold text-sm bg-white/[0.02] border-white/5 focus:ring-1 focus:ring-secondary/20 focus:border-secondary/20 rounded-xl tracking-tight text-white/80"
          >
            <%= for action <- @actions do %>
              <option value={action} selected={to_string(action) == to_string(@field[:action].value)}>
                {String.capitalize(to_string(action))}
              </option>
            <% end %>
          </select>
        </div>
      </div>

      <div class="flex-1 flex items-center gap-8">
        <div class="form-control flex-1">
          <label class="label pt-0 pb-2">
            <span class="label-text text-[10px] font-bold text-secondary/40 uppercase tracking-widest">
              Destination
            </span>
          </label>
          <select
            name={@field[:planet].name}
            class="select select-bordered select-md w-full font-bold text-sm bg-white/[0.02] border-white/5 focus:ring-1 focus:ring-secondary/20 focus:border-secondary/20 rounded-xl tracking-tight text-white/80"
          >
            <%= for planet <- @planets do %>
              <option value={planet} selected={planet == @field[:planet].value}>
                {String.capitalize(planet)}
              </option>
            <% end %>
          </select>
        </div>
      </div>

      <div class="flex-none flex justify-end pb-1.5 md:pb-2">
        <button
          type="button"
          phx-click={@on_remove}
          phx-value-index={@index}
          class="w-10 h-10 flex items-center justify-center text-white/10 hover:text-error hover:bg-error/10 rounded-xl transition-all"
          title="Remove Stage"
        >
          <.icon name="hero-x-mark-solid" class="w-5 h-5" />
        </button>
      </div>
      
    <!-- Minimal Divider except for last -->
      <div class="absolute -bottom-5 left-0 w-full h-px bg-white/[0.03] hidden group-last:hidden md:block">
      </div>
    </div>
    """
  end

  @doc """
  Error display for path continuity issues.
  """
  attr :error, :any, required: true

  def trajectory_error_panel(assigns) do
    ~H"""
    <div
      :if={@error != []}
      class="mt-8 p-6 rounded-2xl bg-error/5 border border-error/10 flex gap-4 text-error animate-in fade-in slide-in-from-top-2 duration-200"
    >
      <div class="w-10 h-10 rounded-xl bg-error/10 flex items-center justify-center flex-none">
        <.icon name="hero-shield-exclamation-solid" class="w-5 h-5" />
      </div>
      <div class="flex-1">
        <p class="font-bold text-[10px] uppercase tracking-wider mb-1 opacity-50">
          Trajectory Alert
        </p>
        <p class="text-sm font-semibold tracking-tight">{render_error(@error)}</p>
      </div>
    </div>
    """
  end

  @doc """
  NASA themed footer.
  """
  def mission_footer(assigns) do
    ~H"""
    <footer class="mt-32 pb-16 text-center border-t border-white/[0.03] pt-16 relative overflow-hidden">
      <div class="relative z-10 flex flex-col items-center gap-8">
        <div class="flex items-center gap-12 text-[11px] font-bold uppercase tracking-widest text-secondary/30">
          <span class="hover:text-secondary transition-colors cursor-default">Project Nasapp</span>
          <span class="hover:text-secondary transition-colors cursor-default">
            Mission Registry
          </span>
        </div>
        <div class="flex gap-6 opacity-20">
          <.icon
            name="hero-globe-alt-solid"
            class="w-4 h-4 text-white hover:opacity-100 transition-opacity"
          />
          <.icon
            name="hero-signal-solid"
            class="w-4 h-4 text-white hover:opacity-100 transition-opacity"
          />
          <.icon
            name="hero-cpu-chip-solid"
            class="w-4 h-4 text-white hover:opacity-100 transition-opacity"
          />
        </div>
      </div>
    </footer>
    """
  end

  # Helper for number formatting
  def format_number(n) when is_integer(n) do
    n
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.intersperse(~c",")
    |> List.flatten()
    |> Enum.reverse()
    |> List.to_string()
  end

  def format_number(_), do: "0"

  # Helper for error rendering
  def render_error([]), do: nil
  def render_error([first | _]), do: render_error(first)

  def render_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def render_error(msg) when is_binary(msg), do: msg
end
