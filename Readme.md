# Tiberian Sun Client – AutoHotKey Script

An AutoHotKey v2 script for ergonomic automation in the **Tiberian Sun Client**.  

## Overview
The game’s built‑in map scrolling has two options:
- `Arrow` keys: jump a fixed pixel distance in the chosen direction.
- `RButton`+`Drag`: smooth variable scrolling, but hard to maintain a static speed.

This script emulates the `RButton`+`Drag` functionality with the keyboard, giving a consistent and ergonomic control, while also adding some minor ease-of-use features.

&nbsp;

## Features
**Map Scrolling**
- Emulate `RButton`+`Drag` with either `WASD` or `Arrow` keys.
- Toggle the scroll speed using `XButton1` / `XButton2` (mouse back/forward buttons).
- Use `ScrollLock` to switch between Modern and Classic mode.
- **Classic** mode:
  - Navigates the map using the `Arrow` keys.
  - Emulates `Ctrl` for map scrolling to prevent the default behavior.
  - Has direct shortcuts for Alliance, Deploy, Sell and Waypoints (no `Ctrl` needed).
- **Modern** mode:
  - Navigates the map using the `WASD` keys.
  - Requires `Ctrl` shortcuts for the Alliance, Deploy, Sell and Waypoints.

**Sidebar Scrolling**
- Default: `WheelUp` / `WheelDown` cycles both **Structure** and **Unit** lists.
- `MButton` cycles between available sidebar modes (independent or simultaneous).

&nbsp;

## Current Bug State
- Map scroll near screen edges do not enforce the selected scroll speed.  
  (cache offset → move cursor → reposition afterwards).

&nbsp;

## Pending Updates
- Improve map scrolling behavior when the cursor is near edges.
- Allow map scrolling when the cursor is above the Side/Top bar.

&nbsp;

## Installation
Place the following files in the root folder of the game:
- **Keyboard.ini**: required for the hotkey mappings.  
  - See [Keyboard.md](Keyboard.md) for details on the changes made with `Keyboard.ini`.
- Either the **Executable** or **Script** file:
  - `.ahk` file (requires AutoHotkey).
  - `.exe` file (standalone execution).

The executable uses `clienticon.ico` from the `Resources` folder to give it a native feel.

&nbsp;

## Security
Compiled AutoHotkey executables are **unsigned** by default and Windows SmartScreen flags unsigned or uncommon `.exe` files as a precaution.
- This warning is expected and does not mean the file is unsafe.
  - Click **More info** > **Run anyway** to launch the script.
  - If you compile the `.exe` yourself, it is safe to run.

&nbsp;

## Notes
- Script is intended for **Scroll Rate 1** in the game client (awaits further testing).
- Designed for ergonomic control without disrupting the gameplay immersion.

## Links

- [AutoHotkey](https://www.autohotkey.com/download/)  
  includes the Ahk2Exe by default
- [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe/releases)  
  standalone version
- [Tiberian Sun Client](https://www.moddb.com/mods/tiberian-sun-client)  
  C&C: Tiberian Sun + Firestorm became freeware in 2010