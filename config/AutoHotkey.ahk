; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.


; Control-Shift-Z to minimize current window
^+Z::
WinMinimize, A
return

; Control-Shift-Space to maximize current window
^+Space::
WinMaximize, A
return

^!+Enter::
Send {Backspace}{Return}{Down}
return

Menu, Tray, Icon, C:\WINDOWS\system32\SHELL32.dll, 13

; Allow Alt-P to paste test (to mintty, since Alt-Space->Edit->Paste) isn't available
!p::
;get rid of any non-text on the clipboard
SendInput {Raw}%clipboard%
return

^+a::
;get rid of any non-text on the clipboard
clipboard = %clipboard%
return

^!+p::
IfWinExist Password Safe
  WinActivate
else {
  ;Run %USERPROFILE%\usr\local\pc\lnk\PwSafe_Ctrl_Alt_Shift_P.lnk
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\PwSafe_Ctrl_Alt_Shift_P.lnk
}
return

^!+d::
IfWinExist Dropbox
  WinActivate
else {
  Run %A_MyDocuments%\Dropbox
  WinWait Dropbox
}
return

^+u::
SetTitleMatchMode 2 ;match anywhere in title
IfWinExist Mintty_1_Ctrl_Shift_U
  WinActivate
else
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\Mintty_1_Ctrl_Shift_U.lnk
return

^+j::
SetTitleMatchMode 2 ;match anywhere in title
IfWinExist Mintty_2_Ctrl_Shift_J
  WinActivate
else
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\Mintty_2_Ctrl_Shift_J.lnk
return

^+n::
SetTitleMatchMode 2 ;match anywhere in title
IfWinExist Mintty_3_Ctrl_Shift_N
  WinActivate
else
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\Mintty_3_Ctrl_Shift_N.lnk
return

;; does not work!!??!!??!! hmmm...
^!+u::
SetTitleMatchMode 2 ;match anywhere in title
IfWinExist Mintty_1a_Ctrl_Shift_U
  WinActivate
else
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\mintty_admin\Mintty_1a_Ctrl_Shift_U.lnk
return

^!+j::
SetTitleMatchMode 2 ;match anywhere in title
IfWinExist Mintty_2a_Ctrl_Shift_J
  WinActivate
else
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\mintty_admin\Mintty_2a_Ctrl_Shift_J.lnk
return

^!+n::
SetTitleMatchMode 2 ;match anywhere in title
IfWinExist Mintty_3a_Ctrl_Shift_N
  WinActivate
else
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\mintty_admin\Mintty_3a_Ctrl_Shift_N.lnk
return

^+i::
SetTitleMatchMode 2 ;match "Mozilla Firefox" anywhere in title
IfWinExist Mozilla Firefox
  WinActivate
else
  ;Run %USERPROFILE%\usr\local\pc\lnk\FireFox_Ctrl_Alt_Shift_I.lnk
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\FireFox_Ctrl_Alt_Shift_I.lnk
return

;^+i::
;SetTitleMatchMode 2 ;match "Chrome" anywhere in title
;IfWinExist Chrome
;  WinActivate
;else
; ;Run %USERPROFILE%\usr\local\pc\lnk\Chrome_Ctrl_Alt_Shift_I.lnk
;  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\Chrome_Ctrl_Alt_Shift_I.lnk
;return

^+p::
IfWinExist emacs@%HOSTNAME%
  WinActivate
else
  ;Run %USERPROFILE%\usr\local\pc\lnk\Emacs_Ctrl_Alt_Shift_P.lnk
  Run C:\cygwin64\home\gsisson\usr\local\pc\lnk\Emacs_Ctrl_Alt_Shift_P.lnk
return

^+_::
IfWinExist Shortcuts
  WinActivate
else {
  Run %A_MyDocuments%\Shortcuts
  WinWait Shortcuts
}
WinMove, Documents, , (A_ScreenWidth - 400), 0, 400, (A_ScreenHeight - 40)
return

;!TAB::
;Run %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\z      1) Programs\Tools\Macros Hotkeys Key Remapping\Window Switcher.lnk
;Run C:\cygwin64\home\gsisson\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\z      1) Programs\Tools\Macros Hotkeys Key Remapping\Window Switcher.lnk
;return

; used by WinSplit Revolution:
; ^!Numpad0:: Autoplacement
; ^+c::       down left
; ^+v::       down
; ^+b::       down right
; ^+d::       left
; ^+f::       fullscreen
; ^+g::       right
; ^+c::       up left
; ^!Numpad7:: up (want ^+e, but it complains that Windows is using it!)
; ^+t::       up right
; ^+Left::    move to left screen
; ^+Right::   move to right screen
; ^+PgDn::    minimize window
; ^+PgUp::    restore minimized window


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
