;----------------------------------------------------------------------------------------------------------------------
; This code is free software: you can redistribute it and/or modify  it under the terms of the 
; version 3 GNU General Public License as published by the Free Software Foundation.
; 
; This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY without even 
; the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
; See the GNU General Public License for more details (https://www.gnu.org/licenses/gpl-3.0.html)
;
; WARNING TO USERS AND MODIFIERS
;
; This script contains "Buy me a coffee" links to honor the author's hard work and dedication in creating
; all the features present in this code. Removing or altering these links not only violates the GPL license
; but also disregards the significant effort put into making this script valuable for the community.
;
; If you find value in this script and would like to show appreciation to the author,
; kindly consider visiting the site below and treating the author to a few cups of coffee:
;
; https://www.buymeacoffee.com/screeneroner
;
; Your honor and gratitude is greatly appreciated.
;----------------------------------------------------------------------------------------------------------------------

; Changes History (Don't forget to change version in Menu, Tray, Tip...)
; 1.01 - added turning CheckIfLocked on when Caffeine Enabled and off if Caffeine Disabled 
; 1.02 - fixed/improved CheckIfLocked stability
; 1.03 - turn off both timers when screen is locked to prevent its awakening 


#SingleInstance force
#Persistent

Menu, Tray, NoStandard
Menu, Tray, Add, Caffeine Enabled, ToggleCaffeineState
Menu, Tray, Add
Menu, Tray, Add, Buy me a coffee, BuyCoffee
Menu, Tray, Add, Exit, ScriptExit
Menu, Tray, Default, Caffeine Enabled

ScriptExit() {
    ExitApp
}

BuyCoffee() {
    Run, https://www.buymeacoffee.com/screeneroner
}

; Every 10 seconds check if workstation was locked - disable Caffeine
CheckIfLocked() {
    global CaffeineEnabled
    static lastState := false
    newState := !DllCall("User32\OpenInputDesktop", "uint", 0, "int", false, "uint", GENERIC_READ)
    if (newState && !lastState && CaffeineEnabled) {
        ToggleCaffeineState()
    }
    lastState := newState
}

CheckInactivity() {
    global CaffeineEnabled
    if (CaffeineEnabled && A_TimeIdle >= 50000) {
        Send, {LShift down}{LShift up}
        Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, 50
        sleep, 700
        Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, 145
    }
}

ToggleCaffeineState() {
    global CaffeineEnabled
    CaffeineEnabled := !CaffeineEnabled
    ; Restart timers when caffeine is enabled and Stop timers when caffeine is disabled
    if (CaffeineEnabled) 
    {
        SetTimer, CheckIfLocked, 10000 
        SetTimer, CheckInactivity, 60000
    }
    else 
    {
        SetTimer, CheckIfLocked, Off  
        SetTimer, CheckInactivity, Off
    }
    Menu, Tray, Tip, % "Caffeine v1.03 " . (CaffeineEnabled ? "Enabled" : "Disabled")
    Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, % (CaffeineEnabled ? 145 : 132)
    Menu, Tray, Icon, Caffeine Enabled, %SystemRoot%\System32\shell32.dll, % (CaffeineEnabled ? 145 : 132)
}

CaffeineEnabled := false
ToggleCaffeineState()
SetTimer, CheckIfLocked, 10000
SetTimer, CheckInactivity, 60000
