# Tiberian Sun Client – AutoHotKey Script

An AutoHotKey v2 script for ergonomic automation in the **Tiberian Sun Client**.  

## Overview
The game’s built‑in map scrolling has two options:
- `Arrow` keys → jump a fixed pixel distance in the chosen direction.
- `RButton`+`Drag` → smooth variable scrolling, but hard to maintain a static speed.

This script emulates the `RButton`+`Drag` functionality with the keyboard, giving a consistent and ergonomic control.

&nbsp;

## Features
**Map Scrolling**
- Emulate `RButton`+`Drag` with either `WASD` or `Arrow` keys.
- Toggle scroll speed using `XButton1` / `XButton2` (mouse back/forward buttons).
- Switch between **Modern** `WASD` and **Classic** `Arrow` keys using `ScrollLock`.

**Sidebar Scrolling**
- Default: `WheelUp` / `WheelDown` cycles both **Structure** and **Unit** lists.
- `MButton` cycles between available sidebar modes (independent or simultaneous).

&nbsp;

## Current Bug State
- Map scroll near screen edges does not enforce the selected scroll speed.  
  (cache offset → move cursor → reposition afterwards).

&nbsp;

## Pending Updates
- Add `Resources\clienticon.ico` for **Ahk2Exe** conversions.
- Improve map scrolling behavior when the cursor is near edges.
- Implement map scrolling when the cursor is above the Side or Top bar.

&nbsp;

## Configuration
This script depends on **Keyboard.ini** for hotkey mappings.  
See [Keyboard.md](Keyboard.md) for details on the changes made with `Keyboard.ini`.

&nbsp;

## Notes
- Script is intended for **Scroll Rate 1** in the game client (awaits further testing).
- Designed for ergonomic control without disrupting the gameplay immersion.

**Note on Custom Settings**  
The `Custom Settings` column in [Keyboard.md](Keyboard.md) shows changes made to avoid collisions with `WASD`.  
In Classic mode, `CTRL + KEY` is emulated for direct access, so you retain the original feel.