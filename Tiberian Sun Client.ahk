#Requires AutoHotkey >=2.0
#SingleInstance

; Save := IniWrite(true, "settings.ini", "UI", "theme")
; Load := IniRead("settings.ini", "UI", "theme", "false")
; ^ true returns "True"
; ^ false returns "False"
; [UI]
; theme=true

ClientWindow := "Tiberian Sun Client ahk_exe clientdx.exe"
TitleWindow := "Tiberian Sun ahk_exe game.exe"
ModernKeys := Map("Up", "w", "Down", "s", "Left", "a", "Right", "d")
ClassicKeys := Map("Up", "Up", "Down", "Down", "Left", "Left", "Right", "Right")
IsEmulating := false
IsGameActive := false
IsClassicMode := GetKeyState("ScrollLock", "T")
IsCurrentMode := IsClassicMode
InitialScrollSpeed := 5
CurrentScrollSpeed := InitialScrollSpeed
MapScrollPixelStep := 10
SidebarOptionIndex := 1

; BlockInput precaution (CTRL + SHIFT + F4)
^+F4:: ExitApp

#HotIf IsGameActive
XButton1:: ToggleScrollSpeed(-1)
XButton2:: ToggleScrollSpeed(1)
MButton:: ToggleSidebarScroll()

; WheelUp/WheelDown does not have a release event.
#HotIf IsGameActive && SidebarOptionIndex = 2
WheelUp:: Send "{Home}"
WheelDown:: Send "{End}"
#HotIf IsGameActive && SidebarOptionIndex = 3
WheelUp:: Send "{PgUp}"
WheelDown:: Send "{PgDn}"

; Disable the original RButton event while emulating.
#HotIf IsGameActive && IsEmulating
RButton:: return

; Classic Mode Shortcuts for Alliance, Deploy, Sell and Waypoints.
#HotIf IsGameActive && IsClassicMode
w::^w
a::^a
s::^s
d::^d
#HotIf

; Automated Execution || Error Notification
if FileExist("TiberianSun.exe") {
  Run "TiberianSun"
  WinWait(ClientWindow)
  WinWaitActive(ClientWindow)
}
else {
  NotFound := Gui("-SysMenu +Owner", "Executable not found !")
  NotFound.Add("Text", , "The script is awaiting the Tiberian Sun Client...")
  NotFound.Add("Text", , "Move this file to the installation folder for an automated execution.")
  NotFound.Add("Text", , "Press (CTRL + SHIFT + F4) to terminate the script.")
  NotFound.Show("Center")
  WinWait(ClientWindow)
  WinWaitActive(ClientWindow)
  NotFound.Hide()
}

; Self-destruct if the Client is closed without starting the Title.
while !WinExist(TitleWindow) {
  if !WinExist(ClientWindow)
    ExitApp
  Sleep 1000
}
WinWaitActive(TitleWindow)

; Slowest speed is set for a visual smoothness.
SetDefaultMouseSpeed 100

loop {
  Sleep 100
  IsClassicMode := GetKeyState("ScrollLock", "T")
  IsGameActive := WinActive(TitleWindow) ? true : false
  InactiveKeys := 0

  if IsGameActive {

    if (IsClassicMode != IsCurrentMode) {
      IsCurrentMode := IsClassicMode
      ShowTooltip(IsClassicMode ? "Classic" : "Modern" . " Map Scroll Enabled.")
    }

    MapScrollNavigation := IsClassicMode ? ClassicKeys : ModernKeys
    for , Keys in MapScrollNavigation {

      if GetKeyState(Keys) && !(!IsClassicMode && GetKeyState("Ctrl")) {

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

          ; Prevent the original arrow event.
          if IsClassicMode
            SendEvent "{Ctrl down}"

          UP := GetKeyState(MapScrollNavigation["Up"], "P")
          DOWN := GetKeyState(MapScrollNavigation["Down"], "P")
          LEFT := GetKeyState(MapScrollNavigation["Left"], "P")
          RIGHT := GetKeyState(MapScrollNavigation["Right"], "P")

          if UP && RIGHT
            MouseMove(xPos + MapScrollPixelStep * CurrentScrollSpeed, yPos - MapScrollPixelStep * CurrentScrollSpeed)
          else if UP && LEFT
            MouseMove(xPos - MapScrollPixelStep * CurrentScrollSpeed, yPos - MapScrollPixelStep * CurrentScrollSpeed)
          else if DOWN && RIGHT
            MouseMove(xPos + MapScrollPixelStep * CurrentScrollSpeed, yPos + MapScrollPixelStep * CurrentScrollSpeed)
          else if DOWN && LEFT
            MouseMove(xPos - MapScrollPixelStep * CurrentScrollSpeed, yPos + MapScrollPixelStep * CurrentScrollSpeed)
          else if UP
            MouseMove(xPos, yPos - MapScrollPixelStep * CurrentScrollSpeed)
          else if DOWN
            MouseMove(xPos, yPos + MapScrollPixelStep * CurrentScrollSpeed)
          else if LEFT
            MouseMove(xPos - MapScrollPixelStep * CurrentScrollSpeed, yPos)
          else if RIGHT
            MouseMove(xPos + MapScrollPixelStep * CurrentScrollSpeed, yPos)
        }
      }
      else InactiveKeys++

      if IsEmulating && InactiveKeys = 4 {
        ; Restore the original arrow event.
        if IsClassicMode
          SendEvent "{Ctrl up}"
        ; Restore the cursor state and stop the emulation.
        MouseMove xPos, yPos
        BlockInput "MouseMoveOff"
        SendEvent "{RButton up}"
        IsEmulating := false
      }
    }
  }
}
; Self-destruct if both the Client and Title is terminated.
until !(WinExist(TitleWindow) || WinExist(ClientWindow))
ExitApp

ShowTooltip(msg) {
  ; Unable to style legacy tooltips on modern systems. (TitleWindow will ALT + TAB out of the current game with a custom GUI)
  ToolTip msg, 50, 50
  SetTimer ToolTip, -2000
}

ToggleScrollSpeed(delta) {
  global CurrentScrollSpeed
  ScrollFloor := 3
  ScrollCeil := 12
  CurrentScrollSpeed := Max(ScrollFloor, Min(ScrollCeil, CurrentScrollSpeed + delta))
  IsDefault := CurrentScrollSpeed = InitialScrollSpeed ? " (default)" : ""
  ; Decreased by 2 to compensate for the lowest available option.
  ShowTooltip("Scroll Speed " . CurrentScrollSpeed - 2 . IsDefault)
}

ToggleSidebarScroll() {
  global SidebarOptionIndex
  SidebarOption := ["Standard", "Structure", "Unit"]
  SidebarOptionIndex := SidebarOptionIndex = 3 ? 1 : SidebarOptionIndex + 1
  ShowTooltip(SidebarOption[SidebarOptionIndex] . " Sidebar Scroll Enabled.")
}
