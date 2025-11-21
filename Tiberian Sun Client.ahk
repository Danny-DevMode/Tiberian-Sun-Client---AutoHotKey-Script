#Requires AutoHotkey >=2.0
#SingleInstance

; Emulate the RButton's map scrolling funtionality with either [WASD] or [ARROW] the keys.
; - XButton1 & XButton2 alter the speed factor for the map scrolling.
; - ScrollLock switches between Modern and Classic map scrolling.
; - The initial scroll speed is currently intended for Scroll Rate 1.

; Potential upgrades
; - Allow scrolling when cursor is above sidebar or topbar
; - Add a notification upon game launch (ScrollLock disables it)
; - Add a WheelUp/WheelDown toggle for the Sidebar scroll with MButton
; - - Structure List Up           Home
; - - Structure List Down         End
; - - Unit List Up                PageUp
; - - Unit List Down              PageDown

test := GetKeyState('MButton')

ClientWindow := "Tiberian Sun Client ahk_exe clientdx.exe"
TitleWindow := "Tiberian Sun ahk_exe game.exe"
ModernKeys := Map("Up", "w", "Down", "s", "Left", "a", "Right", "d")
ClassicKeys := Map("Up", "Up", "Down", "Down", "Left", "Left", "Right", "Right")
IsEmulating := false
IsGameActive := false
IsClassicMode := GetKeyState("ScrollLock", "T")
PreviousMode := IsClassicMode
ScrollCeil := 12
ScrollFloor := 3
ScrollInitital := 5
ScrollLevel := ScrollInitital
ScrollPixels := 10

; Emergency Exit (CTRL + SHIFT + Q) BlockInput Usage Precaution
^+q:: ExitApp

#HotIf IsGameActive
XButton1:: SetScrollSpeed(-1)
XButton2:: SetScrollSpeed(1)
; Blocking the Original Scroll Event while Emulating
#HotIf IsGameActive && IsEmulating
RButton:: return
; Direct Access to Alliance, Deploy, Sell and Waypoints for Classic Mode
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

; Await the Client Application
WinWait(ClientWindow)
WinWaitActive(ClientWindow)
; Self-destruct if the Client Exits
while !WinExist(TitleWindow) {
  if !WinExist(ClientWindow)
    ExitApp
  Sleep 1000
}
WinWaitActive(TitleWindow)

; Slowest Speed i set for a Visual Smoothness
SetDefaultMouseSpeed 100

loop {
  ; Respect the CPU Load and Monitor States
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

  if IsEmulating && InactiveKeys = 4 {
    ; Reenable the Original Scroll Event
    if IsClassicMode
      SendEvent "{Ctrl up}"
    ; Terminate the Emulation Event
    MouseMove xPos, yPos
    BlockInput "MouseMoveOff"
    SendEvent "{RButton up}"
    IsEmulating := false
  }

} until !(WinExist(TitleWindow) || WinExist(ClientWindow))

; Self-destruct when no longer needed.
ExitApp

; Unable to style Legacy tooltips for Modern Systems.
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
