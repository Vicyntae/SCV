ScriptName SCVAnimationThreadHandler Extends Quest
;/Animation entry format
.SCLExtraData.SCVAnimations (JMap)
;Vital Info:
  RacexRace
  ScalexScale
  Combat/NonCombat/Friendly/Stealth
  Type
Non-Vital Info:
/;
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto
SCLSettings Property SCLSet Auto
Actor Property PlayerRef Auto

String DebugName = "[SCVAnimHandler] "
Int DMID = 7
SCVAnimationThread thread01
SCVAnimationThread thread02
SCVAnimationThread thread03
SCVAnimationThread thread04
SCVAnimationThread thread05
SCVAnimationThread thread06
SCVAnimationThread thread07
SCVAnimationThread thread08
SCVAnimationThread thread09
SCVAnimationThread thread10

Event OnInit()
  SCLibrary.addToReloadList(Self)
  Maintenence()
EndEvent

Function Maintenence()
  thread01 = GetNthAlias(0) as SCVAnimationThread
  thread01.SCVLib = SCVLib
  thread01.SCLSet = SCLSet
  thread01.SCVSet = SCVSet
  thread01.PlayerRef = PlayerRef
  thread01.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread01.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread01.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread02 = GetNthAlias(1) as SCVAnimationThread
  thread02.SCVLib = SCVLib
  thread02.SCLSet = SCLSet
  thread02.SCVSet = SCVSet
  thread02.PlayerRef = PlayerRef
  thread02.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread02.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread02.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread03 = GetNthAlias(2) as SCVAnimationThread
  thread03.SCVLib = SCVLib
  thread03.SCLSet = SCLSet
  thread03.SCVSet = SCVSet
  thread03.PlayerRef = PlayerRef
  thread03.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread03.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread03.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread04 = GetNthAlias(3) as SCVAnimationThread
  thread04.SCVLib = SCVLib
  thread04.SCLSet = SCLSet
  thread04.SCVSet = SCVSet
  thread04.PlayerRef = PlayerRef
  thread04.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread04.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread04.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread05 = GetNthAlias(4) as SCVAnimationThread
  thread05.SCVLib = SCVLib
  thread05.SCLSet = SCLSet
  thread05.SCVSet = SCVSet
  thread05.PlayerRef = PlayerRef
  thread05.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread05.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread05.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread06 = GetNthAlias(5) as SCVAnimationThread
  thread06.SCVLib = SCVLib
  thread06.SCLSet = SCLSet
  thread06.SCVSet = SCVSet
  thread06.PlayerRef = PlayerRef
  thread06.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread06.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread06.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread07 = GetNthAlias(6) as SCVAnimationThread
  thread07.SCVLib = SCVLib
  thread07.SCLSet = SCLSet
  thread07.SCVSet = SCVSet
  thread07.PlayerRef = PlayerRef
  thread07.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread07.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread07.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread08 = GetNthAlias(7) as SCVAnimationThread
  thread08.SCVLib = SCVLib
  thread08.SCLSet = SCLSet
  thread08.SCVSet = SCVSet
  thread08.PlayerRef = PlayerRef
  thread08.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread08.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread08.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread09 = GetNthAlias(8) as SCVAnimationThread
  thread09.SCVLib = SCVLib
  thread09.SCLSet = SCLSet
  thread09.SCVSet = SCVSet
  thread09.PlayerRef = PlayerRef
  thread09.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread09.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread09.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )

  thread10 = GetNthAlias(9) as SCVAnimationThread
  thread10.SCVLib = SCVLib
  thread10.SCLSet = SCLSet
  thread10.SCVSet = SCVSet
  thread10.PlayerRef = PlayerRef
  thread10.RegisterForModEvent("SCV_AnimationPrepEvent", "OnAnimPrep" )
  thread10.RegisterForModEvent("SCV_AnimationStartEvent", "OnAnimStart" )
  thread10.RegisterForModEvent("SCV_AnimationCancelEvent", "OnAnimCancel" )
EndFunction


Int Function GetStage()
  Maintenence()
  Return Parent.getStage()
EndFunction

Int Function queueAnimEvent(Actor[] akActors, String asType, String asSituation)
  ;We need to make this asynchronous yet still be able to send the event on command.
  Int OpenThreadID = getOpenThreadID()
  ;Note("queueAnimEvent Called. Open Thread = " + OpenThreadID)
  SCVAnimationThread OpenThread = getThread(OpenThreadID)
  OpenThread.setThread(akActors, asType, asSituation)
  sendPrepEvent(OpenThreadID)
  Return OpenThreadID
EndFunction

Function sendPrepEvent(Int ThreadID)
  ;Note("Sending Prep Event")
  Int Handle = ModEvent.Create("SCV_AnimationPrepEvent")
  ModEvent.pushInt(Handle, ThreadID)
  ModEvent.Send(Handle)
  ;/If Handle
  EndIf/;
EndFunction

Function sendStartEvent(Int ThreadID)
  ;Note("Sending Start Event")
  Int Handle = ModEvent.Create("SCV_AnimationStartEvent")
  ModEvent.pushInt(Handle, ThreadID)
  ModEvent.Send(Handle)
  ;/If Handle
EndIf/;
EndFunction

Function sendCancelEvent(Int ThreadID)
  ;Note("Sending Cancel Event")
  Int Handle = ModEvent.Create("SCV_AnimationCancelEvent")
  ModEvent.pushInt(Handle, ThreadID)
  ModEvent.Send(Handle)
  ;/If Handle
  EndIf/;
EndFunction

 SCVAnimationThread Function getThread(Int aiID)
   Alias FoundAlias = GetNthAlias(aiID - 1)
   ;Note("getThread Found Alias: " + FoundAlias as Bool + ", ReferenceAlias: " + (FoundAlias as ReferenceAlias) as Bool + ", Alias Cast: " +(FoundAlias as SCVAnimationThread) as Bool)
   Return GetNthAlias(aiID - 1) as SCVAnimationThread
EndFunction

Int Function getOpenThreadID()
  Int Future
  While !Future
    If !thread01.queued()
      Future = 1
    ElseIf !thread02.queued()
      Future = 2
    ElseIf !thread03.queued()
      Future = 3
    ElseIf !thread04.queued()
      Future = 4
    ElseIf !thread05.queued()
      Future = 5
    ElseIf !thread06.queued()
      Future = 6
    ElseIf !thread07.queued()
      Future = 7
    ElseIf !thread08.queued()
      Future = 8
    ElseIf !thread09.queued()
      Future = 9
    ElseIf !thread10.queued()
      Future = 10
    Else
      begin_waiting()
    EndIf
  EndWhile
  Return Future
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

;/Animation array: JMaps
  "PrimaryActor" Int containing which actor will the others move to (usually 0 or 1)
  "AnimEventInfo" JIntMap of JMaps
    "AnimEventName" String containing animation event
    "X" Float, Positions and rotations that the actor should be relative to primary
    "Y"
    "Z"

  "AnimTimers"
    JIntMap (actor one is (final) pred, two and above are prey)
      JArray of JMaps
        "Time" = seconds until next event (First event will always fire at start)
        "BoneScales" = JMap of bones and float values to be altered
        "Bodymorphs" = JMap of bodymorphs and float values to be altered/;
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
