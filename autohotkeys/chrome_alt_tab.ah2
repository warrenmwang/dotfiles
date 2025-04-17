; Allow Alt+N to trigger Ctrl+N for switching to tabs on Windows
#HotIf WinActive("ahk_exe chrome.exe")
!1::Send "^1"  ; Alt+1 sends Ctrl+1 (Switch to tab 1)
!2::Send "^2"  ; Alt+2 sends Ctrl+2 (Switch to tab 2)
!3::Send "^3"  ; Alt+3 sends Ctrl+3 (Switch to tab 3)
!4::Send "^4"  ; Alt+4 sends Ctrl+4 (Switch to tab 4)
!5::Send "^5"  ; Alt+5 sends Ctrl+5 (Switch to tab 5)
!6::Send "^6"  ; Alt+6 sends Ctrl+6 (Switch to tab 6)
!7::Send "^7"  ; Alt+7 sends Ctrl+7 (Switch to tab 7)
!8::Send "^8"  ; Alt+8 sends Ctrl+8 (Switch to tab 8)
!9::Send "^9"  ; Alt+9 sends Ctrl+9 (Switch to tab 9)
#HotIf
