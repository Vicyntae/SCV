ScriptName SCVModEventManager Extends Quest
String DebugName = "[SCVEvent] "
Int DMID = 8
Function _CheckVersion()
EndFunction

Bool SCLResetted = False
Event OnSCLReset()
  SCLResetted = True
EndEvent

SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto
SCLSettings Property SCLSet Auto
Actor Property PlayerRef Auto

Event OnInit()
  Maintenence()
  SCLibrary.addToReloadList(self)
EndEvent

Function Maintenence()
  RegisterForModEvent("SCLActorMainMenuOpen8", "OnActorMainMenuOpen")
  RegisterForModEvent("SCV_StruggleFinish", "OnStruggleFinish")
  RegisterForModEvent("SCLDigestFinishEvent", "OnDigestFinish")
  RegisterForModEvent("SCLDigestItemFinishEvent", "OnDigestItemFinish")
  RegisterForModEvent("SCLVomitEvent", "OnVomit")
  RegisterForModEvent("SCLActorRemove", "OnActorRemove")
  RegisterForModEvent("SCLReset", "OnSCLReset")
  _CheckVersion()
EndFunction

Int Function GetStage()
  Notice("Reload Maintenence")
  If SCLResetted
    Notice("SCL has been reset!")
    ;Stuff Here
    SCLResetted = False
  EndIf
  Maintenence()
  Return Parent.GetStage()
EndFunction

;*******************************************************************************
;Actor Main Menu Events
;*******************************************************************************
Event OnActorMainMenuOpen(Form akTarget, Int aiMode)
  If akTarget as Actor
    Notice("OnActorMainMenuOpen recieved! Sending ")
    SCVLib.showActorMainMenu(akTarget as Actor, aiMode)
  EndIf
EndEvent

;*******************************************************************************
;Digestion Events
;*******************************************************************************

Function checkNourishAbility(Actor akTarget)
  Int TargetData = SCVLib.getData(akTarget)
  If SCVlib.hasPreyType(akTarget, 1, TargetData)
    Int PerkRank = SCVLib.getTotalPerkLevel(akTarget, "SCV_Nourish")
    If PerkRank == 0
      Return
    EndIf
    If PerkRank > SCVSet.NourishArray.length - 1
      PerkRank = SCVSet.NourishArray.length - 1
    EndIf
    Int Current = SCVLib.getCurrentNourish(akTarget, TargetData)
    If Current != PerkRank
      SCVSet.NourishArray[PerkRank].cast(akTarget)
      JMap.setInt(TargetData, "SCV_AppliedNourishTier", PerkRank)
    EndIf
  Else
    SCVSet.NourishArray[0].cast(akTarget)
    JMap.setInt(TargetData, "SCV_AppliedNourishTier", 0)
  EndIf
EndFunction

Event OnStruggleFinish(Form akPred, Form akPrey, Int aiItemType)
  If aiItemType == 1
    If akPred as Actor
      checkNourishAbility(akPred as Actor)
    EndIf
  EndIf
EndEvent

Event OnDigestFinish(Form akEater, Float afDigestedAmount)
  If akEater as Actor
    checkNourishAbility(akEater as Actor)
  EndIf
EndEvent

Event OnVomit(Form akTarget, Int aiVomitType, Bool bLeveledRemains, Form akSpecificItem)
  If akTarget as Actor
    checkNourishAbility(akTarget as Actor)
  EndIf
EndEvent

Event OnActorRemove(Form akSource, Form akActor, Int aiItemType)
  If akActor as Actor
    Actor akTarget = akActor as Actor
    Float StaminaProxy = SCVLib.getProxy(akTarget, "Stamina")
    Float RealStamina = akTarget.GetActorValue("Stamina")
    If RealStamina < StaminaProxy
      akTarget.RestoreActorValue("Stamina", StaminaProxy - RealStamina)
    ElseIf RealStamina > StaminaProxy
      akTarget.DamageActorValue("Stamina", RealStamina - StaminaProxy)
    EndIf

    Float MagickaProxy = SCVLib.getProxy(akTarget, "Magicka")
    Float RealMagicka = akTarget.GetActorValue("Magicka")
    If RealMagicka < MagickaProxy
      akTarget.RestoreActorValue("Magicka", MagickaProxy - RealMagicka)
    ElseIf RealMagicka > MagickaProxy
      akTarget.DamageActorValue("Magicka", RealStamina - MagickaProxy)
    EndIf

    Float HealthProxy = SCVLib.getProxy(akTarget, "Health")
    Float RealHealth = akTarget.GetActorValue("Health")
    If RealHealth < HealthProxy
      akTarget.RestoreActorValue("Health", HealthProxy - RealHealth)
    ElseIf RealHealth > HealthProxy
      akTarget.DamageActorValue("Health", RealHealth - HealthProxy)
    EndIf

    If akTarget == PlayerRef
      SCVSet.SCV_FollowPred.Clear()
    EndIf
  EndIf
EndEvent

Event OnDigestItemFinish(Form akEater, Form akFood)
  If akFood as Actor && akEater as Actor
    SCVLib.transferInventory(akEater as Actor, akFood as Actor, 1)
    SCVLib.transferSCLItems(akEater as Actor, akFood as Actor, 1)
    If SCVLib.hasGems(akEater as Actor)
      ;Note("Digest Finished and pred has gems! Filling Gem.")
      SCVLib.fillGem(akEater as Actor, akFood as Actor)
    EndIf

    If SCVSet.SizeMatters_Initialized && SCVSet.SizeMattersActive
      Int Nourish = SCVLib.getTotalPerkLevel(akEater as Actor, "SCV_Nourish")
      If Nourish
        Float NModify = 1 + ((Nourish - 1) / 10)
        Float DigestValue = SCVLib.genDigestValue(akFood as Actor)
        DigestValue /= 100
        DigestValue *= NModify

        If akEater == PlayerRef
          gtsPlayerFunctions PF = Game.GetFormFromFile(0x0201665B, "GTS.esp") as gtsPlayerFunctions
          PlayerRef.ModActorValue("FavorActive", DigestValue)
          Float CurrentSize = PF.GetCurrentSize()
          Float NewSize = PF.GetMaxSize(PF.GetRawRequirementFromSize(CurrentSize) + DigestValue)
          PF.ScaleActor(NewSize, CurrentSize)
        Else
          gtsNPCFunctions NF = Game.GetFormFromFile(0x0201665B, "GTS.esp") as gtsNPCFunctions
          (akEater as Actor).ModActorValue("FavorActive", DigestValue)
          Float CurrentSize = NF.GetCurrentSize(akEater as Actor)
          Float NewSize = NF.GetMaxSize(akEater as Actor, NF.GetRawRequirementFromSize(CurrentSize) + DigestValue)
          NF.ScaleActor(akEater as Actor, NewSize, CurrentSize)
        EndIf
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
