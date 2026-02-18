# Nasapp - NASA Fuel Calculation Challenge

Nasapp is a high-fidelity Elixir-based mission control utility designed to calculate precise fuel requirements for interplanetary missions. It solves the NASA Fuel Calculation Challenge using a recursive mass-propulsion model and a premium, real-time web interface.

## Core Features

- **Recursive Fuel Calculation**: Accounts for the mass of the fuel itself across multiple stages, processing trajectories in reverse order for mathematical accuracy.
- **Mission Control Dashboard**: A modern, minimalistic LiveView interface featuring real-time telemetry updates and dynamic trajectory building.
- **Flight Path Validation**: Real-time "Trajectory Alerts" ensure logical consistency (e.g., every launch must originate from the planet where the ship last landed).
- **Embedded Schema Validation**: Uses `Ecto` and `to_form/1` for robust state management without the overhead of a database.
- **NASA Aesthetic**: Sleek, high-contrast design using **Inter**, **IBM Plex Mono**, and glassmorphism.

## Tech Stack

- **Elixir**: Core logic and recursive calculation engine.
- **Phoenix & LiveView**: Concurrent, real-time interactive dashboard.
- **Tailwind CSS 4.0 & DaisyUI**: Personalized "NASA" dark theme and responsive layout.
- **Gettext**: I18n support for error messaging.

## Getting Started

### Prerequisites

- Elixir 1.14+
- Erlang 25+

### Setup

1.  **Install dependencies**:
    ```bash
    mix deps.get
    ```

2.  **Verify the system**:
    ```bash
    mix test
    ```
    *All 20 tests (Unit, Component, Controller) should pass.*

3.  **Launch Mission Control**:
    ```bash
    mix phx.server
    ```

Visit [`localhost:4000`](http://localhost:4000) to access the Mission Registry.

## Project Structure

- `lib/nasapp/fuel_calculator.ex`: The recursive propulsion math engine.
- `lib/nasapp/mission/`: Domain schemas (`Plan`, `Step`).
- `lib/nasapp_web/live/mission_live.ex`: The interactive mission control dashboard.
- `lib/nasapp_web/components/mission_components.ex`: Reusable UI components (Headers, Consoles, Alerts).
- `test/nasapp_web/components/`: Comprehensive functional component tests.

## Calculation Protocol

The fuel for any single stage is calculated using:
`floor(mass * gravity * coefficient - constant)`

- **Launch**: `mass * gravity * 0.042 - 33`
- **Land**: `mass * gravity * 0.033 - 42`

Recursive computation continues until the additional fuel needed for the fuel itself is zero or negative.
