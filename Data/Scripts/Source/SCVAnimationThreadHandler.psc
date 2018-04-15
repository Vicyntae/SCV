ScriptName SCVAnimationThreadHandlerNOTDONE Extends Quest
;/Animation entry format
.SCLExtraData.SCVAnimations (JMap)
;Vital Info:
  RacexRace
  ScalexScale
  Combat/NonCombat/Friendly/Stealth
  Type
Non-Vital Info:
/;

Quest Property SCV_AnimationQuest Auto
SCVAnimationThread01 thread01
SCVAnimationThread02 thread02
SCVAnimationThread03 thread03
SCVAnimationThread04 thread04
SCVAnimationThread05 thread05
SCVAnimationThread06 thread06
SCVAnimationThread07 thread07
SCVAnimationThread08 thread08
SCVAnimationThread09 thread09
SCVAnimationThread10 thread10

Int EventID

Event OnInit()
  SCLibrary.addToReloadList(Self)

  thread01 = SCV_AnimationQuest as SCVAnimationThread01
  thread01.SCVLib = SCVLib
  thread01.SCLSet = SCLSet
  thread01.SCVSet = SCVSet
  thread01.PlayerRef = PlayerRef
  thread01.ThreadID = 1


  thread02 = SCV_AnimationQuest as SCVAnimationThread02
  thread02.SCVLib = SCVLib
  thread02.SCLSet = SCLSet
  thread02.SCVSet = SCVSet
  thread02.PlayerRef = PlayerRef
  thread02.ThreadID = 2


  thread03 = SCV_AnimationQuest as SCVAnimationThread03
  thread03.SCVLib = SCVLib
  thread03.SCLSet = SCLSet
  thread03.SCVSet = SCVSet
  thread03.PlayerRef = PlayerRef
  thread03.ThreadID = 3


  thread04 = SCV_AnimationQuest as SCVAnimationThread04
  thread04.SCVLib = SCVLib
  thread04.SCLSet = SCLSet
  thread04.SCVSet = SCVSet
  thread04.PlayerRef = PlayerRef
  thread04.ThreadID = 4


  thread05 = SCV_AnimationQuest as SCVAnimationThread05
  thread05.SCVLib = SCVLib
  thread05.SCLSet = SCLSet
  thread05.SCVSet = SCVSet
  thread05.PlayerRef = PlayerRef
  thread05.ThreadID = 5


  thread06 = SCV_AnimationQuest as SCVAnimationThread06
  thread06.SCVLib = SCVLib
  thread06.SCLSet = SCLSet
  thread06.SCVSet = SCVSet
  thread06.PlayerRef = PlayerRef
  thread06.ThreadID = 6


  thread07 = SCV_AnimationQuest as SCVAnimationThread07
  thread07.SCVLib = SCVLib
  thread07.SCLSet = SCLSet
  thread07.SCVSet = SCVSet
  thread07.PlayerRef = PlayerRef
  thread07.ThreadID = 7


  thread08 = SCV_AnimationQuest as SCVAnimationThread08
  thread08.SCVLib = SCVLib
  thread08.SCLSet = SCLSet
  thread08.SCVSet = SCVSet
  thread08.PlayerRef = PlayerRef
  thread08.ThreadID = 8


  thread09 = SCV_AnimationQuest as SCVAnimationThread09
  thread09.SCVLib = SCVLib
  thread09.SCLSet = SCLSet
  thread09.SCVSet = SCVSet
  thread09.PlayerRef = PlayerRef
  thread09.ThreadID = 9


  thread10 = SCV_AnimationQuest as SCVAnimationThread10
  thread10.SCVLib = SCVLib
  thread10.SCLSet = SCLSet
  thread10.SCVSet = SCVSet
  thread10.PlayerRef = PlayerRef
  thread10.ThreadID = 10
  Maintenence()
EndEvent


Int Function GetStage()
  EventID = 0
  clearAllThreads()
  Return Parent.getStage()
EndFunction

Int Function queueAnimEvent(Actor[] akActors, String asType, String asSituation)
  ;We need to make this asynchronous yet still be able to send the event on command.
  Int i = 0
  Int NumActors = akActors.Length
  Int AnimEntry = getRandomAnim(akActors[0], akActors[1], asType, asSituation)
  If !AnimEntry
    Return -1
  EndIf
  Int ReturnEvent = EventID
  EventID += 1
  While i < NumActors
    Int OpenThreadID = getOpenThreadID()
    SCVAnimationThread OpenThread = getThread(OpenThreadID)
    OpenThread.setThread(akActors[i], AnimEntry, aiActorID)
    OpenThread.RegisterForModEvent("SCVAnimThreadStart" + ReturnEvent, "OnAnimStart")
    i += 1
  EndWhile
  Return ReturnEvent
EndFunction

Function getThread(Int aiID)
  If aiID == 1
    Return thread01
  ElseIf aiID == 2
    Return thread02
  ElseIf aiID == 3
    Return thread03
  ElseIf aiID == 4
    Return thread04
  ElseIf aiID == 5
    Return thread05
  ElseIf aiID == 6
    Return thread06
  ElseIf aiID == 7
    Return thread07
  ElseIf aiID == 8
    Return thread08
  ElseIf aiID == 9
    Return thread09
  ElseIf aiID == 10
    Return thread10
  Else
    Return None
  EndIf
EndFunction

Function getOpenThreadID()
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

Int Function getRandomAnim(Actor akPred, Actor akPrey1, String asType, String asSituation)
  Int JA_AnimArray = getAnimationArray(akPred, akPrey1, asType, asSituation)
  If !JA_AnimArray
    JA_AnimArray= getDefaultAnimArray(akPred, akPrey1)
  EndIf
  Int i = Utility.RandomInt(0, JArray.count(JA_AnimArray) - 1)
  Return JArray.getObj(JA_AnimArray, i)
EndFunction

Function startAnimEvent(Int aiEventID)
  If aiEventID >= 0
    Int StartEvent = ModEvent.Create("SCVAnimThreadStart" + aiEventID)
    ModEvent.Send(StartEvent)
  EndIf
EndFunction

Function getDefaultAnimArray(Actor akPred, Actor akPrey)
  String PredRace
  Race PDRace = akPred.GetRace()
  If PDRace.HasKeyword(ActorTypeNPC)
    PredRace == "Human"
  ElseIf PDRace == WolfRace || PDRace = SnowWolfRace
    PredRace == "Wolf"
  EndIf
  If PredRace == "Human"
    Return JDB.solveObj(".SCLExtraData.SCVAnimations.SCVHumanDefault")
  ;ElseIf PredRace == "Wolf"
    ;Return JDB.solveObj(".SCLExtraData.SCVAnimations.SCVWolfDefault")
  EndIf
EndFunction


Int Function getAnimationArray(Actor akPred, Actor akPrey, String asType, String asSituation)
  String PredRace
  Race PDRace = akPred.GetRace()
  If PDRace.HasKeyword(ActorTypeNPC)
    PredRace == "Human"
  ElseIf PDRace == WolfRace || PDRace = SnowWolfRace
    PredRace == "Wolf"
  EndIf
  ;Same for prey

  String Scale
  Float PredScale = akPred.GetScale() * NetImmerse.GetNodeScale(akPred, "NPC Root [Root]", False)
  Float PreyScale = akPrey.GetScale() * NetImmerse.GetNodeScale(akPrey, "NPC Root [Root]", False)
  Float FinalScale = PredScale / PreyScale
  If FinalScale > 0.8 && FinalScale < 1.2
    Scale = "Size0"
  ElseIf FinalScale > 0.6 && FinalScale < 0.8
    Scale = "Size-1"
  ElseIf FinalScale > 0.4 && FinalScale < 0.6
    Scale = "Size-2"
  ElseIf FinalScale > 0.2 && FinalScale < 0.4
    Scale = "Size-3"
  ElseIf FinalScale < 0.2
    Scale = "Size-4"
  ElseIf FinalScale > 1.2 && FinalScale < 1.4
    Scale = "Size1"
  ElseIf FinalScale > 1.4 && FinalScale < 1.6
    Scale = "Size2"
  ElseIf FinalScale > 1.6 && FinalScale < 1.8
    Scale = "Size3"
  ElseIf FinalScale > 1.8 && FinalScale < 2
    Scale = "Size4"
    ;And so on
  Else
    Scale = "Size0"
  EndIf

  Return JDB.solveObj(".SCLExtraData.SCVAnimations." + asType + "." + PredRace + "." + PreyRace + "." + Scale + "." + asSituation)
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
        "Bodymorphs" = JMap of bodymorphs and float values to be altered
