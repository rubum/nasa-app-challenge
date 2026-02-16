defmodule NasappWeb.HomeLive do
  use NasappWeb, :live_view
  import NasappWeb.MissionComponents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative isolate overflow-hidden min-h-screen selection:bg-secondary/30">
      <!-- Hero Section -->
      <div class="mx-auto max-w-7xl px-8 pb-24 pt-10 sm:pb-32 lg:grid lg:grid-cols-2 lg:gap-x-16 lg:px-12 lg:py-48 relative z-10 items-center">
        <!-- Hero Content -->
        <div class="mx-auto max-w-2xl lg:mx-0 animate-in fade-in slide-in-from-left-8 duration-700">
          <div class="mt-24 sm:mt-32 lg:mt-0">
            <div class="inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-secondary/5 border border-secondary/10 text-[11px] font-bold tracking-widest text-secondary/60 uppercase">
              <span class="w-2 h-2 rounded-full bg-secondary/80 shadow-[0_0_8px_rgba(255,160,0,0.5)]">
              </span>
              Mission Registry Active
            </div>
          </div>
          <h1 class="mt-10 text-5xl font-extrabold tracking-tight text-white sm:text-7xl leading-[1.1]">
            <span class="text-secondary">Recursive</span>
            <span class="text-white/40">Fuel</span> Calculation
          </h1>
          <p class="mt-8 text-lg leading-relaxed text-white/50 max-w-lg font-medium">
            Professional mission planning utility for calculating precise fuel requirements across multi-stage interplanetary flight paths.
          </p>
          <div class="mt-12 flex items-center gap-x-8">
            <.link
              navigate={~p"/mission"}
              class="px-10 py-5 bg-white text-black font-bold text-sm tracking-wide rounded-2xl hover:bg-white/90 transition-all active:scale-[0.98] shadow-xl"
            >
              Start Mission Planning
            </.link>
            <a
              href="https://github.com/rubum/nasa-app-challenge"
              class="text-xs font-bold leading-6 text-white/40 uppercase tracking-widest hover:text-white transition-colors"
            >
              System Documentation <span aria-hidden="true">→</span>
            </a>
          </div>
        </div>
        
    <!-- Feature Cards -->
        <div class="mt-20 lg:mt-0 animate-in fade-in slide-in-from-right-8 duration-1000 max-w-xl mx-auto lg:max-w-none">
          <div class="grid grid-cols-1 gap-8">
            <!-- Recursive Logic Card -->
            <div class="glass-card p-10 rounded-3xl border-white/[0.08]">
              <div class="w-12 h-12 rounded-2xl bg-secondary/5 flex items-center justify-center mb-8 ring-1 ring-secondary/10">
                <.icon name="hero-variable-solid" class="w-6 h-6 text-secondary/60" />
              </div>
              <h2 class="text-xl font-bold text-white mb-4 tracking-tight">
                <span class="text-secondary/80">Recursive</span> Fuel Logic
              </h2>
              <p class="text-sm leading-relaxed text-white/30 font-medium">
                Accounts for the additional fuel mass required to carry fuel itself across varying gravitational constants.
              </p>
            </div>
            
    <!-- Path Validation Card -->
            <div class="glass-card p-10 rounded-3xl border-white/[0.08]">
              <div class="w-12 h-12 rounded-2xl bg-secondary/5 flex items-center justify-center mb-8 ring-1 ring-secondary/10">
                <.icon name="hero-check-badge-solid" class="w-6 h-6 text-secondary/60" />
              </div>
              <h2 class="text-xl font-bold text-white mb-4 tracking-tight">
                <span class="text-secondary/80">Mission</span> Validation
              </h2>
              <p class="text-sm leading-relaxed text-white/30 font-medium">
                Automated flight path continuity checks ensure every step follows a logical launch and landing sequence.
              </p>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Unified Footer -->
      <.mission_footer />
    </div>
    """
  end
end
