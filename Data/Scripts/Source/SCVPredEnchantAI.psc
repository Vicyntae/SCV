ScriptName SCVPredEnchantAI Extends ActiveMagicEffect

String Property DebugName
  String Function Get()
    Return "[SCVPredAI " + SCVLib.nameGet(MyActor) + "] "
  EndFunction
EndProperty
Int DMID = 8
SCVLibrary Property SCVLib Auto
Spell Property SCV_SwallowNonLethal Auto
Spell Property SCV_SwallowLethal Auto
Spell Property SCV_TakeInLethal Auto
Spell Property SCV_TakeInNonLethal Auto
Actor MyActor
Actor Prey
Int Timer
Int JA_PredTypes
String[] PredTypes

Float Property PredAggression
  Float Function Get();Rethink this, maybe a better way (base off vore level?)
    Float Value = SCVLib.getGlutValue(MyActor) + (SCVLib.getOVLevelTotal(MyActor) / 4) + (SCVLib.getAVLevelTotal(MyActor) / 4)
    ;Debug.Notification("Pred Aggression = " + Value)
    Return Value
  EndFunction
EndProperty

Float Property AggressionTimer
  Float Function Get()
    Int Value = Math.Ceiling(100 - PredAggression)
    Return PapyrusUtil.ClampInt(Value, 2, 60)
  EndFunction
EndProperty

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Notice("Combat AI Started!")
  MyActor = akTarget
  ;JA_PredTypes = JValue.retain(JArray.object())
  Int ArraySize

  Bool OV_Pred
  If SCVLib.isOVPred(akTarget)
    OV_Pred = True
    ArraySize += 1
  EndIf

  Bool AV_Pred
  If SCVLib.isAVPred(akTarget)
    AV_Pred = True
    ArraySize += 1
  EndIf

  PredTypes = Utility.CreateStringArray(ArraySize, "")
  Int i
  If OV_Pred
    PredTypes[i] = "OV"
    i += 1
  EndIf
  If AV_Pred
    PredTypes[i] = "AV"
    i += 1
  EndIf

  RegisterForSingleUpdate(5)
EndEvent

Event OnUpdate()
  Int VoreChance = Utility.RandomInt(0, 100)
  If VoreChance < PredAggression
    Prey = MyActor.GetCombatTarget()
    If MyActor.GetDistance(Prey) > 150
      ;Insert Ranged attack spell here.
    Else
      Int NumPredTypes = PredTypes.length
      Int Chance
      If NumPredTypes == 1
        Chance = 0
      Else
        Chance = Utility.RandomInt(0, NumPredTypes - 1)
      EndIf
      Bool Lethal
      If MyActor.IsGuard()
        ;Note("Pred is a guard! Casting nonlethal spell.")
        Lethal = False
      Else
        ;Note("Casting lethal spell.")
        Lethal = True
      EndIf
      Spell VoreSpell = getVoreSpell(Chance, Lethal)
      VoreSpell.Cast(MyActor, Prey)
    EndIf
  EndIf
  RegisterForSingleUpdate(5)
EndEvent

Spell Function getVoreSpell(Int aiIndex, Bool abLethal)
  String Type = PredTypes[aiIndex]
  If Type == "OV"
    If abLethal
      Return SCV_SwallowLethal
    Else
      Return SCV_SwallowNonLethal
    EndIf
  ElseIf Type == "AV"
    If abLethal
      Return SCV_TakeInLethal
    Else
      Return SCV_TakeInNonLethal
    EndIf
  EndIf
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Notice("Combat AI Finished!")
  UnregisterForUpdate()
EndEvent

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Debug Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Function Popup(String sMessage)
  SCVLib.ShowPopup(sMessage, DebugName)
EndFunction

Function Note(String sMessage)
  SCVLib.ShowNote(sMessage, DebugName)
EndFunction

Function Notice(String sMessage, Int aiID = 0)
  Int ID
  If aiID > 0
    ID = aiID
  Else
    ID = DMID
  EndIf
  SCVLib.showNotice(sMessage, ID, DebugName)
EndFunction

Function Issue(String sMessage, Int iSeverity = 0, Int aiID = 0, Bool bOverride = False)
  Int ID
  If aiID > 0
    ID = aiID
  Else
    ID = DMID
  EndIf
  SCVLib.ShowIssue(sMessage, iSeverity, ID, bOverride, DebugName)
EndFunction
