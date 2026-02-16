# Nasapp - NASA Fuel Calculation Challenge

Nasapp is an Elixir-based utility for calculating the fuel required for interplanetary missions. It uses a recursive model to account for the additional fuel mass needed to carry fuel itself.

## Core Features

- **Recursive Fuel Calculation**: Implements formulas for launch and landing actions across different planets (Earth, Moon, Mars).
- **Mission Planning Context**: Uses `Ecto.Schema` and `Ecto.Changeset` for robust validation of mission data and flight paths.
- **Flight Path Continuity**: Validates logical sequences (e.g., ensuring a launch precedes a landing and planets match up).
- **Extensible Architecture**: Built with Phoenix and LiveView (UI in progress).

## Tech Stack

- **Elixir**: Core logic and concurrency.
- **Phoenix**: Web framework.
- **Ecto**: Schema validation (embedded schemas, no DB required).
- **Tailwind CSS 4.0 & DaisyUI**: Modern UI styling.

## Getting Started

### Prerequisites

- Elixir 1.14+
- Erlang 25+

### Setup

1.  Install dependencies:
    ```bash
    mix deps.get
    ```

2.  Run tests to verify the logic:
    ```bash
    mix test
    ```

3.  Start the Phoenix server:
    ```bash
    mix phx.server
    ```

Visit [`localhost:4000`](http://localhost:4000) to see the application.

## Project Structure

- `lib/nasapp/fuel_calculator.ex`: Core math for fuel calculations.
- `lib/nasapp/mission_planning/`: Domain schemas (`Mission`, `FlightStep`).
- `lib/nasapp/mission_planning.ex`: Public context API for the mission domain.
- `test/nasapp/`: Unit and integration tests for calculation and validation logic.

## Calculation Formula

The fuel for a stage is calculated as:
`floor(mass * gravity * coefficient - constant)`

- **Launch (Earth)**: `mass * 9.807 * 0.042 - 33`
- **Land (Earth)**: `mass * 9.807 * 0.033 - 42`
...and so on for Moon and Mars.

Fuel mass itself also requires fuel recursively until the additional fuel needed is zero or negative.
