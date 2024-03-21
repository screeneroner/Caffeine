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

#SingleInstance force
#Persistent

Menu, Tray, NoStandard
Menu, Tray, Add, Caffeine Enabled, ToggleCaffeineState
Menu, Tray, Add
Menu, Tray, Add, Buy me a coffee, BuyCoffee
Menu, Tray, Add, Exit, ScriptExit
Menu, Tray, Default, Caffeine Enabled

; Every 10 seconds check if workstation was locked - disable Coffeine
SetTimer, CheckIfLocked, 10000
CheckIfLocked() {
    global CaffeineEnabled    
    if (CaffeineEnabled) {
        if( !DllCall("User32\OpenInputDesktop","int",0*0,"int",0*0,"int",0x0001L*1) )             
            ToggleCaffeineState()  
    }
    else 
    {
        Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, 110
        sleep, 300
        Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, 132
    }
}

; Every 1 minute check if there is no user activity and Caffeine enabled - press LShift to emulate user activity
SetTimer, CheckInactivity, 60000  
CheckInactivity() {
    global CaffeineEnabled
    if (CaffeineEnabled && A_TimeIdle >= 50000)
    {
        Send, {LShift down}{LShift up}
        Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, 50
        sleep, 700
        Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, 145
    }
}

ToggleCaffeineState() {
    global CaffeineEnabled
    CaffeineEnabled := !CaffeineEnabled
    Menu, Tray, Tip, % "Caffeine " . (CaffeineEnabled ? "Enabled" : "Disabled")
    Menu, Tray, Icon, %SystemRoot%\System32\shell32.dll, % (CaffeineEnabled ? 145 : 132)
    Menu, Tray, Icon, Caffeine Enabled, %SystemRoot%\System32\shell32.dll, % (CaffeineEnabled ? 145 : 132)
}

ScriptExit() { 
    ExitApp
}

BuyCoffee() {
    Run, https://www.buymeacoffee.com/screeneroner
}

CaffeineEnabled := false
ToggleCaffeineState()

