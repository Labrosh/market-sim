# market-sim

A small prototype market simulator game made with Godot 4.

You gather and sell wood, manage time and travel between locations, and experiment with simple economic mechanics. The UI is functional and set up with exported variables for flexibility. The goal is to gradually build out a full market simulation loop.

## Features
- Simple day/night cycle with action time costs
- Chop wood, sell in town, sleep to reset
- Travel between forest and town
- Basic price system with future market plans
- In-game log panel for event tracking
- First prototype executable included

## Files
- `main.tscn`, `main.gd`: Primary scene and logic
- `Market.gd`: Handles dynamic wood pricing and market state
- `Sprites/`, `Fonts/`: Assets used in the UI
- `market-sim-prototype.exe`: Prebuilt Windows executable for testing

## Notes
- Built in Godot 4.x
- Code is structured to be easy to read and extend
- UI is WIP — layout and visuals subject to change

## License
MIT
