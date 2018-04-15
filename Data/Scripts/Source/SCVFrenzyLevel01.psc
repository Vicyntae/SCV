ScriptName SCVFrenzyLevel01 Extends ActiveMagicEffect

Actor MyActor
Int ActorData
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Spell Property SCV_AIFindOVPreySpell01a Auto
Spell Property SCL_AIFindFoodSpell01a Auto
Spell Property SCL_AIFindFoodSpell01b Auto
Spell Property SCL_AIFindFoodSpellStop01 Auto
Spell Property SCV_AIFindOVPreySpellStop01 Auto
MagicEffect Property SCL_AIFindFoodEffect01a Auto
MagicEffect Property SCL_AIFindFoodEffect01b Auto
MagicEffect Property SCV_AIFindOVPreyEffect01a Auto
Actor Property PlayerRef Auto
String Property DebugName
  String Function Get()
    Return "[SCV FrenzyLvl01: " + MyActorName + "] "
  EndFunction
EndProperty
Int DMID = 7
String Property MyActorName
  String Function Get()
    Return MyActor.GetLeveledActorBase().GetName()
  EndFunction
EndProperty

Event OnEffectStart(Actor akTarget, Actor akCaster)
  RegisterForSingleUpdate(15)
  RegisterForModEvent("SCV_InsertEvent", "OnPreyEaten")
EndEvent

Int Property Severity
  Int Function Get()
    Return JMap.getInt(ActorData, "SCV_FrenzySeverity")
  EndFunction
  Function Set(Int a_Val)
    JMap.setInt(ActorData, "SCV_FrenzySeverity", a_Val)
  EndFunction
EndProperty

Event OnUpdate()
  ;Begin search for food
  Int Chance = Utility.RandomInt()
  If Chance < Severity
    Int MealValue
    If Severity < 25
      MealValue = 1
    ElseIf Severity < 50
      MealValue = 2
    ElseIf Severity < 75
      MealValue = 3
    Else
      MealValue = 4
    EndIf
    Int Gluttony = SCVLib.getGlutValue(MyActor, ActorData)
    Float Fullness = JMap.getFlt(ActorData, "STFullness")
    Float Min = SCVLib.getGlutMin(Gluttony)
    If Fullness < Min
      Float Eaten = SCVLib.actorEat(MyActor, MealValue, 1, True)
      Float MealSize = SCVLib.genMealValue(Gluttony, aiType = MealValue)
      If (Eaten < MealSize / 2)
        Severity += Math.Ceiling(Min - Eaten)
        If !MyActor.IsInCombat()
          SCL_AIFindFoodSpell01a.Cast(MyActor)
        EndIf
      Else
        Severity += Math.Ceiling(Eaten - Min)
      EndIf
    EndIf
  EndIf
  RegisterForModEvent("SCV_InsertEvent", "OnPreyEaten")
  RegisterForSingleUpdate(15)
EndEvent

Event OnPreyEaten(Form akPred, Form akPrey, Int aiItemType, Bool Friendly)
  If akPred == MyActor && akPrey as Actor
    If aiItemType == 1 || aiItemType == 2
      Severity -= Math.Ceiling(SCVLib.genDigestValue(akPrey as Actor) / 2)
      Notice("Prey " + (akPrey as Actor).GetLeveledActorBase().GetName() + " Eaten! Severity = " + Severity)
      If MyActor.HasMagicEffect(SCV_AIFindOVPreyEffect01a)
        SCV_AIFindOVPreySpellStop01.Cast(MyActor)
      EndIf
      If MyActor.HasMagicEffect(SCL_AIFindFoodEffect01b) || MyActor.HasMagicEffect(SCL_AIFindFoodEffect01a)
        SCL_AIFindFoodSpellStop01.Cast(MyActor)
      EndIf
    EndIf
  EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  If akBaseObject as Potion || akBaseObject as Ingredient
    If JMap.getInt(SCVLib.getItemDataEntry(akBaseObject), "STIsNotFood") == 0
      Severity -= Math.Ceiling(SCVLib.genDigestValue(akBaseObject) / 2)
      Notice("Food " + akBaseObject.GetName() + " Eaten! Severity = " + Severity)
      If MyActor.HasMagicEffect(SCV_AIFindOVPreyEffect01a)
        SCV_AIFindOVPreySpellStop01.Cast(MyActor)
      EndIf
      If MyActor.HasMagicEffect(SCL_AIFindFoodEffect01b) || MyActor.HasMagicEffect(SCL_AIFindFoodEffect01a)
        SCL_AIFindFoodSpellStop01.Cast(MyActor)
      EndIf
    EndIf
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
