ScriptName SCVEssentialTracker Extends Quest

SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto
SCLSettings Property SCLSet Auto
Actor Property PlayerRef Auto
String DebugName = "[SCVEssential] "
Int DMID = 9
Formlist Property SCV_VIPreyList Auto
FormList Property SCV_EssentialTrackingList Auto
ObjectReference Property SCV_EssentialTrackerCellMarker Auto

Function trackActor(Actor akTarget)
  SCV_EssentialTrackingList.AddForm(akTarget)
  akTarget.MoveTo(SCV_EssentialTrackerCellMarker)
EndFunction

Function restoreActor(Actor akTarget)
  SCV_EssentialTrackingList.RemoveAddedForm(akTarget)
  akTarget.MoveToPackageLocation()
EndFunction

Form[] Function getActorList()
  Return SCV_EssentialTrackingList.ToArray()
EndFunction

;/Int Function trackActor(Actor akTarget)
  Int i
  Int NumAlias = GetNumAliases()
  While i < NumAlias  ;Find first empty alias
    ;Notice("Add: Checking Alias " + i)
    ReferenceAlias LoadedAlias = GetNthAlias(i) as ReferenceAlias
    If !LoadedAlias.GetActorReference()
      ;Notice("Add: Found empty alias " + i)
      LoadedAlias.ForceRefTo(akTarget)
      ;(LoadedAlias as SCLMonitor).Setup()
      Return i
    EndIf
    i += 1
  EndWhile

  i = 0
  While i < NumAlias ;Find first non-listed alias
    ReferenceAlias LoadedAlias = GetNthAlias(i) as ReferenceAlias
    Actor a = GetActorReference()
    If !SCV_VIPreyList.HasForm(a.GetLeveledActorBase())
      LoadedAlias.ForceRefTo(akTarget)
      Return i
    EndIf
  EndWhile
  Return -1
EndFunction/;

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
