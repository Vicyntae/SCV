ScriptName SCV_DEBUG_ForceOV Extends ActiveMagicEffect

Spell Property SCV_SwallowLethal Auto
Spell Property SCV_SwallowNonLethal Auto
Bool Property Setting_Lethal Auto
SCVLibrary Property SCVLib Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
  Debug.Notification("Forcing Vore")
  If Setting_Lethal
    SCV_SwallowLethal.Cast(akTarget, akCaster)
  Else
    SCV_SwallowNonLethal.Cast(akTarget, akCaster)
  EndIf
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: FOV] " + sMessage)
EndFunction
