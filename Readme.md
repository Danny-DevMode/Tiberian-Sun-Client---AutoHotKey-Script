# Tiberian Sun Client – AutoHotKey Script

An AutoHotKey v2 script for ergonomic automation in the **Tiberian Sun Client**.  

## Overview
The game’s built‑in map scrolling has two options:
- `Arrow` keys → jump a fixed pixel distance in the chosen direction.
- `RButton`+`Drag` → smooth variable scrolling, but hard to maintain a static speed.

This script emulates the `RButton`+`Drag` functionality with the keyboard, giving a consistent and ergonomic control, while also adding some minor ease-of-use features.

&nbsp;

## Features
**Map Scrolling**
- Emulate `RButton`+`Drag` with either `WASD` or `Arrow` keys.
- Toggle scroll speed using `XButton1` / `XButton2` (mouse back/forward buttons).
- Use `ScrollLock` to switch between Modern and Classic mode.
- **Classic** mode
  - Navigates the map using the `Arrow` keys.
  - Emulates `Ctrl` for map scrolling to prevent the default behavior.
  - Has direct shortcuts for Alliance, Deploy, Sell and Waypoints (no `Ctrl` needed).
- **Modern** mode
  - Navigates the map using the `WASD` keys.
  - Requires `Ctrl` shortcuts for the Alliance, Deploy, Sell and Waypoints.

**Sidebar Scrolling**
- Default: `WheelUp` / `WheelDown` cycles both **Structure** and **Unit** lists.
- `MButton` cycles between available sidebar modes (independent or simultaneous).

&nbsp;

## Current Bug State
- Map scroll near screen edges does not enforce the selected scroll speed.  
  (cache offset → move cursor → reposition afterwards).

&nbsp;

## Pending Updates
- Improve map scrolling behavior when the cursor is near edges.
- Implement map scrolling when the cursor is above the Side or Top bar.

&nbsp;

## Installation
Place both files within the root folder for the game.
- Use `Resources\clienticon.ico` for **Ahk2Exe** conversions.
- This script depends on **Keyboard.ini** for hotkey mappings.  
See [Keyboard.md](Keyboard.md) for details on the changes made with `Keyboard.ini`.
  - The `Custom Settings` column in [Keyboard.md](Keyboard.md) shows changes made to avoid collisions.

&nbsp;

## Notes
- Script is intended for **Scroll Rate 1** in the game client (awaits further testing).
- Designed for ergonomic control without disrupting the gameplay immersion.