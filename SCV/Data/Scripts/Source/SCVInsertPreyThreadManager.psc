ScriptName SCVInsertPreyThreadManager Extends Quest

Quest Property SCV_InsertPreyQuest Auto
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Actor Property PlayerRef Auto
SCVInsertPreyThread01 thread01
SCVInsertPreyThread02 thread02
SCVInsertPreyThread03 thread03
SCVInsertPreyThread04 thread04
SCVInsertPreyThread05 thread05
SCVInsertPreyThread06 thread06
SCVInsertPreyThread07 thread07
SCVInsertPreyThread08 thread08
SCVInsertPreyThread09 thread09
SCVInsertPreyThread10 thread10

String DebugName = "[SCVInsertPrey Thread Manager] "
Int DMID = 8
Event OnInit()
  SCLibrary.addToReloadList(Self)

  thread01 = SCV_InsertPreyQuest as SCVInsertPreyThread01
  thread01.SCVLib = SCVLib
  thread01.SCLSet = SCLSet
  thread01.SCVSet = SCVSet
  thread01.PlayerRef = PlayerRef
  thread01.ThreadID = 1


  thread02 = SCV_InsertPreyQuest as SCVInsertPreyThread02
  thread02.SCVLib = SCVLib
  thread02.SCLSet = SCLSet
  thread02.SCVSet = SCVSet
  thread02.PlayerRef = PlayerRef
  thread02.ThreadID = 2


  thread03 = SCV_InsertPreyQuest as SCVInsertPreyThread03
  thread03.SCVLib = SCVLib
  thread03.SCLSet = SCLSet
  thread03.SCVSet = SCVSet
  thread03.PlayerRef = PlayerRef
  thread03.ThreadID = 3


  thread04 = SCV_InsertPreyQuest as SCVInsertPreyThread04
  thread04.SCVLib = SCVLib
  thread04.SCLSet = SCLSet
  thread04.SCVSet = SCVSet
  thread04.PlayerRef = PlayerRef
  thread04.ThreadID = 4


  thread05 = SCV_InsertPreyQuest as SCVInsertPreyThread05
  thread05.SCVLib = SCVLib
  thread05.SCLSet = SCLSet
  thread05.SCVSet = SCVSet
  thread05.PlayerRef = PlayerRef
  thread05.ThreadID = 5


  thread06 = SCV_InsertPreyQuest as SCVInsertPreyThread06
  thread06.SCVLib = SCVLib
  thread06.SCLSet = SCLSet
  thread06.SCVSet = SCVSet
  thread06.PlayerRef = PlayerRef
  thread06.ThreadID = 6


  thread07 = SCV_InsertPreyQuest as SCVInsertPreyThread07
  thread07.SCVLib = SCVLib
  thread07.SCLSet = SCLSet
  thread07.SCVSet = SCVSet
  thread07.PlayerRef = PlayerRef
  thread07.ThreadID = 7


  thread08 = SCV_InsertPreyQuest as SCVInsertPreyThread08
  thread08.SCVLib = SCVLib
  thread08.SCLSet = SCLSet
  thread08.SCVSet = SCVSet
  thread08.PlayerRef = PlayerRef
  thread08.ThreadID = 8


  thread09 = SCV_InsertPreyQuest as SCVInsertPreyThread09
  thread09.SCVLib = SCVLib
  thread09.SCLSet = SCLSet
  thread09.SCVSet = SCVSet
  thread09.PlayerRef = PlayerRef
  thread09.ThreadID = 9


  thread10 = SCV_InsertPreyQuest as SCVInsertPreyThread10
  thread10.SCVLib = SCVLib
  thread10.SCLSet = SCLSet
  thread10.SCVSet = SCVSet
  thread10.PlayerRef = PlayerRef
  thread10.ThreadID =10


  Maintenence()
EndEvent

Int Function GetStage()
  Maintenence()
  Return Parent.GetStage()
EndFunction

Function Maintenence()
  thread01.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread02.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread03.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread04.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread05.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread06.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread07.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread08.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread09.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
  thread10.RegisterForModEvent("SCV_OnInsertPreyThread", "OnInsertPreyCall")
EndFunction

Int Function insertPreyAsync(Actor akPred, Actor akPrey, Int aiItemType, Bool abFriendly, Int aiAnimRecall)
  ;Notice("Insert Prey Async Called.")
  If !checkActors(akPred, akPrey)
    ;Notice("One or more actors already in threads! Cancelling.")
    Return -1
  EndIf
  Int Future
  While !Future
    if !thread01.queued()
      thread01.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 1
    ElseIf !thread02.queued()
      thread02.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 2
    ElseIf !thread03.queued()
      thread03.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 3
    ElseIf !thread04.queued()
      thread04.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 4
    ElseIf !thread05.queued()
      thread05.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 5
    ElseIf !thread06.queued()
      thread06.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 6
    ElseIf !thread07.queued()
      thread07.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 7
    ElseIf !thread08.queued()
      thread08.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 8
    ElseIf !thread09.queued()
      thread09.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 9
    ElseIf !thread10.queued()
      thread10.setThread(akPred, akPrey, aiItemType, abFriendly, aiAnimRecall)
      Future = 10
    Else
      begin_waiting()
    EndIf
  EndWhile
  ;Notice("Thread " + Future + " queued!")
  RaiseEvent_OnInsertPreyThread(Future)
  Return Future
EndFunction

Bool Function checkActors(Actor akPred, Actor akPrey)
  {Checks and sees if it's safe to add prey.}
  if thread01.getPred() == akPrey || thread01.getPrey() == akPred || thread01.getPrey() == akPrey
    Return False
  ElseIf thread02.getPred() == akPrey || thread02.getPrey() == akPred || thread02.getPrey() == akPrey
    Return False
  ElseIf thread03.getPred() == akPrey || thread03.getPrey() == akPred || thread03.getPrey() == akPrey
    Return False
  ElseIf thread04.getPred() == akPrey || thread04.getPrey() == akPred || thread04.getPrey() == akPrey
    Return False
  ElseIf thread05.getPred() == akPrey || thread05.getPrey() == akPred || thread05.getPrey() == akPrey
    Return False
  ElseIf thread06.getPred() == akPrey || thread06.getPrey() == akPred || thread06.getPrey() == akPrey
    Return False
  ElseIf thread07.getPred() == akPrey || thread07.getPrey() == akPred || thread07.getPrey() == akPrey
    Return False
  ElseIf thread08.getPred() == akPrey || thread08.getPrey() == akPred || thread08.getPrey() == akPrey
    Return False
  ElseIf thread09.getPred() == akPrey || thread09.getPrey() == akPred || thread09.getPrey() == akPrey
    Return False
  ElseIf thread10.getPred() == akPrey || thread10.getPrey() == akPred || thread10.getPrey() == akPrey
    Return False
  Else
    Return True
  EndIf
EndFunction

;/Function wait_all()
  RaiseEvent_OnItemAddCall()
  begin_waiting()
EndFunction/;

Function RaiseEvent_OnInsertPreyThread(Int aiFuture)
  Int handle = ModEvent.Create("SCV_OnInsertPreyThread")
  if handle
    ModEvent.PushInt(handle, aiFuture)
    ModEvent.Send(handle)
  else
    ;pass
  EndIf
EndFunction

Function begin_waiting()
  Bool waiting = True
  int i = 0
  While waiting
    if thread01.queued() || thread02.queued() || thread03.queued() || thread04.queued() || thread05.queued() || \
      thread06.queued() || thread07.queued() || thread08.queued() || thread09.queued() || thread10.queued()
      i += 1
      Utility.Wait(0.1)
      if i >= 100
        Debug.Trace("Error: All threads have become non-responsive. Please debug this issue or contact the author")
        i=0
        Return
      EndIf
    Else
      waiting = false
    EndIf
  EndWhile
EndFunction

Int Function get_result(Int aiThreadID)
  Int i
  While i < 100
    If aiThreadID == 1 && thread01.isReady()
      Return thread01.getResultEntry()
    ElseIf aiThreadID == 2 && thread02.isReady()
      Return thread02.getResultEntry()
    ElseIf aiThreadID == 3 && thread03.isReady()
      Return thread03.getResultEntry()
    ElseIf aiThreadID == 4 && thread04.isReady()
      Return thread04.getResultEntry()
    ElseIf aiThreadID == 5 && thread05.isReady()
      Return thread05.getResultEntry()
    ElseIf aiThreadID == 6 && thread06.isReady()
      Return thread06.getResultEntry()
    ElseIf aiThreadID == 7 && thread07.isReady()
      Return thread07.getResultEntry()
    ElseIf aiThreadID == 8 && thread08.isReady()
      Return thread08.getResultEntry()
    ElseIf aiThreadID == 9 && thread09.isReady()
      Return thread09.getResultEntry()
    ElseIf aiThreadID == 10 && thread10.isReady()
      Return thread10.getResultEntry()
    EndIf
    i += 1
    Utility.Wait(0.5)
  EndWhile
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
