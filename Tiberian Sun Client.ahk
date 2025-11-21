#Requires AutoHotkey >=2.0
#SingleInstance

; The game has its own map scrolling funtionality with either the Arrow keys or the RButton + Drag, but both options does not have what i wished for:
; - Arrow keys skips a certain pixel amount in the instructed direction.
; - RButton + Drag is basically what i want, but just using the Keyboard instead.

; By emulation the RButton's map scrolling funtionality with either the [WASD] or [ARROW] keys i would be a happy conqueror, but it has some minor complications.
; - Since the RButton + Drag could move at variable speeds, a toggle for this is implemented using the XButton1 & XButton2. (Mouse back and forth buttons)
; - I do not want to force either the [WASD] or [ARROW] keys, so the ScrollLock switches between Modern and Classic map scrolling.
; - Since the RButton + Drag is depending on the actual game's scroll speed, this script is intended for Scroll Rate 1.

; Current BUG state:
; - Emulating the map scroll near the edges does not enforce the selected scroll speed. (Cache offset, move cursor and reposition it afterwards)

; Pending updates:
; - Map scrolling when the cursor is above the Side or Top bar is not an option with the RButton + Drag approach.
; - Add a notification upon game launch, stating the current map scroll mode. (ScrollLock disables this notification)
; - Scrolling the Sidebar with WheelUp/WheelDown cycles both the Structure and Unit List simultaneously, but the MButton could cycle between the three options available.
;     Structure List Up           Home
;     Structure List Down         End
;     Unit List Up                PageUp
;     Unit List Down              PageDown

; Window References
ClientWindow := "Tiberian Sun Client ahk_exe clientdx.exe"
TitleWindow := "Tiberian Sun ahk_exe game.exe"

; Key Bindings
ModernKeys := Map("Up", "w", "Down", "s", "Left", "a", "Right", "d")
ClassicKeys := Map("Up", "Up", "Down", "Down", "Left", "Left", "Right", "Right")

; State Management
IsEmulating := false
IsGameActive := false
IsClassicMode := GetKeyState("ScrollLock", "T")
PreviousMode := IsClassicMode

; Scroll Speed Settings
ScrollCeil := 12
ScrollFloor := 3
ScrollInitital := 5
ScrollLevel := ScrollInitital
ScrollPixels := 10

; Emergency Exit (CTRL + SHIFT + Q) BlockInput Usage Precaution.
^+q:: ExitApp

; Toggle the Emulated Map Scroll Speed.
#HotIf IsGameActive
XButton1:: SetScrollSpeed(-1)
XButton2:: SetScrollSpeed(1)

; Blocking the Original Scroll Event while Emulating.
#HotIf IsGameActive && IsEmulating
RButton:: return

; Direct Access to Alliance, Deploy, Sell and Waypoints for Classic Mode.
#HotIf IsGameActive && IsClassicMode
w::^w
a::^a
s::^s
d::^d
#HotIf

; Automated Execution || Error Notification
if FileExist("TiberianSun.exe")
  Run "TiberianSun"
else {
  NotFound := Gui("-SysMenu +Owner", "Executable not found !")
  NotFound.Add("Text", , "The script is awaiting the Tiberian Sun Client...")
  NotFound.Add("Text", , "Move this file to the installation folder for an automated execution.")
  NotFound.Add("Text", , "Press (CTRL + SHIFT + Q) to terminate the script.")
  NotFound.Show("Center")
  WinWaitActive(ClientWindow)
  NotFound.Hide()
}

; Awaits the Client Application.
WinWait(ClientWindow)
WinWaitActive(ClientWindow)

; Self-destruct if the Client is Exited early.
while !WinExist(TitleWindow) {
  if !WinExist(ClientWindow)
    ExitApp
  Sleep 1000
}
WinWaitActive(TitleWindow)

; Slowest Speed i set for a Visual Smoothness.
SetDefaultMouseSpeed 100

loop {
  ; Respect the CPU Load and Monitor States.
  Sleep 100
  IsClassicMode := GetKeyState("ScrollLock", "T")
  IsGameActive := WinActive(TitleWindow) ? true : false
  InactiveKeys := 0

  ; Display Mode Changes
  if (IsClassicMode != PreviousMode) {
    PreviousMode := IsClassicMode
    if IsClassicMode
      DisplayToast("Classic Scroll Mode Selected.")
    else
      DisplayToast("Modern Scroll Mode Selected.")
  }

  ; Detect Emulation Requests
  Navigation := IsClassicMode ? ClassicKeys : ModernKeys
  for , Keys in Navigation {

    if IsGameActive && GetKeyState(Keys) && !(!IsClassicMode && GetKeyState("Ctrl")) {

      if !GetKeyState("RButton") {
        WinGetPos(, , &WinWidth)                    ; Get the Width of the Target Window
        MouseGetPos(&xPos, &yPos)                   ; Get Cursor Position ("R" will loop instead)
        if (xPos < WinWidth - 168 && yPos > 16) {   ; Top bar = 16 px && Sidebar = 168 px
          BlockInput "MouseMove"                    ; Disable Cursor Movement
          SendEvent "{RButton down}"                ; Initiate the Emulation Event
          IsEmulating := true
        }
      }

      if IsEmulating {
        ; Disable the Original Scroll Event
        if IsClassicMode
          SendEvent "{Ctrl down}"

        ; Cache Key Bindings
        UP := GetKeyState(Navigation["Up"], "P")
        DOWN := GetKeyState(Navigation["Down"], "P")
        LEFT := GetKeyState(Navigation["Left"], "P")
        RIGHT := GetKeyState(Navigation["Right"], "P")

        ; Handle the Emulated Scroll Event
        if UP && RIGHT
          MouseMove(xPos + ScrollPixels * ScrollLevel, yPos - ScrollPixels * ScrollLevel)
        else if UP && LEFT
          MouseMove(xPos - ScrollPixels * ScrollLevel, yPos - ScrollPixels * ScrollLevel)
        else if DOWN && RIGHT
          MouseMove(xPos + ScrollPixels * ScrollLevel, yPos + ScrollPixels * ScrollLevel)
        else if DOWN && LEFT
          MouseMove(xPos - ScrollPixels * ScrollLevel, yPos + ScrollPixels * ScrollLevel)
        else if UP
          MouseMove(xPos, yPos - ScrollPixels * ScrollLevel)
        else if DOWN
          MouseMove(xPos, yPos + ScrollPixels * ScrollLevel)
        else if LEFT
          MouseMove(xPos - ScrollPixels * ScrollLevel, yPos)
        else if RIGHT
          MouseMove(xPos + ScrollPixels * ScrollLevel, yPos)
      }
    }
    else InactiveKeys++
  }

  ; Reenable the Original Scroll Event.
  if IsEmulating && InactiveKeys = 4 {
    if IsClassicMode
      SendEvent "{Ctrl up}"
    ; Terminate the Emulation Event.
    MouseMove xPos, yPos
    BlockInput "MouseMoveOff"
    SendEvent "{RButton up}"
    IsEmulating := false
  }

} until !(WinExist(TitleWindow) || WinExist(ClientWindow))

; Self-destruct when no longer needed.
ExitApp

; Unable to style Legacy tooltips for Modern Systems. (TitleWindow will ALT + TAB out of the current game with a custom GUI)
DisplayToast(msg) {
  ToolTip msg, 50, 50
  SetTimer ToolTip, -1000
}

; Decreased by 2 to compensate for the lowest available option.
SetScrollSpeed(delta) {
  global ScrollCeil, ScrollInitital, ScrollFloor, ScrollLevel
  ScrollLevel := Max(ScrollFloor, Min(ScrollCeil, ScrollLevel + delta))
  IsDefault := ScrollLevel = ScrollInitital ? " (default)" : ""
  DisplayToast("Scroll Speed " . ScrollLevel - 2 . IsDefault)
}
