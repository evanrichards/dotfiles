#Requires AutoHotkey v2.0
#SingleInstance Force

; Swap Caps Lock and Left Control.
CapsLock::LCtrl
LCtrl::CapsLock

; Use Alt as the macOS Command equivalent for common shortcuts.
; Native Alt+Tab and Alt+F4 remain unchanged.
!a::Send "^a"
!c::Send "^c"
!f::Send "^f"
!v::Send "^v"
!x::Send "^x"
!z::Send "^z"
!+z::Send "^y"
!s::Send "^s"
!p::Send "^p"
!n::Send "^n"
!o::Send "^o"
!w::Send "^w"
!t::Send "^t"
!l::Send "^l"
!r::Send "^r"
!+t::Send "^+t"

!Backspace::Send "^{Backspace}"
!Left::Send "^{Left}"
!Right::Send "^{Right}"
!+Left::Send "^+{Left}"
!+Right::Send "^+{Right}"

; Emacs-style editing, matching common macOS text-field behavior.
^a::Send "{Home}"
^e::Send "{End}"
^b::Send "{Left}"
^f::Send "{Right}"
^p::Send "{Up}"
^n::Send "{Down}"
^d::Send "{Delete}"
^h::Send "{Backspace}"
^k::{
    Send "+{End}"
    Send "{Delete}"
}
