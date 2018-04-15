ScriptName SCVInsertPreyThread Extends Quest Hidden

SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
String Property DebugName
  String Function Get()
    Return "[SCVInsertPredThread" + ThreadID + "] "
  EndFunction
EndProperty
Int DMID = 9
Actor Property PlayerRef Auto

Bool thread_queued = False
Actor Pred
Int PredData
Actor Prey
Int PreyData
Int ItemType
Bool Friendly
Bool PlayAnimationNow

Int Property ThreadID Auto
Int Result
Bool thread_ready

Int Function getResultEntry()
  thread_ready = False
  thread_queued = False
  Return Result
EndFunction

Actor Function getPred()
  Return Pred
EndFunction

Actor Function getPrey()
  Return Prey
EndFunction

Function setThread(Actor akPred, Actor akPrey, Int aiItemType, Bool abFriendly, Bool abPlayAnimation)
  thread_queued = True

  Pred = akPred
  PredData = SCVLib.getTargetData(Pred, True)
  Prey = akPrey
  PreyData = SCVLib.getTargetData(Prey, True)
  ItemType = aiItemType
  Friendly = abFriendly
  PlayAnimationNow = abPlayAnimation
EndFunction

Bool Function queued()
  return thread_queued
EndFunction

Bool Function isReady()
  Return thread_ready
EndFunction

Bool Function force_unlock()
  clear_thread_vars()
  thread_queued = False
  thread_ready = False
  Return True
EndFunction

Event OnInsertPreyCall(Int aiID)
  If thread_queued && aiID == ThreadID
    Int JM_PreyEntry
    Notice("Prey insertion commencing. Pred = " + nameGet(Pred) + ", Prey = " + nameGet(Prey) + ", Item Type = " + ItemType)
    If SCVSet.SCV_InVoreActionList.HasForm(Pred) || SCVSet.SCV_InVoreActionList.HasForm(Prey)
      While SCVSet.SCV_InVoreActionList.HasForm(Pred) || SCVSet.SCV_InVoreActionList.HasForm(Prey)
        Utility.Wait(0.5)
      EndWhile
    EndIf
    SCVLib.PauseFollowPred()
    SCVSet.SCV_InVoreActionList.AddForm(Pred)
    SCVSet.SCV_InVoreActionList.AddForm(Prey)
    ;Play animation here
    If Pred == PlayerRef
      If (ItemType == 1 || ItemType == 2)
        Int Allure = SCVLib.getAllureLevel(Prey)
        If Allure >= 1
          PlayerThoughtDB(Pred, "SCVPredSwallowPositive")
        ElseIf Allure <= -1
          PlayerThoughtDB(Pred, "SCVPredSwallowNegative")
        Else
          PlayerThoughtDB(Pred, "SCVPredSwallow")
        EndIf
      ElseIf ItemType == 4 || ItemType == 6
        PlayerThoughtDB(Pred, "SCVPredTakeIn")
      EndIf
    EndIf

    If ItemType == 1 || ItemType == 2
      PlayerThoughtDB(Prey, "SCVPreySwallowed")
      Debug.Notification(nameGet(Pred) + " is eating " + nameGet(Prey) + "!")
      Pred.Say(SCVSet.SCV_SwallowSound)
    ElseIf ItemType == 4 || ItemType == 6
      PlayerThoughtDB(Prey, "SCVPreyTakenIn")
      Debug.Notification(nameGet(Pred) + " is taking in " + nameGet(Prey) + "!")
      Pred.Say(SCVSet.SCV_TakeInSound)
    EndIf

    Int iModType = ItemType
    If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
      If ItemType == 4 || ItemType == 5
        iModType = 1
      ElseIf ItemType == 6 || ItemType == 7
        iModType == 2
      EndIf
    EndIf

    Float PredStamina = Pred.GetActorValue("Stamina")
    Float PredMagicka = Pred.GetActorValue("Magicka")
    Float PredHealth = Pred.GetActorValue("Health")

    Float PredStaminaBase = Pred.GetBaseActorValue("Stamina")
    Float PredMagickaBase = Pred.GetBaseActorValue("Magicka")
    Float PredHealthBase = Pred.GetBaseActorValue("Health")

    Float PreyStamina = Prey.GetActorValue("Stamina")
    Float PreyMagicka = Prey.GetActorValue("Magicka")
    Float PreyHealth = Prey.GetActorValue("Health")

    Float PreyStaminaBase = Prey.GetBaseActorValue("Stamina")
    Float PreyMagickaBase = Prey.GetBaseActorValue("Magicka")
    Float PreyHealthBase = Prey.GetBaseActorValue("Health")

    ;Note("Prey Proxies: " + PreyStamina + "/" + PreyStaminaBase)

    If Prey.isDead() || Friendly || Prey.IsUnconscious()
      ;Notice("Prey is willing or incapacitated. Inserting directly into contents.")
      If ItemType == 1 || ItemType == 2
        If Prey == PlayerRef
          JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = iModType, abMoveNow = False)
          SCVSet.SCV_FollowPred.ForceRefTo(Pred)
        Else
          JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = iModType)
        EndIf
      ElseIf ItemType == 4 || ItemType == 6
        If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
          If Prey == PlayerRef
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = iModType, abMoveNow = False)
            SCVSet.SCV_FollowPred.ForceRefTo(Pred)
          Else
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = iModType)
          EndIf
        Else
          If Prey == PlayerRef
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = iModType, afDigestValueOverRide = 0, abMoveNow = False)
            SCVSet.SCV_FollowPred.ForceRefTo(Pred)
          Else
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = iModType, afDigestValueOverRide = 0)
          EndIf
          JMap.setFlt(JM_PreyEntry, "StoredDigestValue", SCVLib.genDigestValue(Prey, True))
        EndIf
      EndIf
    Else
      ;Notice("Prey is struggling. Inserting into struggle contents")
      If ItemType == 1 || ItemType == 2
        If Prey == PlayerRef
          JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = 8, abMoveNow = False)
          SCVSet.SCV_FollowPred.ForceRefTo(Pred)
        Else
          JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = 8)
        EndIf
        SCVLib.giveOVExp(Pred, SCVLib.getResLevel(Prey))
      ElseIf ItemType == 4 || ItemType == 6
        If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
          If Prey == PlayerRef
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = 8, abMoveNow = False)
            SCVSet.SCV_FollowPred.ForceRefTo(Pred)
          Else
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = 8)
          EndIf
        Else
          If Prey == PlayerRef
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = 8, afDigestValueOverRide = 0, abMoveNow = False)
            SCVSet.SCV_FollowPred.ForceRefTo(Pred)
          Else
            JM_PreyEntry = SCVLib.addItem(Pred, Prey, aiItemType = 8, afDigestValueOverRide = 0)
          EndIf
          JMap.setFlt(JM_PreyEntry, "StoredDigestValue", SCVLib.genDigestValue(Prey, True))
        EndIf

        SCVLib.giveAVExp(Pred, SCVLib.getResLevel(Prey))
      ;/ElseIf ItemType == 5 || ItemType == 7
        givePVEXP(Pred, getResLevel(Prey))/;
      EndIf
    EndIf

    JMap.setInt(PreyData, "SCV_NumTimesEaten", JMap.getInt(PreyData, "SCV_NumTimesEaten") + 1)
    JMap.setForm(JM_PreyEntry, "SCV_Pred", Pred)
    JMap.setForm(JMap.getObj(PreyData, "SCLTrackingData"), "SCV_Pred", Pred)
    JMap.setInt(JM_PreyEntry, "StoredItemType", ItemType)

    SCVLib.setProxy(Pred, "Stamina", PredStamina, PredData)
    SCVLib.setProxy(Pred, "Magicka", PredMagicka, PredData)
    SCVLib.setProxy(Pred, "Health", PredHealth, PredData)

    SCVLib.setProxyBase(Pred, "Stamina", PredStaminaBase, PredData)
    SCVLib.setProxyBase(Pred, "Magicka", PredMagickaBase, PredData)
    SCVLib.setProxyBase(Pred, "Health", PredHealthBase, PredData)

    SCVLib.setProxy(Prey, "Stamina", PreyStamina, PreyData)
    SCVLib.setProxy(Prey, "Magicka", PreyMagicka, PreyData)
    SCVLib.setProxy(Prey, "Health", PreyHealth, PreyData)

    SCVLib.setProxyBase(Prey, "Stamina", PreyStaminaBase, PreyData)
    SCVLib.setProxyBase(Prey, "Magicka", PreyMagickaBase, PreyData)
    SCVLib.setProxyBase(Prey, "Health", PreyHealthBase, PreyData)


    Int InsertEvent = ModEvent.Create("SCV_InsertEvent")
    ModEvent.PushForm(InsertEvent, Pred)
    ModEvent.PushForm(InsertEvent, Pred)
    ModEvent.PushInt(InsertEvent, ItemType)
    ModEvent.PushBool(InsertEvent, Friendly)
    ModEvent.Send(InsertEvent)


    SCVSet.SCV_InVoreActionList.RemoveAddedForm(Pred)
    SCVSet.SCV_InVoreActionList.RemoveAddedForm(Prey)
    SCVLib.ResumeFollowPred()
    Result = JM_PreyEntry
    SCVLib.quickUpdate(Pred, True, True)
    clear_thread_vars()
    thread_ready = True
  EndIf
EndEvent


String Function nameGet(Form akTarget)
  If akTarget as SCLBundle
    Return (akTarget as SCLBundle).ItemForm.GetName()
  ElseIf akTarget as Actor
    Return (akTarget as Actor).GetLeveledActorBase().GetName()
  ElseIf akTarget as ObjectReference
    Return (akTarget as ObjectReference).GetBaseObject().GetName()
  Else
    Return akTarget.GetName()
  EndIf
EndFunction

Function clear_thread_vars()
  Pred = None
  PredData = 0
  Prey = None
  PreyData = 0
  ItemType = 0
  Friendly = False
  PlayAnimationNow = False
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
