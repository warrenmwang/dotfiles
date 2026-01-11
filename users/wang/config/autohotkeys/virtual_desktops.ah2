;Simple 10 Workspace Controller
;Win+1-9,0 to switch to workspace
;Shift+Win+1-9,0 to move active window to workspace

#SingleInstance force
ListLines 0
SendMode "Input"
SetWorkingDir A_ScriptDir
KeyHistory 0
#WinActivateForce

ProcessSetPriority "H"
SetWinDelay -1
SetControlDelay -1

;Include the VD library
#Include %A_LineFile%\..\VD.ah2

;Ensure we have 10 virtual desktops
VD.createUntil(10)

;Win+Number: Switch to workspace
#1::VD.goToDesktopNum(1)
#2::VD.goToDesktopNum(2)
#3::VD.goToDesktopNum(3)
#4::VD.goToDesktopNum(4)
#5::VD.goToDesktopNum(5)
#6::VD.goToDesktopNum(6)
#7::VD.goToDesktopNum(7)
#8::VD.goToDesktopNum(8)
#9::VD.goToDesktopNum(9)
#0::VD.goToDesktopNum(10)

;Shift+Win+Number: Move active window to workspace
#+1::VD.MoveWindowToDesktopNum("A", 1)
#+2::VD.MoveWindowToDesktopNum("A", 2)
#+3::VD.MoveWindowToDesktopNum("A", 3)
#+4::VD.MoveWindowToDesktopNum("A", 4)
#+5::VD.MoveWindowToDesktopNum("A", 5)
#+6::VD.MoveWindowToDesktopNum("A", 6)
#+7::VD.MoveWindowToDesktopNum("A", 7)
#+8::VD.MoveWindowToDesktopNum("A", 8)
#+9::VD.MoveWindowToDesktopNum("A", 9)
#+0::VD.MoveWindowToDesktopNum("A", 10)

