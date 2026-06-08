#Requires AutoHotkey v2.0

global leaderArmed := false

; ─── Stage 1: detect Ctrl tap (pressed and released alone) ───────────────────
#HotIf WinActive("ahk_exe WindowsTerminal.exe")

~LControl Up::HandleCtrlTap()
~RControl Up::HandleCtrlTap()

#HotIf

; ─── Stage 2: when armed, intercept Space and capture the action key ─────────
#HotIf WinActive("ahk_exe WindowsTerminal.exe") && leaderArmed

Space::
{
    global leaderArmed
    leaderArmed := false
    SetTimer(ResetLeader, 0)

    ih := InputHook("L1 T1.5", "{Esc}")
    ih.Start()
    ih.Wait()
    key := ih.Input

    if (key = "")
        return
    DispatchAction(key)
}

#HotIf

; ─── helpers ─────────────────────────────────────────────────────────────────
HandleCtrlTap() {
    global leaderArmed
    if (A_PriorKey = "LControl" || A_PriorKey = "RControl") {
        leaderArmed := true
        SetTimer(ResetLeader, -400)
    }
}

ResetLeader() {
    global leaderArmed
    leaderArmed := false
}

DispatchAction(key) {
    if (RegExMatch(key, "^[1-9]$"))
        Send("^!" . key)         ; Ctrl+Alt+N  — switch to tab N
    else if (key = "h")
        Send("!{Left}")          ; Alt+Left    — focus pane left
    else if (key = "j")
        Send("!{Down}")          ; Alt+Down    — focus pane down
    else if (key = "k")
        Send("!{Up}")            ; Alt+Up      — focus pane up
    else if (key = "l")
        Send("!{Right}")         ; Alt+Right   — focus pane right
    else if (key = "n")
        Send("^{Tab}")           ; Ctrl+Tab    — next tab
    else if (key = "p")
        Send("^+{Tab}")          ; Ctrl+Shift+Tab — previous tab
    else if (key = '"')
        Send("!+-")              ; Alt+Shift+- — split horizontal
    else if (key = "%")
        Send("!+=")              ; Alt+Shift+= — split vertical
}
