ScriptName SCVFrenzyController Extends ActiveMagicEffect
;IDEAS: Two levels of frenzy (0-100, 101-200)
;Low will go after (unowned) food or food in inventory
;High will go after owned food and any viable actors.
;High level will grant magical debuffs and strength buffs (movement speed buffs?)

SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto

String Property DebugName
  String Function Get()
    Return "[SCV Frenzy: " + MyActorName + "] "
  EndFunction
EndProperty
Int DMID = 7

Actor MyActor
String Property MyActorName
  String Function Get()
    Return MyActor.GetLeveledActorBase().GetName()
  EndFunction
EndProperty
Spell Property SCL_AIFindFoodSpellStop01 Auto
Spell Property SCV_AIFindOVPreySpellStop01 Auto
MagicEffect Property SCL_AIFindFoodEffect01a Auto
MagicEffect Property SCL_AIFindFoodEffect01b Auto
MagicEffect Property SCV_AIFindOVPreyEffect01a Auto

Spell Property SCV_FrenzyLevel00 Auto
Spell Property SCV_FrenzyLevel01 Auto
Spell Property SCV_FrenzyLevel02 Auto
Actor Property PlayerRef Auto
Int ActorData
Int Property Severity
  Int Function Get()
    Return JMap.getInt(ActorData, "SCV_FrenzySeverity")
  EndFunction
  Function Set(Int a_Val)
    JMap.setInt(ActorData, "SCV_FrenzySeverity", a_Val)
  EndFunction
EndProperty

Int Property FrenzyLevel
  Int Function Get()
    Return JMap.getInt(ActorData, "SCV_FrenzyLevel")
  EndFunction
  Function Set(Int a_Val)
    JMap.setInt(ActorData, "SCV_FrenzyLevel", a_Val)
  EndFunction
EndProperty

Spell Property Setting_EquipAbility Auto
Float Property Setting_UpdateRate = 0.5 Auto            ;How often does the player AI update (affects severity growth)
Int Property Setting_InitialSeverity = 0 Auto
Int Property Setting_SeverityIncreaseRate = 1 Auto      ;How much does severity increase per update for the player
Event OnEffectStart(Actor akTarget, Actor akCaster)
  MyActor = akTarget
  ActorData = SCVLib.getTargetData(akTarget, True)
  Notice("Frenzy Starting! Severity = " + Setting_InitialSeverity)

  Severity = Setting_InitialSeverity
  checkSeverity()
  If !akTarget.HasSpell(Setting_EquipAbility)
    akTarget.AddSpell(Setting_EquipAbility, False)
  EndIf
  RegisterForSingleUpdate(Setting_UpdateRate)
EndEvent

Event OnUpdate()
  Severity += Setting_SeverityIncreaseRate
  checkSeverity()
  RegisterForSingleUpdate(Setting_UpdateRate)
EndEvent

Function checkSeverity()
  If Severity > 100 && (SCVLib.isOVPred(MyActor, ActorData) || SCVLib.isAVPred(MyActor, ActorData)) && FrenzyLevel != 2
    SCV_FrenzyLevel00.Cast(MyActor)
    SCV_FrenzyLevel02.Cast(MyActor)
    FrenzyLevel = 2
  ElseIf FrenzyLevel != 1 && Severity > 0
    SCV_FrenzyLevel00.Cast(MyActor)
    SCV_FrenzyLevel01.Cast(MyActor)
    FrenzyLevel = 1
    If MyActor.HasMagicEffect(SCV_AIFindOVPreyEffect01a)
      SCV_AIFindOVPreySpellStop01.Cast(MyActor)
    EndIf
    If MyActor.HasMagicEffect(SCL_AIFindFoodEffect01b)
      SCL_AIFindFoodSpellStop01.Cast(MyActor)
    EndIf
  ElseIf FrenzyLevel != 0
    SCV_FrenzyLevel00.Cast(MyActor)
    FrenzyLevel = 0
    If MyActor.HasMagicEffect(SCV_AIFindOVPreyEffect01a)
      SCV_AIFindOVPreySpellStop01.Cast(MyActor)
    EndIf
    If MyActor.HasMagicEffect(SCL_AIFindFoodEffect01b) || MyActor.HasMagicEffect(SCL_AIFindFoodEffect01a)
      SCL_AIFindFoodSpellStop01.Cast(MyActor)
    EndIf
  EndIf
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  SCV_FrenzyLevel00.Cast(MyActor)
  FrenzyLevel = 0
  If MyActor.HasMagicEffect(SCV_AIFindOVPreyEffect01a)
    SCV_AIFindOVPreySpellStop01.Cast(MyActor)
  EndIf
  If MyActor.HasMagicEffect(SCL_AIFindFoodEffect01b) || MyActor.HasMagicEffect(SCL_AIFindFoodEffect01a)
    SCL_AIFindFoodSpellStop01.Cast(MyActor)
  EndIf
  If akTarget.HasSpell(Setting_EquipAbility)
    akTarget.RemoveSpell(Setting_EquipAbility)
  EndIf
EndEvent



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

Bool Function PlayerThoughtDB(Actor akTarget, String sKey, Int iOverride = 0, Actor[] akActors = None, Int aiActorIndex = -1)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Pulls message from database; make sure sKey is valid.
  Will add POV int to end of key, so omit it in the parameter}
  Return SCVLib.ShowPlayerThoughtDB(akTarget, sKey, iOverride, akActors, aiActorIndex)
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
