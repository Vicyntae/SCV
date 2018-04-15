;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname PF_SCV_AIFindOVPreyPackage01_0301A917 Extends Package Hidden

Spell Property SCV_AIFindOVPreySpellStop01 Auto
;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
SCV_AIFindOVPreySpellStop01.Cast(akActor)
Int handle = ModEvent.Create("SCV_AIFindOVPreyPackageComplete")
ModEvent.PushForm(handle, akActor)
ModEvent.Send(handle)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
