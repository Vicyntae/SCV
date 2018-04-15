ScriptName SCVProcessPreyThreadManager Extends Quest

Quest Property SCV_ProcessPreyQuest Auto
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Actor Property PlayerRef Auto
SCVProcessPreyThread01 thread01
SCVProcessPreyThread02 thread02
SCVProcessPreyThread03 thread03
SCVProcessPreyThread04 thread04
SCVProcessPreyThread05 thread05
SCVProcessPreyThread06 thread06
SCVProcessPreyThread07 thread07
SCVProcessPreyThread08 thread08
SCVProcessPreyThread09 thread09
SCVProcessPreyThread10 thread10
SCVProcessPreyThread11 thread11
SCVProcessPreyThread12 thread12
SCVProcessPreyThread13 thread13
SCVProcessPreyThread14 thread14
SCVProcessPreyThread15 thread15
SCVProcessPreyThread16 thread16
SCVProcessPreyThread17 thread17
SCVProcessPreyThread18 thread18
SCVProcessPreyThread19 thread19
SCVProcessPreyThread20 thread20
Event OnInit()
  SCLibrary.addToReloadList(Self)

  thread01 = SCV_ProcessPreyQuest as SCVProcessPreyThread01
  thread01.SCVLib = SCVLib
  thread01.SCLSet = SCLSet
  thread01.SCVSet = SCVSet
  thread01.PlayerRef = PlayerRef
  thread01.ThreadID = 1


  thread02 = SCV_ProcessPreyQuest as SCVProcessPreyThread02
  thread02.SCVLib = SCVLib
  thread02.SCLSet = SCLSet
  thread02.SCVSet = SCVSet
  thread02.PlayerRef = PlayerRef
  thread02.ThreadID = 2


  thread03 = SCV_ProcessPreyQuest as SCVProcessPreyThread03
  thread03.SCVLib = SCVLib
  thread03.SCLSet = SCLSet
  thread03.SCVSet = SCVSet
  thread03.PlayerRef = PlayerRef
  thread03.ThreadID = 3


  thread04 = SCV_ProcessPreyQuest as SCVProcessPreyThread04
  thread04.SCVLib = SCVLib
  thread04.SCLSet = SCLSet
  thread04.SCVSet = SCVSet
  thread04.PlayerRef = PlayerRef
  thread04.ThreadID = 4


  thread05 = SCV_ProcessPreyQuest as SCVProcessPreyThread05
  thread05.SCVLib = SCVLib
  thread05.SCLSet = SCLSet
  thread05.SCVSet = SCVSet
  thread05.PlayerRef = PlayerRef
  thread05.ThreadID = 5


  thread06 = SCV_ProcessPreyQuest as SCVProcessPreyThread06
  thread06.SCVLib = SCVLib
  thread06.SCLSet = SCLSet
  thread06.SCVSet = SCVSet
  thread06.PlayerRef = PlayerRef
  thread06.ThreadID = 6


  thread07 = SCV_ProcessPreyQuest as SCVProcessPreyThread07
  thread07.SCVLib = SCVLib
  thread07.SCLSet = SCLSet
  thread07.SCVSet = SCVSet
  thread07.PlayerRef = PlayerRef
  thread07.ThreadID = 7


  thread08 = SCV_ProcessPreyQuest as SCVProcessPreyThread08
  thread08.SCVLib = SCVLib
  thread08.SCLSet = SCLSet
  thread08.SCVSet = SCVSet
  thread08.PlayerRef = PlayerRef
  thread08.ThreadID = 8


  thread09 = SCV_ProcessPreyQuest as SCVProcessPreyThread09
  thread09.SCVLib = SCVLib
  thread09.SCLSet = SCLSet
  thread09.SCVSet = SCVSet
  thread09.PlayerRef = PlayerRef
  thread09.ThreadID = 9


  thread10 = SCV_ProcessPreyQuest as SCVProcessPreyThread10
  thread10.SCVLib = SCVLib
  thread10.SCLSet = SCLSet
  thread10.SCVSet = SCVSet
  thread10.PlayerRef = PlayerRef
  thread10.ThreadID = 10

  thread11 = SCV_ProcessPreyQuest as SCVProcessPreyThread11
  thread11.SCVLib = SCVLib
  thread11.SCLSet = SCLSet
  thread11.SCVSet = SCVSet
  thread11.PlayerRef = PlayerRef
  thread11.ThreadID = 11


  thread12 = SCV_ProcessPreyQuest as SCVProcessPreyThread12
  thread12.SCVLib = SCVLib
  thread12.SCLSet = SCLSet
  thread12.SCVSet = SCVSet
  thread12.PlayerRef = PlayerRef
  thread12.ThreadID = 12


  thread13 = SCV_ProcessPreyQuest as SCVProcessPreyThread13
  thread13.SCVLib = SCVLib
  thread13.SCLSet = SCLSet
  thread13.SCVSet = SCVSet
  thread13.PlayerRef = PlayerRef
  thread13.ThreadID = 13


  thread14 = SCV_ProcessPreyQuest as SCVProcessPreyThread14
  thread14.SCVLib = SCVLib
  thread14.SCLSet = SCLSet
  thread14.SCVSet = SCVSet
  thread14.PlayerRef = PlayerRef
  thread14.ThreadID = 14


  thread15 = SCV_ProcessPreyQuest as SCVProcessPreyThread15
  thread15.SCVLib = SCVLib
  thread15.SCLSet = SCLSet
  thread15.SCVSet = SCVSet
  thread15.PlayerRef = PlayerRef
  thread15.ThreadID = 15


  thread16 = SCV_ProcessPreyQuest as SCVProcessPreyThread16
  thread16.SCVLib = SCVLib
  thread16.SCLSet = SCLSet
  thread16.SCVSet = SCVSet
  thread16.PlayerRef = PlayerRef
  thread16.ThreadID = 16


  thread17 = SCV_ProcessPreyQuest as SCVProcessPreyThread17
  thread17.SCVLib = SCVLib
  thread17.SCLSet = SCLSet
  thread17.SCVSet = SCVSet
  thread17.PlayerRef = PlayerRef
  thread17.ThreadID = 17


  thread18 = SCV_ProcessPreyQuest as SCVProcessPreyThread18
  thread18.SCVLib = SCVLib
  thread18.SCLSet = SCLSet
  thread18.SCVSet = SCVSet
  thread18.PlayerRef = PlayerRef
  thread18.ThreadID = 18


  thread19 = SCV_ProcessPreyQuest as SCVProcessPreyThread19
  thread19.SCVLib = SCVLib
  thread19.SCLSet = SCLSet
  thread19.SCVSet = SCVSet
  thread19.PlayerRef = PlayerRef
  thread19.ThreadID = 19


  thread20 = SCV_ProcessPreyQuest as SCVProcessPreyThread20
  thread20.SCVLib = SCVLib
  thread20.SCLSet = SCLSet
  thread20.SCVSet = SCVSet
  thread20.PlayerRef = PlayerRef
  thread20.ThreadID = 20


  Maintenence()
EndEvent

Int Function GetStage()
  Maintenence()
  Return Parent.GetStage()
EndFunction

Function Maintenence()
  thread01.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread02.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread03.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread04.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread05.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread06.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread07.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread08.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread09.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread10.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread11.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread12.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread13.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread14.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread15.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread16.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread17.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread18.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread19.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
  thread20.RegisterForModEvent("SCV_OnProcessPreyThread", "OnProcessPreyCall")
EndFunction

Function ProcessPreyAsync(Actor akTarget)
  Int Future
  While !Future
    if !thread01.queued()
      thread01.setThread(akTarget)
      Future = 1
    ElseIf !thread02.queued()
      thread02.setThread(akTarget)
      Future = 2
    ElseIf !thread03.queued()
      thread03.setThread(akTarget)
      Future = 3
    ElseIf !thread04.queued()
      thread04.setThread(akTarget)
      Future = 4
    ElseIf !thread05.queued()
      thread05.setThread(akTarget)
      Future = 5
    ElseIf !thread06.queued()
      thread06.setThread(akTarget)
      Future = 6
    ElseIf !thread07.queued()
      thread07.setThread(akTarget)
      Future = 7
    ElseIf !thread08.queued()
      thread08.setThread(akTarget)
      Future = 8
    ElseIf !thread09.queued()
      thread09.setThread(akTarget)
      Future = 9
    ElseIf !thread10.queued()
      thread10.setThread(akTarget)
      Future = 10
    Elseif !thread11.queued()
      thread11.setThread(akTarget)
      Future = 11
    ElseIf !thread12.queued()
      thread12.setThread(akTarget)
      Future = 12
    ElseIf !thread13.queued()
      thread13.setThread(akTarget)
      Future = 13
    ElseIf !thread14.queued()
      thread14.setThread(akTarget)
      Future = 14
    ElseIf !thread15.queued()
      thread15.setThread(akTarget)
      Future = 15
    ElseIf !thread16.queued()
      thread16.setThread(akTarget)
      Future = 16
    ElseIf !thread17.queued()
      thread17.setThread(akTarget)
      Future = 17
    ElseIf !thread18.queued()
      thread18.setThread(akTarget)
      Future = 18
    ElseIf !thread19.queued()
      thread19.setThread(akTarget)
      Future = 19
    ElseIf !thread20.queued()
      thread10.setThread(akTarget)
      Future = 20
    Else
      begin_waiting()
    EndIf
  EndWhile
  RaiseEvent_OnProcessPreyThread(Future)
EndFunction

;/Function wait_all()
  RaiseEvent_OnItemAddCall()
  begin_waiting()
EndFunction/;

Function RaiseEvent_OnProcessPreyThread(Int aiFuture)
  Int handle = ModEvent.Create("SCV_OnProcessPreyThread")
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
      thread06.queued() || thread07.queued() || thread08.queued() || thread09.queued() || thread10.queued() || \
      thread11.queued() || thread12.queued() || thread13.queued() || thread14.queued() || thread15.queued() || \
        thread16.queued() || thread17.queued() || thread18.queued() || thread19.queued() || thread20.queued()
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
