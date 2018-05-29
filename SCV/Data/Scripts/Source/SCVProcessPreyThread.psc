ScriptName SCVProcessPreyThread Extends Quest Hidden
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
String Property DebugName
  String Function Get()
    Return "[SCVProcessPreyThread" + ThreadID + "] "
  EndFunction
EndProperty
Int DMID = 9
Actor Property PlayerRef Auto

Bool thread_queued = False
Actor MyActor
Int ActorData
SCLPerkBase Constriction
SCLPerkBase Acid
SCLPerkBase ThrillingStruggle
SCLPerkBase CorneredRat
Int Property ThreadID Auto

Function setThread(Actor akTarget)
  thread_queued = True

  MyActor = akTarget
  ActorData = SCVLib.getTargetData(MyActor)
  Constriction = SCVLib.getPerkForm("SCV_Constriction")
  Acid = SCVLib.getPerkForm("SCV_Acid")
  ThrillingStruggle = SCVLib.getPerkForm("SCV_ThrillingStruggle")
  CorneredRat = SCVLib.getPerkForm("SCV_CorneredRat")

EndFunction

Bool Function queued()
  return thread_queued
EndFunction

Bool Function force_unlock()
  clear_thread_vars()
  thread_queued = False
  Return True
EndFunction

Event OnProcessPreyCall(Int aiID)
  If thread_queued && aiID == ThreadID
    updateStruggle(MyActor, aiTargetData = ActorData)
    performStruggle(MyActor, ActorData)
    clear_thread_vars()
    thread_queued = False
  EndIf
EndEvent

Function updateStruggle(Actor akTarget, Int aiHigherStruggle = 0, Int aiHigherDamage = 0, Int aiTargetData = 0)
  {Recursive function, checks pred and all prey for how much damage is done.}
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  Int Contents = SCVLib.getContents(akTarget, 8, TargetData)
  Int PredStruggleLevel = Constriction.getFirstPerkLevel(akTarget) + 1
  Int PredDamageLevel = Acid.getFirstPerkLevel(akTarget)
  Int TotalPreyStruggle = aiHigherStruggle
  Int TotalPreyDamage = aiHigherDamage
  Form i = JFormMap.nextKey(Contents) as Form
  While i
    If i as ObjectReference
      If i as Actor
        Actor akActor = i as Actor
        Int PreyData = SCVLib.getTargetData(akActor)
        Int StruggleAdd
        Int DamageAdd
        If PreyData
          StruggleAdd = ThrillingStruggle.getFirstPerkLevel(akActor)
          DamageAdd = CorneredRat.getFirstPerkLevel(akActor)
        Else
          StruggleAdd = 10
        EndIf
        If !StruggleAdd
          StruggleAdd = 10
        EndIf
        TotalPreyStruggle += StruggleAdd
        TotalPreyDamage += DamageAdd
        updateStruggle(akActor, PredStruggleLevel, PredDamageLevel, PreyData)
      EndIf
    EndIf
    i = JFormMap.nextKey(Contents, i) as Form
  EndWhile

  If akTarget.Is3DLoaded() || akTarget == PlayerRef
    SCVLib.setProxy(akTarget, "Health", akTarget.GetActorValue("Health"))
    SCVLib.setProxy(akTarget, "Stamina", akTarget.GetActorValue("Stamina"))
    SCVLib.setProxy(akTarget, "Magicka", akTarget.GetActorValue("Magicka"))
  EndIf

  JMap.setInt(TargetData, "SCV_StruggleRank", TotalPreyStruggle)
  ;Note(SCVLib.nameGet(akTarget) + " struggle rank = " + TotalPreyStruggle)
  JMap.setInt(TargetData, "SCV_DamageRank", TotalPreyDamage)
  ;Note(SCVLib.nameGet(akTarget) + " damage rank = " + TotalPreyDamage)
EndFunction

Function performStruggle(Actor akTarget, Int aiTargetData = 0)
  {Recursive function, deals struggle damage to predator and all prey within them}
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  Int Struggle = JMap.getInt(TargetData, "SCV_StruggleRank")
  Int Damage = JMap.getInt(TargetData, "SCV_DamageRank")
  Bool MagicPerk = SCVLib.getCurrentPerkLevel(akTarget, "SCV_StruggleSorcery")
  ;Note(SCVLib.nameGet(akTarget) + " stamina proxy = " + SCVLib.getProxy(akTarget, "Stamina") + "/" + SCVLib.getProxyBase(akTarget, "Stamina") + ", " + SCVLib.getProxyPercent(akTarget, "Stamina"))
  If Struggle
    Float SMod = SCVSet.StruggleMod
    If MagicPerk
      Float MReduce = 1 - (SCVLib.getTotalPerkLevel(akTarget, "SCV_StruggleSorcery") / 100)
      akTarget.DamageActorValue("Stamina", Struggle* SMod / 2)
      akTarget.DamageActorValue("Magicka", (Struggle* SMod / 2) * MReduce)
      SCVLib.modProxy(akTarget, "Stamina", -(Struggle * SMod / 2))
      SCVLib.modProxy(akTarget, "Magicka", -((Struggle * SMod / 2) * MReduce))
    Else
      akTarget.DamageActorValue("Stamina", Struggle * SMod)
      SCVLib.modProxy(akTarget, "Stamina", -(Struggle * SMod))
    EndIf
  EndIf
  If Damage
    Float DMod = SCVSet.DamageMod
    akTarget.DamageActorValue("Health", Damage * DMod)
    SCVLib.modProxy(akTarget, "Health", -(Damage * DMod))
  EndIf
  Float Stamina = akTarget.GetActorValuePercentage("Stamina")
  Float StaminaProxy = SCVLib.getProxyPercent(akTarget, "Stamina")
  If SCVLib.isInPred(akTarget, TargetData)
    SCVLib.giveResExp(akTarget, Struggle + Damage, TargetData)
  EndIf
  If akTarget.Is3DLoaded() || akTarget == PlayerRef
    If akTarget.IsDead()
      SCVLib.handleFinishedActor(akTarget)
    ElseIf Stamina <= 0.05
      Float Magicka = akTarget.GetActorValuePercentage("Magicka")
      If !MagicPerk || Magicka <= 0.05
        Notice("Actor is exhausted! Handling finished actor.")
        SCVLib.handleFinishedActor(akTarget)
      EndIf
    EndIf
  Else
    If SCVLib.getProxy(akTarget, "Health") <= 0
      akTarget.Kill(SCVLib.getPred(akTarget))
      SCVLib.handleFinishedActor(akTarget)
    ElseIf StaminaProxy <= 0.05
      Float MagickaProxy = SCVLib.getProxyPercent(akTarget, "Magicka")
      If !MagicPerk || MagickaProxy <= 0.05
        SCVLib.handleFinishedActor(akTarget)
      EndIf
    EndIf
  EndIf

  Int Contents = SCVLib.getContents(akTarget, 8, TargetData)
  Actor i = JFormMap.nextKey(Contents) as Actor
  While i
    performStruggle(i)
    i = JFormMap.nextKey(Contents, i) as Actor
  EndWhile
EndFunction

Function clear_thread_vars()
  MyActor = None
  ActorData = 0
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
