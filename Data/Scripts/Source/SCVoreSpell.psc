ScriptName SCVoreSpell Extends ActiveMagicEffect
Int DMID = 9
String Property DebugName
  String Function Get()
    Return "[SCVoreSpell " + VoreType + ":" + PredName + ", " + PreyName + "] "
  EndFunction
EndProperty

String VoreType = "Null"
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Actor property PlayerRef Auto
Formlist Property SCV_InVoreActionList Auto ; Prevents any vore actions if they are already in one

Keyword Property ActorTypeDwarven Auto
Keyword Property ActorTypeDragon Auto
Keyword Property ActorTypeGhost Auto
Keyword Property ActorTypeDaedra Auto
Keyword Property ActorTypeUndead Auto
Keyword Property ActorTypeNPC Auto

Bool Property Setting_Lethal = False Auto ;Will the prey be digested or stored afterwards (Type 1 or Type 2?)
Actor _Pred
Actor Property Pred
  Actor Function Get()
    Return _Pred
  EndFunction
  Function Set(Actor a_val)
    _Pred = a_val
    PredName = a_val.GetLeveledActorBase().GetName()
    PredData = SCVLib.getTargetData(a_val)
  EndFunction
EndProperty
String Property PredName Auto
Int Property PredData Auto

Actor _Prey
Actor Property Prey
  Actor Function Get()
    Return _Prey
  EndFunction
  Function Set(Actor a_val)
    _Prey = a_val
    PreyName = a_val.GetLeveledActorBase().GetName()
    PreyData = SCVLib.getTargetData(a_val)
  EndFunction
EndProperty
String Property PreyName Auto
Int Property PreyData Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Pred = akCaster
  Prey = akTarget

  If !checkConditions()
    Dispel()
    Return
  EndIf

  If !checkSpecificConditions()
    Dispel()
    Return
  EndIf

  runVore()
  Return
EndEvent

Bool Function checkConditions()
  If SCV_InVoreActionList.HasForm(Prey)
    Notice("Failed. Prey is in a vore action already.")
    Return False
  EndIf

  If Pred != PlayerRef
    If Pred.GetLeveledActorBase().GetSex() == 0
      If (!SCVSet.EnableMTeamPreds && Pred.IsPlayerTeammate()) || (!SCVSet.EnableMPreds)
        Notice("Failed. Pred gender (M) has been disabled")
        Return False
      EndIf
    Else
      If (!SCVSet.EnableFTeamPreds && Pred.IsPlayerTeammate()) || (!SCVSet.EnableFPreds)
        Notice("Failed. Pred gender (F) has been disabled")
        Return False
      EndIf
    EndIf
  EndIf

  If Prey.IsEssential()
    If Pred == PlayerRef
      If !SCVSet.EnablePlayerEssentialVore
        Notice("Failed. Player has been restricted from eating essential NPCs")
        Return False
      EndIf
    ElseIf !SCVSet.EnableEssentialVore
      Notice("Failed. Actors have been restricted from eating essential NPCs")
      Return False
    EndIf
  EndIf

  If SCVLib.isPreyProtected(Prey, PredData)
    Notice("Failed. Prey is protected.")
    Return False
  EndIf

  Return True
EndFunction

Bool Function checkSpecificConditions()
  Return True
EndFunction

Function runVore()
EndFunction

Float Function calculateChance()
  Return 0
EndFunction
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Debug Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Bool Function PlayerThought(Actor akTarget, String sMessage1 = "", String sMessage2 = "", String sMessage3 = "", Int iOverride = 0)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Make sure sMessage1 is 1st person, sMessage2 is 2nd person, sMessage3 is 3rd person
  Make sure at least one is filled: it will default to it regardless of setting
  Use iOverride to force a particular message}

  If akTarget == PlayerRef
    Int Setting = SCLSet.PlayerMessagePOV
    If Setting == -1
      Return True
    EndIf
    If (sMessage1 && Setting == 1) || iOverride == 1
      Debug.Notification(sMessage1)
    ElseIf (sMessage2 && Setting == 2) || iOverride == 2
      Debug.Notification(sMessage3)
    ElseIf (sMessage3 && Setting == 3) || iOverride == 3
      Debug.Notification(sMessage3)
    ElseIf sMessage3
      Debug.Notification(sMessage3)
    ElseIf sMessage1
      Debug.Notification(sMessage1)
    ElseIf sMessage2
      Debug.Notification(sMessage2)
    Else
      Issue("Empty player thought. Skipping...", 1)
    EndIf
    Return True
  Else
    Return False
  EndIf
EndFunction

Bool Function PlayerThoughtDB(Actor akTarget, String sKey, Int iOverride = 0, Int JA_Actors = 0, Int aiActorIndex = -1)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Pulls message from database; make sure sKey is valid.
  Will add POV int to end of key, so omit it in the parameter}
  Return SCVLib.ShowPlayerThoughtDB(akTarget, sKey, iOverride, JA_Actors, aiActorIndex)
EndFunction

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
