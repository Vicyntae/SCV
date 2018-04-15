ScriptName SCVSpellBookTeach Extends ObjectReference

Actor Property PlayerRef Auto
Spell Property Settings_AddSpell1 Auto
Spell Property Settings_AddSpell2 Auto
Spell Property Settings_AddSpell3 Auto
Spell Property Settings_AddSpell4 Auto
Spell Property Settings_AddSpell5 Auto
Event OnRead()
  If Settings_AddSpell1 && !PlayerRef.HasSpell(Settings_AddSpell1)
    PlayerRef.AddSpell(Settings_AddSpell1)
  EndIf
  If Settings_AddSpell2 && !PlayerRef.HasSpell(Settings_AddSpell2)
    PlayerRef.AddSpell(Settings_AddSpell2)
  EndIf
  If Settings_AddSpell3 && !PlayerRef.HasSpell(Settings_AddSpell3)
    PlayerRef.AddSpell(Settings_AddSpell3)
  EndIf
  If Settings_AddSpell4 && !PlayerRef.HasSpell(Settings_AddSpell4)
    PlayerRef.AddSpell(Settings_AddSpell4)
  EndIf
  If Settings_AddSpell5 && !PlayerRef.HasSpell(Settings_AddSpell5)
    PlayerRef.AddSpell(Settings_AddSpell5)
  EndIf
EndEvent
