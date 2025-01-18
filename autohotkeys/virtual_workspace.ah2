;#SETUP START
#SingleInstance force
ListLines 0
SendMode "Input"
SetWorkingDir A_ScriptDir
KeyHistory 0
#WinActivateForce

ProcessSetPriority "H"

SetWinDelay -1
SetControlDelay -1


;include the library
#Include %A_LineFile%\..\lib\VD.ah2
;#SETUP END

VD.createUntil(10) ;create until we have at least 3 VD
; return

; -------- now setup the keybindings for the actual commands you want -------- 

; explicitly turn off animations
VD.animation_on := false

; jump to desktop N
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

; moving current active window to desktop N
#+1::VD.MoveWindowToDesktopNum("A",1).follow()
#+2::VD.MoveWindowToDesktopNum("A",2).follow()
#+3::VD.MoveWindowToDesktopNum("A",3).follow()
#+4::VD.MoveWindowToDesktopNum("A",4).follow()
#+5::VD.MoveWindowToDesktopNum("A",5).follow()
#+6::VD.MoveWindowToDesktopNum("A",6).follow()
#+7::VD.MoveWindowToDesktopNum("A",7).follow()
#+8::VD.MoveWindowToDesktopNum("A",8).follow()
#+9::VD.MoveWindowToDesktopNum("A",9).follow()
#+0::VD.MoveWindowToDesktopNum("A",10).follow()