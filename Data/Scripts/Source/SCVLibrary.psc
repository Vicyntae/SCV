ScriptName SCVLibrary Extends SCLibrary
;*******************************************************************************
;Variables and Properties
;*******************************************************************************
;SCLibrary Property SCLib Auto
String ScriptID = "SCVLib"
SCVSettings Property SCVSet Auto

;Profile Functions *************************************************************
Int Property ActorDataVersion = 1 Auto
Function checkSCVData(Actor akTarget, Int aiTargetData)
  {Checks if data necessary for SCV has been added to ActorData}
  If !JMap.hasKey(aiTargetData, "SCV_DataVersion")
    If akTarget == PlayerRef
      JMap.setInt(aiTargetData, "SCV_IsOVPred", 0)
      JMap.setInt(aiTargetData, "SCV_OVLevel", 1)
      JMap.setInt(aiTargetData, "SCV_AVLevel", 1)
      JMap.setInt(aiTargetData, "SCV_Allure", 0)

      JMap.setInt(aiTargetData, "SCV_ResLevel", 10)
      JMap.setInt(aiTargetData, "SCV_DataVersion", ActorDataVersion)
      Return
    EndIf
    Bool bPred = False
    Bool bOVPred = False
    If SCVSet.OVPredPercent
      Int PredChance = Utility.RandomInt()
      If PredChance <= SCVSet.OVPredPercent
        JMap.setInt(aiTargetData, "SCV_IsOVPred", 1)
        bOVPred = True
        bPred = True
      EndIf
    EndIf
    Bool bAVPred = False
    If SCVSet.AVPredPercent
      Int PredChance = Utility.RandomInt()
      If PredChance <= SCVSet.AVPredPercent
        JMap.setInt(aiTargetData, "SCV_IsAVPred", 1)
        bAVPred = True
        bPred = True
      EndIf
    endIf
    Float[] Chances = genNormalDist()
    Float Chance1 = Chances[0]
    Float Chance2 = Chances[1]
    ;Changes range from +-1 to +- 30
    Chance1 = Math.abs(Chance1)
    Chance2 = Math.abs(Chance2)

    Chance1 *= 30
    Chance2 *= 30
    ;Shift mean to difficulty
    Chance1 += getPredDifficulty()
    Chance2 += getPreyDifficulty()

    clampFlt(Chance1, 1, 100)
    clampFlt(Chance2, 1, 100)

    If bPred
      If bOVPred
        JMap.setInt(aiTargetData, "SCV_OVLevel", Math.Ceiling(Chance1))
        JMap.setFlt(aiTargetData, "STBase", JMap.getFlt(aiTargetData, "STBase") + (Math.pow(2, Chance1 / 10)))
        JMap.setFlt(aiTargetData, "STDigestionRate", JMap.getFlt(aiTargetData, "STDigestionRate") + (Math.pow(1.3, Chance1 / 11) - 1))
        JMap.setInt(aiTargetData, "SCLGluttony", JMap.getInt(aiTargetData, "SCLGluttony") + Math.Ceiling(Math.Pow(2, Chance1 / 20)))
      EndIf
      If bAVPred
        JMap.setInt(aiTargetData, "SCV_AVLevel", Math.Ceiling((Chance1 + Chance2) / 2))
        If SCVSet.SCA_Initialized
          takeUpPerks(akTarget, "SCA_BasementStorage", 3)
          ;What do we need to add here?
        Else  ;Give bonus to stomach stats, since prey will be added to stomach array
          JMap.setFlt(aiTargetData, "STBase", JMap.getFlt(aiTargetData, "STBase") + (Math.pow(2, Chance1 / 10)))
          JMap.setFlt(aiTargetData, "STDigestionRate", JMap.getFlt(aiTargetData, "STDigestionRate") + (Math.pow(1.3, Chance1 / 11) - 1))
        EndIf
      EndIf

      Int PerkList = Utility.RandomInt(1000000000000, 1999999999999)
      If PerkList != 1000000000000
        initializePerk(akTarget, "SCV_IntenseHunger", StringUtil.Substring(PerkList, 1, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_MetalMuncher", StringUtil.Substring(PerkList, 2, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_ExpiredEpicurian", StringUtil.Substring(PerkList, 3, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_FollowerofNamira", StringUtil.Substring(PerkList, 4, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_DaedraDieter", StringUtil.Substring(PerkList, 5, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_DragonDevourer", StringUtil.Substring(PerkList, 6, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_Constriction", StringUtil.Substring(PerkList, 7, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_SpiritSwallower", StringUtil.Substring(PerkList, 8, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_RemoveLimits", StringUtil.Substring(PerkList, 9, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_Nourish", StringUtil.Substring(PerkList, 10, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_Acid", StringUtil.Substring(PerkList, 11, 1) as Int, Chance1)
        initializePerk(akTarget, "SCV_Stalker", StringUtil.Substring(PerkList, 12, 1) as Int, Chance1)
      EndIf
      takeUpPerks(akTarget, "SCV_FollowerofNamira", 1)
    EndIf

    JMap.setInt(aiTargetData, "SCV_ResLevel", Math.Ceiling(Chance2))
    Int PerkList = Utility.RandomInt(100000, 199999)
    If PerkList != 100000
      initializePerk(akTarget, "SCV_CorneredRat", StringUtil.Substring(PerkList, 1, 1) as Int, Chance2)
      initializePerk(akTarget, "SCV_StrokeOfLuck", StringUtil.Substring(PerkList, 2, 1) as Int, Chance2)
      initializePerk(akTarget, "SCV_ExpectPushback", StringUtil.Substring(PerkList, 3, 1) as Int, Chance2)
      initializePerk(akTarget, "SCV_FillingMeal", StringUtil.Substring(PerkList, 4, 1) as Int, Chance2)
      initializePerk(akTarget, "SCV_ThrillingStruggle", StringUtil.Substring(PerkList, 5, 1) as Int, Chance2)
    EndIf
    Int B = Utility.RandomInt(0, 10)
    Int AllureLevel
    If B <= 2
      AllureLevel = -1
    ElseIf B >= 9
      AllureLevel = 1
    Else
      AllureLevel = 0
    EndIf
    JMap.setInt(aiTargetData, "SCV_Allure", AllureLevel)
  ;ElseIf JMap.getInt(aiTargetData, SCV_DataVersion) < 2
  EndIf
  checkPredAbilities(akTarget)
  JMap.setInt(aiTargetData, "SCV_DataVersion", ActorDataVersion)
EndFunction

Function initializePerk(Actor akTarget, String asPerkID, Int aiPerkDerivative, Float afChance)
  Int i
  If aiPerkDerivative < 5
    i = 0
  ElseIf aiPerkDerivative < 9
    i = 1
  ElseIf aiPerkDerivative < 10
    i = 2
  EndIf
  i += Math.Floor(afChance / 70)
  If i > 3
    i = 3
  EndIf
  If i > 0
    takeUpPerks(akTarget, asPerkID, i)
  EndIf
EndFunction

Function debugMaxPredStats(Actor akTarget)
	{Debug function, meant to check high-level pred interactions}
	Note("Maxing Pred Stats")
	Int TargetData = getTargetData(akTarget, True)
	JMap.setInt(TargetData, "SCV_IsOVPred", 1)
	JMap.setInt(TargetData, "SCV_OVLevel", 100)
	JMap.setInt(TargetData, "SCV_OVLevelExtra", 100)
  JMap.setInt(TargetData, "SCV_IsAVPred", 1)
  JMap.setInt(TargetData, "SCV_AVLevel", 100)
  JMap.setInt(TargetData, "SCV_AVLevelExtra", 100)
	JMap.setFlt(TargetData, "STBase", 5000)
  takeUpPerks(akTarget, "SCLRoomForMore", 5)
  takeUpPerks(akTarget, "SCLHeavyBurden", 5)
  takeUpPerks(akTarget, "SCLStoredLimitUp", 5)
  takeUpPerks(akTarget, "SCLAllowOverflow", 1)
  takeUpPerks(akTarget, "SCV_IntenseHunger", 3)
  takeUpPerks(akTarget, "SCV_MetalMuncher", 3)
  takeUpPerks(akTarget, "SCV_FollowerofNamira", 3)
  takeUpPerks(akTarget, "SCV_DragonDevourer", 3)
  takeUpPerks(akTarget, "SCV_SpiritSwallower", 3)
  takeUpPerks(akTarget, "SCV_ExpiredEpicurian", 3)
  takeUpPerks(akTarget, "SCV_DaedraDieter", 3)
  takeUpPerks(akTarget, "SCV_Stalker", 3)
  takeUpPerks(akTarget, "SCV_RemoveLimits", 1)
  takeUpPerks(akTarget, "SCV_Constriction", 3)
  If SCVSet.SCA_Initialized
    takeUpPerks(akTarget, "SCA_BasementStorage", 5)
  EndIf
  checkPredAbilities(akTarget)
  ;setAggression(akTarget, 5)

EndFunction
;Get Functions *****************************************************************
Float Function getProxy(Actor akTarget, String asAV, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Float Proxy =  JMap.getFlt(TargetData, asAV + "Proxy")
  If Proxy < 0
    Proxy = 0
    JMap.setFlt(TargetData, asAV + "Proxy", 0)
  EndIf
  Return Proxy
EndFunction

Float Function getProxyBase(Actor akTarget, String asAV, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Float ProxyBase =  JMap.getFlt(TargetData, asAV + "ProxyBase")
  If ProxyBase < 0
    ProxyBase = 0
    JMap.setFlt(TargetData, asAV + "ProxyBase", 0)
  EndIf
  Return ProxyBase
EndFunction

Float Function getProxyPercent(Actor akTarget, String asAV, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Float Proxy = getProxy(akTarget, asAV, TargetData)
  Float AVBase = getProxyBase(akTarget, asAV, TargetData)
  Return Proxy / AVBase
EndFunction

Function setProxy(Actor akTarget, String asAV, Float aiValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If aiValue < 0
    aiValue = 0
  EndIf
  JMap.setFlt(TargetData, asAV + "Proxy", aiValue)
EndFunction

Function setProxyBase(Actor akTarget, String asAV, Float aiValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If aiValue < 0
    aiValue = 0
  EndIf
  JMap.setFlt(TargetData, asAV + "ProxyBase", aiValue)
EndFunction

Function modProxy(Actor akTarget, String asAV, Float aiValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Float Proxy = getProxy(akTarget, asAV, TargetData)
  Proxy += aiValue
  If Proxy < 0
    Proxy = 0
  EndIf
  JMap.setFlt(TargetData, asAV + "Proxy", Proxy)
EndFunction

Function modProxyBase(Actor akTarget, String asAV, Float aiValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Float Proxy = getProxyBase(akTarget, asAV, TargetData)
  Proxy += aiValue
  If Proxy < 0
    Proxy = 0
  EndIf
  JMap.setFlt(TargetData, asAV + "ProxyBase", Proxy)
EndFunction

Bool Function isInPred(Actor akPrey, Int aiTargetData = 0)
	{Basically checks to see if there's an actor in the tracking data}
  Int TargetData = getData(akPrey, aiTargetData)
  Return getPred(akPrey, TargetData) as Bool
EndFunction

Actor Function getPred(Actor akPrey, Int aiTargetData = 0)
  Int TargetData = getData(akPrey, aiTargetData)
  Int JM_TrackingData = JMap.getObj(TargetData, "SCLTrackingData")
  Return JMap.getForm(JM_TrackingData, "SCV_Pred") as Actor
EndFunction

Int Function getDamageTier(Actor akTarget)
  Int i = SCVSet.DamageArray.Length - 1
  While i
    If akTarget.HasMagicEffect(SCVSet.DamageArray[i].GetNthEffectMagicEffect(0))
      Return i
    EndIf
    i -= 1
  EndWhile
  Return 0
EndFunction

Int Function getFrenzyLevel(Actor akTarget)
  Return 0
  ;/If akTarget.HasMagicEffect(SCVSet.SCV_FrenzyLevel2)
    Return 2
  ElseIf akTarget.HasMagicEffect(SCVSet.SCV_FrenzyLevel1)
    Return 1
  Else
    Return 0
  EndIf/;
EndFunction

Bool Function isBeingHurt(Actor akTarget)
  Return akTarget.HasMagicEffectWithKeyword(SCVSet.SCV_DamageKeyword)
EndFunction

Int Function getNumStrugglePrey(Actor akPred, Int aiTargetData = 0)
  {Returns number of prey currently struggling. Will not get already finished prey}
  Int TargetData = getData(akPred, aiTargetData)
  Int JF_Contents = getContents(akPred, 8, aiTargetData)
  Int Struggling = JFormMap.count(JF_Contents)
  Return Struggling
EndFunction

Bool Function hasStrugglePrey(Actor akPred, Int aiTargetData = 0)
  Int TargetData = getData(akPred, aiTargetData)
  Int JF_Contents = getContents(akPred, 8, aiTargetData)
  Return !JValue.empty(JF_Contents)
EndFunction

Bool Function hasOVStrugglePrey(Actor akPred, Int aiTargetData = 0)
  {Returns if the actor has prey taken by oral vore}
  Int TargetData = getData(akPred, aiTargetData)
  Int JF_Contents = getContents(akPred, 8, TargetData)
  Form ItemKey = JFormMap.nextKey(JF_Contents)
  While ItemKey
    Int JM_Entry = JFormMap.getObj(JF_Contents, ItemKey)
    Int ItemType = JMap.getInt(JM_Entry, "StoredItemType")
    If ItemType == 1 || ItemType == 2
      Return True
    EndIf
    ItemKey = JFormMap.nextKey(JF_Contents, ItemKey)
  EndWhile
  Return False
EndFunction

Bool Function hasAVStrugglePrey(Actor akPred, Int aiTargetData = 0)
  Int TargetData = getData(akPred, aiTargetData)
  Int JF_Contents = getContents(akPred, 8, TargetData)
  Form ItemKey = JFormMap.nextKey(JF_Contents)
  While ItemKey
    Int JM_Entry = JFormMap.getObj(JF_Contents, ItemKey)
    Int ItemType = JMap.getInt(JM_Entry, "StoredItemType")
    If ItemType == 4 || ItemType == 6
      Return True
    EndIf
    ItemKey = JFormMap.nextKey(JF_Contents, ItemKey)
  EndWhile
  Return False
EndFunction

Bool Function hasPrey(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If hasStrugglePrey(akTarget, TargetData) || hasPreyType(akTarget, 1, TargetData) \
    || hasPreyType(akTarget, 2, TargetData)
    ;Add More Prey locations here as they are added.
    Return True
  ElseIf SCVSet.SCA_Initialized && (hasPreyType(akTarget, 4, TargetData) \
      || hasPreyType(akTarget, 5, TargetData) || hasPreyType(akTarget, 6, TargetData) \
      || hasPreyType(akTarget, 7, TargetData))
    Return True
  EndIf
EndFunction

Int Function getNumPrey(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Int NumPrey = getNumStrugglePrey(akTarget, TargetData)
  NumPrey += getNumPreyType(akTarget, 1, TargetData)
  NumPrey += getNumPreyType(akTarget, 2, TargetData)
  NumPrey += getNumPreyType(akTarget, 4, TargetData)
  NumPrey += getNumPreyType(akTarget, 5, TargetData)
  NumPrey += getNumPreyType(akTarget, 6, TargetData)
  NumPrey += getNumPreyType(akTarget, 7, TargetData)

  ;Add more prey functions here.
  Return NumPrey
EndFunction

Int Function getNumPreyType(Actor akTarget, Int aiItemType, Int aiTargetData = 0)
  {Returns number of actors in specified container}
  Int TargetData = getData(akTarget, aiTargetData)
  Int JF_Contents = getContents(akTarget, aiItemType, TargetData)
  Form FormKey = JFormMap.nextKey(JF_Contents)
  Int NumPrey
  While FormKey
    If FormKey as Actor
      NumPrey += 1
    EndIf
    FormKey = JFormMap.nextKey(JF_Contents, FormKey)
  EndWhile
  Return NumPrey
EndFunction

Bool Function hasPreyType(Actor akTarget, Int aiItemType, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Int JF_Contents = getContents(akTarget, aiItemType, TargetData)
  Form FormKey = JFormMap.nextKey(JF_Contents)
  While FormKey
    If FormKey as Actor
      Return True
    EndIf
    FormKey = JFormMap.nextKey(JF_Contents, FormKey)
  EndWhile
  Return False
EndFunction

Bool Function checkPredAbilities(Actor akTarget, Int aiTargetData = 0)
  {Checks to see if the actor is a predator, and adds the spells they need
  Returns if they are a predator}
  Int TargetData = getData(akTarget, aiTargetData)
  Bool isPred = False

  If isOVPred(akTarget, TargetData)
    akTarget.AddSpell(SCVSet.SCV_SwallowLethal, False)
    akTarget.AddSpell(SCVSet.SCV_SwallowNonLethal, False)
    isPred = True
  Else
    akTarget.RemoveSpell(SCVSet.SCV_SwallowLethal)
    akTarget.RemoveSpell(SCVSet.SCV_SwallowNonLethal)
  EndIf

  If isAVPred(akTarget, TargetData)
    akTarget.AddSpell(SCVSet.SCV_TakeInLethal, False)
    akTarget.AddSpell(SCVSet.SCV_TakeInNonLethal, False)
    isPred = True
  Else
    akTarget.RemoveSpell(SCVSet.SCV_TakeInLethal)
    akTarget.RemoveSpell(SCVSet.SCV_TakeInNonLethal)
  EndIf

  ;/If isPVPred(akTarget, TargetData)
    akTarget.AddSpell(SCVSet.SCV_UnPassLethal, False)
    akTarget.AddSpell(SCVSet.SCV_UnPassNonLethal, False)
    Int Level = calculatePredLevel(akTarget, "PV", TargetData)
    Int CurrentLevel = getCurrentPerkLevel(akTarget, "SCV_PVPredLevel")
    If Level != CurrentLevel
      akTarget.RemoveSpell(getPerkSpell("SCV_PVPredLevel", CurrentLevel))
      akTarget.AddSpell(getPerkSpell("SCV_PVPredLevel", Level), False)
    EndIf
    isPred = True
  EndIf/;
  If isPred
    Int Level = calculatePredLevel(akTarget, TargetData)
    Int CurrentLevel = getCurrentPerkLevel(akTarget, "SCV_PredLevel")
    If Level != CurrentLevel
      Spell CurrentSpell = getPerkSpell("SCV_PredLevel", CurrentLevel)
      If CurrentSpell
        akTarget.RemoveSpell(CurrentSpell)
      EndIf
      Spell NewSpell = getPerkSpell("SCV_PredLevel", CurrentLevel)
      If NewSpell
        akTarget.AddSpell(NewSpell, True)
      EndIf
    EndIf
    akTarget.AddSpell(SCVSet.SCV_PredMarker, True)
  Else
    Int CurrentLevel = getCurrentPerkLevel(akTarget, "SCV_PredLevel")
    Spell CurrentSpell = getPerkSpell("SCV_PredLevel", CurrentLevel)
    If CurrentSpell
      akTarget.RemoveSpell(CurrentSpell)
    EndIf
    akTarget.RemoveSpell(SCVSet.SCV_PredMarker)
  EndIf
  Return isPred
  ;Add other pred types here
EndFunction

Bool Function isPreyProtected(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_isPreyProtected") != 0
EndFunction

Bool Function isPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If isOVPred(akTarget, TargetData) || isAVPred(akTarget, TargetData) || isPVPred(akTarget, TargetData)
    Return True
  Else
    Return False
  EndIf
EndFunction

Bool Function isOVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_IsOVPred") != 0
EndFunction

Bool Function isAVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_IsAVPred") != 0
EndFunction

Bool Function isPVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_IsPVPred") != 0
EndFunction

Function togOVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If isOVPred(akTarget, aiTargetData)
    JMap.setInt(TargetData, "SCV_IsOVPred", 0)
  Else
    JMap.setInt(TargetData, "SCV_IsOVPred", 1)
  EndIf
EndFunction

Function togAVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If isAVPred(akTarget, aiTargetData)
    JMap.setInt(TargetData, "SCV_IsAVPred", 0)
  Else
    JMap.setInt(TargetData, "SCV_IsAVPred", 1)
  EndIf
EndFunction

Function togPVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If isPVPred(akTarget, aiTargetData)
    JMap.setInt(TargetData, "SCV_IsPVPred", 0)
  Else
    JMap.setInt(TargetData, "SCV_IsPVPred", 1)
  EndIf
EndFunction

Function setOVPred(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_IsOVPred", 1)
  Else
    JMap.setInt(TargetData, "SCV_IsOVPred", 0)
  EndIf
EndFunction

Function setAVPred(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_IsAVPred", 1)
  Else
    JMap.setInt(TargetData, "SCV_IsAVPred", 0)
  EndIf
EndFunction

Function setPVPred(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_IsPVPred", 1)
  Else
    JMap.setInt(TargetData, "SCV_IsPVPred", 0)
  EndIf
EndFunction

Bool Function isOVPredBlocked(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_IsOVPredBlocked") != 0
EndFunction

Bool Function isAVPredBlocked(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_IsAVPredBlocked") != 0
EndFunction

Bool Function isPVPredBlocked(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_IsPVPredBlocked") != 0
EndFunction

Function setOVPredBlocked(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_IsOVPredBlocked", 1)
  Else
    JMap.setInt(TargetData, "SCV_IsOVPredBlocked", 0)
  EndIf
EndFunction

Function setAVPredBlocked(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_IsAVPredBlocked", 1)
  Else
    JMap.setInt(TargetData, "SCV_IsAVPredBlocked", 0)
  EndIf
EndFunction

Function setPVPredBlocked(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_IsPVPredBlocked", 1)
  Else
    JMap.setInt(TargetData, "SCV_IsPVPredBlocked", 0)
  EndIf
EndFunction

Bool Function isFriendlyOVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_isFriendlyOVPred") != 0
EndFunction

Bool Function isFriendlyAVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_isFriendlyAVPred") != 0
EndFunction

Bool Function isFriendlyPVPred(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_isFriendlyPVPred") != 0
EndFunction

Function setFriendlyOVPred(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_isFriendlyOVPred", 1)
  Else
    JMap.setInt(TargetData, "SCV_isFriendlyOVPred", 0)
  EndIf
EndFunction

Function setFriendlyAVPred(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_isFriendlyAVPred", 1)
  Else
    JMap.setInt(TargetData, "SCV_isFriendlyAVPred", 0)
  EndIf
EndFunction

Function setFriendlyPVPred(ACtor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_isFriendlyPVPred", 1)
  Else
    JMap.setInt(TargetData, "SCV_isFriendlyPVPred", 0)
  EndIf
EndFunction

Bool Function allowsFriendlyOV(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_allowsFriendlyOV") != 0
EndFunction

Bool Function allowsFriendlyAV(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_allowsFriendlyAV") != 0
EndFunction

Bool Function allowsFriendlyPV(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_allowsFriendlyPV") != 0
EndFunction

Function setAllowsFriendlyOV(Actor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_allowsFriendlyOV", 1)
  Else
    JMap.setInt(TargetData, "SCV_allowsFriendlyOV", 0)
  EndIf
EndFunction

Function setAllowsFriendlyAV(Actor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_allowsFriendlyAV", 1)
  Else
    JMap.setInt(TargetData, "SCV_allowsFriendlyAV", 0)
  EndIf
EndFunction

Function setAllowsFriendlyPV(Actor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_allowsFriendlyPV", 1)
  Else
    JMap.setInt(TargetData, "SCV_allowsFriendlyPV", 0)
  EndIf
EndFunction

Bool Function allowsFriendlyLethalOV(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_allowsFriendlyLethalOV") != 0
EndFunction

Bool Function allowsFriendlyLethalAV(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_allowsFriendlyLethalAV") != 0
EndFunction

Bool Function allowsFriendlyLethalPV(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_allowsFriendlyLethalPV") != 0
EndFunction

Function setAllowsFriendlyLethalOV(Actor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_allowsFriendlyLethalOV", 1)
  Else
    JMap.setInt(TargetData, "SCV_allowsFriendlyLethalOV", 0)
  EndIf
EndFunction

Function setAllowsFriendlyLethalAV(Actor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_allowsFriendlyLethalAV", 1)
  Else
    JMap.setInt(TargetData, "SCV_allowsFriendlyLethalAV", 0)
  EndIf
EndFunction

Function setAllowsFriendlyLethalPV(Actor akTarget, Bool abValue, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If abValue
    JMap.setInt(TargetData, "SCV_allowsFriendlyLethalPV", 1)
  Else
    JMap.setInt(TargetData, "SCV_allowsFriendlyLethalPV", 0)
  EndIf
EndFunction

Int Function calculatePredLevel(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  If isOVPred(akTarget, TargetData) || isAVPred(akTarget, TargetData) || isPVPred(akTarget, TargetData)
    Return 1
  Else
    Return 0
  EndIf
EndFunction

;EXP Functions *****************************************************************
Int Function getTotalPredLevel(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Int Total = getOVLevelTotal(akTarget, TargetData)
  Total += getAVLevelTotal(akTarget, TargetData)
  Total += getPVLevelTotal(akTarget, TargetData)
  Return Total
EndFunction

Int Function getOVLevel(Actor akTarget, Int aiTargetData = 0)
  {gets learned oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_OVLevel")
EndFunction

Int Function modOVLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_OVLevel", JMap.getInt(TargetData, "SCV_OVLevel") + aiValue)
EndFunction

Int Function setOVLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_OVLevel", aiValue)
EndFunction

Int Function getOVLevelExtra(Actor akTarget, Int aiTargetData = 0)
  {gets additional oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_OVLevelExtra")
EndFunction

Int Function modOVLevelExtra(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_OVLevelExtra", JMap.getInt(TargetData, "SCV_OVLevelExtra") + aiValue)
EndFunction

Int Function setOVLevelExtra(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_OVLevelExtra", aiValue)
EndFunction

Int Function getOVLevelTotal(Actor akTarget, Int aiTargetData = 0)
  {gets total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return getOVLevel(akTarget, aiTargetData) + getOVLevelExtra(akTarget, aiTargetData)
EndFunction

Int Function getOVEXP(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_OVEXP")
EndFunction

Int Function getAVLevel(Actor akTarget, Int aiTargetData = 0)
  {gets learned oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_AVLevel")
EndFunction

Int Function modAVLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_AVLevel", JMap.getInt(TargetData, "SCV_AVLevel") + aiValue)
EndFunction

Int Function setAVLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_AVLevel", aiValue)
EndFunction

Int Function getAVLevelExtra(Actor akTarget, Int aiTargetData = 0)
  {gets additional oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_AVLevelExtra")
EndFunction

Int Function modAVLevelExtra(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_AVLevelExtra", JMap.getInt(TargetData, "SCV_AVLevelExtra") + aiValue)
EndFunction

Int Function setAVLevelExtra(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_AVLevelExtra", aiValue)
EndFunction

Int Function getAVLevelTotal(Actor akTarget, Int aiTargetData = 0)
  {gets total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return getAVLevel(akTarget, aiTargetData) + getAVLevelExtra(akTarget, aiTargetData)
EndFunction

Int Function getAVEXP(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_AVEXP")
EndFunction

Int Function getPVLevel(Actor akTarget, Int aiTargetData = 0)
  {gets learned oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_PVLevel")
EndFunction

Int Function modPVLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_PVLevel", JMap.getInt(TargetData, "SCV_PVLevel") + aiValue)
EndFunction

Int Function setPVLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_PVLevel", aiValue)
EndFunction

Int Function getPVLevelExtra(Actor akTarget, Int aiTargetData = 0)
  {gets additional oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_PVLevelExtra")
EndFunction

Int Function modPVLevelExtra(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_PVLevelExtra", JMap.getInt(TargetData, "SCV_PVLevelExtra") + aiValue)
EndFunction

Int Function setPVLevelExtra(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  JMap.setInt(TargetData, "SCV_PVLevelExtra", aiValue)
EndFunction

Int Function getPVLevelTotal(Actor akTarget, Int aiTargetData = 0)
  {gets total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  Return getPVLevel(akTarget, aiTargetData) + getPVLevelExtra(akTarget, aiTargetData)
EndFunction

Int Function getPVEXP(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_PVEXP")
EndFunction

Int Function getAllureLevel(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_Allure")
EndFunction

Int Function getResLevel(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Int Res = JMap.getInt(TargetData, "SCV_ResLevel", -1)
  If Res == -1
    Return Math.Ceiling((akTarget.GetLevel() / 2) + (akTarget.GetActorValue("Stamina") + akTarget.GetActorValue("Magicka")) / 20)
  Else
    Return Res
  EndIf
EndFunction

Int Function modResLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total resistance level}
  Int TargetData = getData(akTarget, aiTargetData)
  If TargetData
    JMap.setInt(TargetData, "SCV_ResLevel", JMap.getInt(TargetData, "SCV_ResLevel") + aiValue)
  EndIf
EndFunction

Int Function setResLevel(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Changes total oral vore level}
  Int TargetData = getData(akTarget, aiTargetData)
  If TargetData
    JMap.setInt(TargetData, "SCV_ResLevel", aiValue)
  EndIf
EndFunction

Int Function getResEXP(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_ResEXP")
EndFunction

Function giveAllPreyResExp(Actor akPred, Int aiEXP, Int aiTargetData = 0)
  Int TargetData = getData(akPred, aiTargetData)
  Int JF_Struggle = getContents(akPred, 8, TargetData)
  Actor i = JFormMap.nextKey(JF_Struggle) as Actor
  While i
    giveResExp(i, aiEXP)
    i = JFormMap.nextKey(JF_Struggle, i) as Actor
  EndWhile
EndFunction

Function setOVExp(Actor akTarget, Int aiValue, Int aiTargetData)
  Int TargetData = getData(akTarget, aiTargetData)
  If aiValue >= 0
    JMap.setInt(TargetData, "SCV_OVEXP", aiValue)
  EndIf
EndFunction

Function setAVExp(Actor akTarget, Int aiValue, Int aiTargetData)
  Int TargetData = getData(akTarget, aiTargetData)
  If aiValue >= 0
    JMap.setInt(TargetData, "SCV_AVEXP", aiValue)
  EndIf
EndFunction

Function setPVExp(Actor akTarget, Int aiValue, Int aiTargetData)
  Int TargetData = getData(akTarget, aiTargetData)
  If aiValue >= 0
    JMap.setInt(TargetData, "SCV_PVEXP", aiValue)
  EndIf
EndFunction

Function setResExp(Actor akTarget, Int aiValue, Int aiTargetData)
  Int TargetData = getData(akTarget, aiTargetData)
  If aiValue >= 0
    JMap.setInt(TargetData, "SCV_ResEXP", aiValue)
  EndIf
EndFunction

Bool Function giveOVExp(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Grants oral vore exp. Returns if the actor leveled up}
  Int TargetData = getData(akTarget, aiTargetData)
  Int CurrentLevel = JMap.getInt(TargetData, "SCV_OVLevel")
  JMap.setInt(TargetData, "SCV_OVEXP", JMap.getInt(TargetData, "SCV_OVEXP") + aiValue)
  Int NewLevel = updateOVEXP(akTarget, TargetData)
  Return NewLevel != CurrentLevel
EndFunction

Bool Function giveAVExp(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Grants oral vore exp. Returns if the actor leveled up}
  Int TargetData = getData(akTarget, aiTargetData)
  Int CurrentLevel = JMap.getInt(TargetData, "SCV_AVLevel")
  JMap.setInt(TargetData, "SCV_AVEXP", JMap.getInt(TargetData, "SCV_AVEXP") + aiValue)
  Int NewLevel = updateAVEXP(akTarget, TargetData)
  Return NewLevel != CurrentLevel
EndFunction

Bool Function givePVExp(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Grants oral vore exp. Returns if the actor leveled up}
  Int TargetData = getData(akTarget, aiTargetData)
  Int CurrentLevel = JMap.getInt(TargetData, "SCV_PVLevel")
  JMap.setInt(TargetData, "SCV_PVEXP", JMap.getInt(TargetData, "SCV_PVEXP") + aiValue)
  Int NewLevel = updatePVEXP(akTarget, TargetData)
  Return NewLevel != CurrentLevel
EndFunction

Bool Function giveResExp(Actor akTarget, Int aiValue, Int aiTargetData = 0)
  {Grants resistance exp. Returns if the actor leveled up}
  Int TargetData = getData(akTarget, aiTargetData)
  Int CurrentLevel = JMap.getInt(TargetData, "SCV_ResLevel")
  JMap.setInt(TargetData, "SCV_ResEXP", JMap.getInt(TargetData, "SCV_ResEXP") + aiValue)
  Int NewLevel = updateResEXP(akTarget, TargetData)
  Return NewLevel != CurrentLevel
EndFunction

Int Function updateResEXP(Actor akTarget, Int aiTargetData = 0)
	{Returns the current level of the target after leveling up}
  Int TargetData = getData(akTarget, aiTargetData)
	Int Level = JMap.getInt(TargetData, "SCV_ResLevel")
	Int EXP = JMap.getInt(TargetData, "SCV_ResEXP")
	Int Threshold = getResEXPThreshold(Level)
	If EXP >= Threshold
		While EXP >= Threshold
			Level += 1
			Exp -= Threshold
      Threshold = getResEXPThreshold(Level)
		EndWhile
    JMap.setInt(TargetData, "SCV_ResLevel", Level)
    JMap.setInt(TargetData, "SCV_ResEXP", EXP)
  EndIf
  Return Level
EndFunction

Int Function updateOVEXP(Actor akTarget, Int aiTargetData = 0)
	{Returns the current level of the target after leveling up}
  Int TargetData = getData(akTarget, aiTargetData)
	Int Level = JMap.getInt(TargetData, "SCV_OVLevel")
	Int EXP = JMap.getInt(TargetData, "SCV_OVEXP")
	Int Threshold = getOVEXPThreshold(Level)
	If EXP >= Threshold
		While EXP >= Threshold
			Level += 1
			Exp -= Threshold
      Threshold = getOVEXPThreshold(Level)
		EndWhile
    JMap.setInt(TargetData, "SCV_OVLevel", Level)
    JMap.setInt(TargetData, "SCV_OVEXP", EXP)
  EndIf
  Return Level
EndFunction

Int Function updateAVEXP(Actor akTarget, Int aiTargetData = 0)
	{Returns the current level of the target after leveling up}
  Int TargetData = getData(akTarget, aiTargetData)
	Int Level = JMap.getInt(TargetData, "SCV_AVLevel")
	Int EXP = JMap.getInt(TargetData, "SCV_AVEXP")
	Int Threshold = getAVEXPThreshold(Level)
	If EXP >= Threshold
		While EXP >= Threshold
			Level += 1
			Exp -= Threshold
      Threshold = getAVEXPThreshold(Level)
		EndWhile
    JMap.setInt(TargetData, "SCV_AVLevel", Level)
    JMap.setInt(TargetData, "SCV_AVEXP", EXP)
  EndIf
  Return Level
EndFunction

Int Function updatePVEXP(Actor akTarget, Int aiTargetData = 0)
	{Returns the current level of the target after leveling up}
  Int TargetData = getData(akTarget, aiTargetData)
	Int Level = JMap.getInt(TargetData, "SCV_PVLevel")
	Int EXP = JMap.getInt(TargetData, "SCV_PVEXP")
	Int Threshold = getPVEXPThreshold(Level)
	If EXP >= Threshold
		While EXP >= Threshold
			Level += 1
			Exp -= Threshold
      Threshold = getPVEXPThreshold(Level)
		EndWhile
    JMap.setInt(TargetData, "SCV_PVLevel", Level)
    JMap.setInt(TargetData, "SCV_PVEXP", EXP)
  EndIf
  Return Level
EndFunction

Int Function getOVEXPThreshold(Int aiLevel)
	Return Math.Ceiling(Math.pow(aiLevel, 2) + 10)
EndFunction

Int Function getAVEXPThreshold(Int aiLevel)
	Return Math.Ceiling(Math.pow(aiLevel, 2) + 10)
EndFunction

Int Function getPVEXPThreshold(Int aiLevel)
	Return Math.Ceiling(Math.pow(aiLevel, 2) + 10)
EndFunction

Int Function getResEXPThreshold(Int aiLevel)
	Return Math.Ceiling(Math.pow(aiLevel, 1.3) + 10)
EndFunction

;Transfer functions

Function transferInventory(Actor akTarget, Actor akSource, Int aiType)
	{Moves all items from actor's inventory to their stomach
  aiType refers to destination of the items (ie 1 = all items going into stomach)
  4 == all items going into anus, 11 == all items going into bladder}
	SCVTransferObject ST_TransferRef = akTarget.PlaceAtMe(SCVSet.SCV_TransferBase) as SCVTransferObject
	ST_TransferRef.TransferTarget = akTarget
	ST_TransferRef.Type = aiType
  SCLibrary.addToObjectTrashList(ST_TransferRef, 5)
	akSource.RemoveAllItems(ST_TransferRef, False, True)	;See SCVTransferObject Script for remaining procedure
EndFunction

Function transferSCLItems(Actor akTarget, Actor akSource, Int aiType)
  {Moves items stored in actor to target NEED TO WRITE}
  Int JF_Target = getContents(akSource, aiType)

  Int j = JIntMap.nextKey(SCLSet.JI_ItemTypes)
  While j
    Int JF_Source = getContents(akSource, j)
    Int i = JValue.count(JF_Source)
    While i
      i -= 1
      Form Item = JFormMap.getNthKey(JF_Source, i)
      If Item as Actor
        insertPrey(akTarget, Item as Actor, aiType, False, False)
      Else
        addItem(akTarget, Item as ObjectReference, Item, aiType)
      EndIf
    EndWhile
    j = JIntMap.nextKey(SCLSet.JI_ItemTypes, j)
  EndWhile
EndFunction

Function updatePredPreyInfo(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
EndFunction

Int Function getCurrentNourish(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Return JMap.getInt(TargetData, "SCV_AppliedNourishTier")
EndFunction

Float Function genDigestValue(Form akItem, Bool abMod1 = False, Bool abMod2 = False)
  Actor akTarget = akItem as Actor
  If !akTarget
    Return Parent.genDigestValue(akItem, abMod1, abMod2)
  Else
    Float DigestValue
  	Int JM_DB_ItemEntry = getItemDataEntry(akTarget)
  	If akTarget.GetRace().HasKeyword(ActorTypeNPC)
  		If JMap.hasKey(JM_DB_ItemEntry, "WeightOverride")
  			DigestValue = JMap.getFlt(JM_DB_ItemEntry, "WeightOverride")
  		ElseIf akTarget.GetLeveledActorBase().GetSex() == 0
  			DigestValue = akTarget.GetLeveledActorBase().GetWeight() + 80
  		ElseIf akTarget.GetLeveledActorBase().GetSex() == 1
  			DigestValue = akTarget.GetLeveledActorBase().GetWeight() + 70
  		EndIf
  		;Add check for bodymods here (SAM, Bodymorph, etc.)
  		;WeightMorphs, SAMPLE, anything else?
  		;DigestValue +=
  		DigestValue *= akTarget.GetScale() * NetImmerse.GetNodeScale(akTarget, "NPC Root [Root]", False)
  		If JM_DB_ItemEntry && JMap.hasKey(JM_DB_ItemEntry, "WeightModifier")
  			DigestValue *= JMap.getFlt(JM_DB_ItemEntry, "WeightModifier", 1)
  		EndIf

      Int FillingPerkRank = getTotalPerkLevel(akTarget, "SCV_FillingMeal")
      DigestValue *= (1 + (0.2 * FillingPerkRank))

      If abMod1
        DigestValue += akTarget.GetTotalItemWeight()	;All of the Actor's inventory
      EndIf
  		DigestValue += getTotalCombined(akTarget)
  		Return DigestValue
  	Else
  		If JMap.hasKey(JM_DB_ItemEntry, "WeightOverride")
  			DigestValue = JMap.getFlt(JM_DB_ItemEntry, "WeightOverride")
  			DigestValue *= akTarget.GetScale()
  		Else
  			DigestValue = Utility.RandomInt(10, 50)
  		EndIf
  		If JM_DB_ItemEntry && JMap.hasKey(JM_DB_ItemEntry, "WeightModifier")
  			DigestValue *= JMap.getFlt(JM_DB_ItemEntry, "WeightModifier", 1)
  		EndIf

      Int FillingPerkRank = getTotalPerkLevel(akTarget, "SCV_FillingMeal")
      DigestValue *= (1 + (0.2 * FillingPerkRank))

      If abMod1
        DigestValue += akTarget.GetTotalItemWeight()	;All of the Actor's inventory
      EndIf
  		DigestValue += getTotalCombined(akTarget)
  		Return DigestValue
  	EndIf
  EndIf
EndFunction

Actor Function findHighestPred(Actor akTarget)
  {Searches for the pred who ate all other prey, returns akPrey if they are the highest}
	Actor akPrey = akTarget
	Bool Done = False
	While !Done
		Int PreyData = getTargetData(akPrey)
		Actor akPred = JMap.getForm(JMap.getObj(PreyData, "SCLTrackingData"), "SCV_Pred") as Actor
		If akPred
			akPrey = akPred
		Else
			Done = True
		EndIf
	EndWhile
	Return akPrey
EndFunction

Int Function insertPrey(Actor akPred, Actor akPrey, Int aiItemType, Bool abFriendly, Bool abPlayAnimation = True)
  If !akPred || !akPrey || !aiItemType
    Return 0
  EndIf
  Int Future = SCVSet.InsertPreyThreadManager.insertPreyAsync(akPred, akPrey, aiItemType, abFriendly, abPlayAnimation)
  Return SCVSet.InsertPreyThreadManager.get_result(Future)
EndFunction

;/Bool preyHandlingLocked = False
Int Function insertPrey(Actor akPred, Actor akPrey, Int aiItemType, Bool abFriendly, Bool abPlayAnimation = True)
  ;Consider putting these big functions into a mutlithreaded context
  Int PredData = getTargetData(akPred, True)
  Int PreyData = getTargetData(akPrey, True)
  Int JM_PreyEntry
  If preyHandlingLocked
    While preyHandlingLocked
      Utility.WaitMenuMode(0.5)
    EndWhile
  EndIf
  preyHandlingLocked = True
  Notice("Prey insertion commencing. Pred = " + nameGet(akPred) + ", Prey = " + nameGet(akPrey) + ", Item Type = " + aiItemType)
  If SCVSet.SCV_InVoreActionList.HasForm(akPred) || SCVSet.SCV_InVoreActionList.HasForm(akPrey)
    While SCVSet.SCV_InVoreActionList.HasForm(akPred) || SCVSet.SCV_InVoreActionList.HasForm(akPrey)
      Utility.Wait(0.5)
    EndWhile
  EndIf
  (SCVSet.SCV_FollowPred as SCVStayWithMe).DelayUpdate = True
  SCVSet.SCV_InVoreActionList.AddForm(akPred)
  SCVSet.SCV_InVoreActionList.AddForm(akPrey)
  ;Play animation here
  If akPred == PlayerRef
    If (aiItemType == 1 || aiItemType == 2)
      Int Allure = getAllureLevel(akPrey)
      If Allure >= 1
        PlayerThoughtDB(akPred, "SCVPredSwallowPositive")
      ElseIf Allure <= -1
        PlayerThoughtDB(akPred, "SCVPredSwallowNegative")
      Else
        PlayerThoughtDB(akPred, "SCVPredSwallow")
      EndIf
    ElseIf aiItemType == 4 || aiItemType == 6
      PlayerThoughtDB(akPred, "SCVPredTakeIn")
    EndIf
  EndIf

  If aiItemType == 1 || aiItemType == 2
    PlayerThoughtDB(akPrey, "SCVPreySwallowed")
    Debug.Notification(nameGet(akPred) + " is eating " + nameGet(akPrey) + "!")
    akPred.Say(SCVSet.SCV_SwallowSound)
  ElseIf aiItemType == 4 || aiItemType == 6
    PlayerThoughtDB(akPrey, "SCVPreyTakenIn")
    Debug.Notification(nameGet(akPred) + " is taking in " + nameGet(akPrey) + "!")
    akPred.Say(SCVSet.SCV_TakeInSound)
  EndIf

  Int iModType = aiItemType
  If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
    If aiItemType == 4 || aiItemType == 5
      iModType = 1
    ElseIf aiItemType == 6 || aiItemType == 7
      iModType == 2
    EndIf
  EndIf

  If akPrey.isDead() || abFriendly || akPrey.IsUnconscious()
    ;Notice("Prey is willing or incapacitated. Inserting directly into contents.")
    If aiItemType == 1 || aiItemType == 2
      If akPrey == PlayerRef
        JM_PreyEntry = addItem(akPred, akPrey, aiItemType = iModType, abMoveNow = False)
        SCVSet.SCV_FollowPred.ForceRefTo(akPred)
      Else
        JM_PreyEntry = addItem(akPred, akPrey, aiItemType = iModType)
      EndIf
    ElseIf aiItemType == 4 || aiItemType == 6
      If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
        If akPrey == PlayerRef
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = iModType, abMoveNow = False)
          SCVSet.SCV_FollowPred.ForceRefTo(akPred)
        Else
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = iModType)
        EndIf
      Else
        If akPrey == PlayerRef
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = iModType, afDigestValueOverRide = 0, abMoveNow = False)
          SCVSet.SCV_FollowPred.ForceRefTo(akPred)
        Else
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = iModType, afDigestValueOverRide = 0)
        EndIf
        JMap.setFlt(JM_PreyEntry, "StoredDigestValue", genDigestValue(akPrey, True))
      EndIf
    EndIf
  Else
    ;Notice("Prey is struggling. Inserting into struggle contents")
    If aiItemType == 1 || aiItemType == 2
      If akPrey == PlayerRef
        JM_PreyEntry = addItem(akPred, akPrey, aiItemType = 8, abMoveNow = False)
        SCVSet.SCV_FollowPred.ForceRefTo(akPred)
      Else
        JM_PreyEntry = addItem(akPred, akPrey, aiItemType = 8)
      EndIf
      giveOVExp(akPred, getResLevel(akPrey))
    ElseIf aiItemType == 4 || aiItemType == 6
      If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
        If akPrey == PlayerRef
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = 8, abMoveNow = False)
          SCVSet.SCV_FollowPred.ForceRefTo(akPred)
        Else
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = 8)
        EndIf
      Else
        If akPrey == PlayerRef
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = 8, afDigestValueOverRide = 0, abMoveNow = False)
          SCVSet.SCV_FollowPred.ForceRefTo(akPred)
        Else
          JM_PreyEntry = addItem(akPred, akPrey, aiItemType = 8, afDigestValueOverRide = 0)
        EndIf
        JMap.setFlt(JM_PreyEntry, "StoredDigestValue", genDigestValue(akPrey, True))
      EndIf

      giveAVExp(akPred, getResLevel(akPrey))
    ;/ElseIf aiItemType == 5 || aiItemType == 7
      givePVEXP(akPred, getResLevel(akPrey))/;
  ;/  EndIf
  EndIf

  JMap.setInt(PreyData, "SCV_NumTimesEaten", JMap.getInt(PreyData, "SCV_NumTimesEaten") + 1)
  JMap.setForm(JM_PreyEntry, "SCV_Pred", akPred)
  JMap.setForm(JMap.getObj(PreyData, "SCLTrackingData"), "SCV_Pred", akPred)
  JMap.setInt(JM_PreyEntry, "StoredItemType", aiItemType)

  setProxy(akPred, "Stamina", akPred.GetActorValue("Stamina") as Int, PredData)
  setProxy(akPred, "Magicka", akPred.GetActorValue("Magicka") as Int, PredData)
  setProxy(akPred, "Health", akPred.GetActorValue("Health") as Int, PredData)

  setProxy(akPrey, "Stamina", akPrey.GetActorValue("Stamina") as Int, PreyData)
  setProxy(akPrey, "Magicka", akPrey.GetActorValue("Magicka") as Int, PreyData)
  setProxy(akPrey, "Health", akPrey.GetActorValue("Health") as Int, PreyData)


  Int InsertEvent = ModEvent.Create("SCV_InsertEvent")
  ModEvent.PushForm(InsertEvent, akPred)
  ModEvent.PushForm(InsertEvent, akPred)
  ModEvent.PushInt(InsertEvent, aiItemType)
  ModEvent.PushBool(InsertEvent, abFriendly)
  ModEvent.Send(InsertEvent)

  updateFullnessEX(akPred, True, PredData)

  SCVSet.SCV_InVoreActionList.RemoveAddedForm(akPred)
  SCVSet.SCV_InVoreActionList.RemoveAddedForm(akPrey)
  (SCVSet.SCV_FollowPred as SCVStayWithMe).DelayUpdate = False

  quickUpdate(akPred)
  preyHandlingLocked = False
  Return JM_PreyEntry
EndFunction/;

Function PauseFollowPred()
  (SCVSet.SCV_FollowPred as SCVStayWithMe).addToDelayCounter()
EndFunction

Function ResumeFollowPred()
  (SCVSet.SCV_FollowPred as SCVStayWithMe).removeFromDelayCounter()
EndFunction


Int JA_HandleActors
Function handleFinishedActor(Actor akTarget, Int aiPreyEntry = 0, Int aiTargetData = 0)
  If !JA_HandleActors
    JA_HandleActors = JArray.object()
    JDB.setObj(".SCLExtraData.SCVHandleActors", JA_HandleActors)
  EndIf
  If JArray.findForm(JA_HandleActors, akTarget) != -1
    Return
  EndIf
  JArray.addForm(JA_HandleActors, akTarget)
  Notice("Handling finished actor. Name=" + nameGet(akTarget))
  Int TargetData = getData(akTarget, aiTargetData)
  giveAllPreyResExp(akTarget, getTotalPredLevel(akTarget, TargetData), TargetData)
  Actor nextPred = getPred(akTarget, TargetData)
  If nextPred
    Int nextPredData = getTargetData(nextPred)
    Int PredContents = getContents(nextPred, 8, nextPredData)
    Int JM_PreyEntry = JFormMap.getObj(PredContents, akTarget)
    Int StoredType = JMap.getInt(JM_PreyEntry, "StoredItemType")
    Notice("Pred " + nameGet(nextPred) + " Detected. Inserting into contents " + StoredType)
    ;transferInventory(nextPred, akTarget, StoredType)
    ;transferSCLItems(nextPred, akTarget, StoredType) ;Moved to end of digestion phase
    JFormMap.removeKey(PredContents, akTarget)
    If nextPred == PlayerRef
      If StoredType == 1 || StoredType == 2
        If !hasOVStrugglePrey(PlayerRef)
          PlayerThoughtDB(nextPred, "SCVOVPredAllStruggleFinished")
        Else
          PlayerThoughtDB(nextPred, "SCVOVPredStruggleFinished")
        EndIf
      ElseIf StoredType == 4 || StoredType == 6
        If !hasAVStrugglePrey(PlayerRef)
          PlayerThoughtDB(nextPred, "SCVAVPredAllStruggleFinished")
        Else
          PlayerThoughtDB(nextPred, "SCVAVPredStruggleFinished")
        EndIf
      ;/ElseIf StoredType == 5 || StoredType == 7
        If !hasPVStrugglePrey(PlayerRef)
          PlayerThoughtDB(nextPred, "SCVPVPredAllStruggleFinished")
        Else
          PlayerThoughtDB(nextPred, "SCVPVPredStruggleFinished")
        EndIf/;
      EndIf
    EndIf

    Int iModType = StoredType
    If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
      If StoredType == 4 || StoredType == 5
        iModType = 1
      ElseIf StoredType == 6 || StoredType == 7
        iModType = 2
      EndIf
    EndIf

    If StoredType == 1 || StoredType == 2
      nextPred.Say(SCVSet.SCV_BurpSound)
    ElseIf StoredType == 4 || StoredType == 6
      nextPred.Say(SCVSet.SCV_AFinishSound)
    EndIf
    Float DigestValue = genDigestValue(akTarget, True)

    If PlayerThoughtDB(akTarget, "SCVPreyFinished")
      addItem(nextPred, akTarget, aiItemType = iModType, afDigestValueOverRide = DigestValue, abMoveNow = False)
    Else
      addItem(nextPred, akTarget, aiItemType = iModType, afDigestValueOverRide = DigestValue)
    EndIf
    JMap.setInt(nextPredData, "SCV_NumPreyEaten", JMap.getInt(nextPredData, "SCV_NumPreyEaten") + 1)
    If StoredType == 1 || StoredType == 2
      JMap.setInt(nextPredData, "SCV_NumOVPreyEaten", JMap.getInt(nextPredData, "SCV_NumOVPreyEaten") + 1)
    ElseIf StoredType == 4 || StoredType == 6
      JMap.setInt(nextPredData, "SCV_NumAVPreyEaten", JMap.getInt(nextPredData, "SCV_NumAVPreyEaten") + 1)
    ElseIf StoredType == 5 || StoredType == 7
      JMap.setInt(nextPredData, "SCV_NumPVPreyEaten", JMap.getInt(nextPredData, "SCV_NumPVPreyEaten") + 1)
    ;ElseIf StoredType == 3 || StoredType == 4 Or whatever
      ;Record Prey eaten.
    EndIf
    Race PreyRace = akTarget.GetRace()
    Int StorageType
    If iModType == 1 || iModType == 2
      StorageType == 2
    ElseIf iModType == 4 || iModType == 6
      StorageType == 4
    ElseIf iModType == 5 || iModType == 7
      StorageType == 5
    EndIf

    If PreyRace.HasKeyword(SCVSet.ActorTypeNPC)
      JMap.setInt(nextPredData, "SCV_NumHumansEaten", JMap.getInt(nextPredData, "SCV_NumHumansEaten") + 1)
      If getCurrentPerkLevel(nextPred, "SCV_FollowerofNamira") >= 2
        Note("Adding Items to " + nameGet(akTarget) + " for finishing human prey.")
        insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledHumanItems)
      EndIf
    ElseIf PreyRace.HasKeyword(SCVSet.ActorTypeDragon)
      JMap.setInt(nextPredData, "SCV_NumDragonsEaten", JMap.getInt(nextPredData, "SCV_NumDragonsEaten") + 1)
      If getCurrentPerkLevel(nextPred, "SCV_DragonDevourer") >= 3
        Note("Adding Items to " + nameGet(akTarget) + " for finishing dragon prey.")
        insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledDragonItems)
      EndIf
    ElseIf PreyRace.HasKeyword(SCVSet.ActorTypeDwarven)
      JMap.setInt(nextPredData, "SCV_NumDwarvenEaten", JMap.getInt(nextPredData, "SCV_NumDwarvenEaten") + 1)
      If getCurrentPerkLevel(nextPred, "SCV_MetalMuncher") >= 2
        Note("Adding Items to " + nameGet(akTarget) + " for finishing dwarven prey.")
        insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledDwarvenItems)
      EndIf
    ElseIf PreyRace.HasKeyword(SCVSet.ActorTypeGhost)
      JMap.setInt(nextPredData, "SCV_NumGhostsEaten", JMap.getInt(nextPredData, "SCV_NumGhostsEaten") + 1)
      If getCurrentPerkLevel(nextPred, "SCV_SpiritSwallower") >= 2
        Note("Adding Items to " + nameGet(akTarget) + " for finishing ghost prey.")
        insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledGhosttems)
      EndIf
    ElseIf PreyRace.HasKeyword(SCVSet.ActorTypeUndead)
      JMap.setInt(nextPredData, "SCV_NumUndeadEaten", JMap.getInt(nextPredData, "SCV_NumUndeadEaten") + 1)
      If getCurrentPerkLevel(nextPred, "SCV_ExpiredEpicurian") >= 2
        Note("Adding Items to " + nameGet(akTarget) + " for finishing undead prey.")
        insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledUndeadItems)
      EndIf
    ElseIf PreyRace.HasKeyword(SCVSet.ActorTypeDaedra)
      JMap.setInt(nextPredData, "SCV_NumDaedraEaten", JMap.getInt(nextPredData, "SCV_NumDaedraEaten") + 1)
      If getCurrentPerkLevel(nextPred, "SCV_DaedraDieter") >= 2
        Note("Adding Items to " + nameGet(akTarget) + " for finishing daedra prey.")
        insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledDaedraItems)
      EndIf
    EndIf
    If nextPred == PlayerRef && isBossActor(akTarget)
      insertLeveledItems(nextPred, StorageType, SCVSet.SCV_LeveledBossItems)
    EndIf
    If isImportant(akTarget)
      JMap.setInt(nextPredData, "SCV_NumImportantEaten", JMap.getInt(nextPredData, "SCV_NumImportantEaten") + 1)
    EndIf
    quickUpdate(nextPred, True)
    sendStruggleFinishEvent(nextPred, akTarget, StoredType)
    If StoredType == 1 || StoredType == 2
      giveOVExp(nextPred, genDigestValue(akTarget) as Int)
    ElseIf StoredType == 4 || StoredType == 6
      giveAVExp(nextPred, genDigestValue(akTarget) as Int)
    ElseIf StoredType == 5 || StoredType == 7
      givePVExp(nextPred, genDigestValue(akTarget) as Int)
    ;ElseIf StoredType == ?
    EndIf
  Else
    If hasPrey(akTarget)
      Notice("No Pred detected. Vomiting all prey.")
      vomitAll(akTarget, RemoveEverything = True)
      If SCVSet.SCA_Initialized
        SCALibrary SCALib = SCALibrary.getSCALibrary()
        SCALib.Defecate(akTarget)
        SCALib.Urinate(akTarget)
      EndIf
    EndIf
  EndIf
  quickUpdate(akTarget, True)
  Int d = JArray.findForm(JA_HandleActors, akTarget)
  If d != -1
    JArray.eraseIndex(JA_HandleActors, d)
  EndIf
EndFunction

Bool Function isBossActor(Actor akTarget)
  {Compares target to player, determines whether they're consisdered a "boss"}
  Return False
EndFunction

Bool Function isImportant(Actor akTarget)
  Return False
EndFunction

Function removeStruggleSpells(Actor akTarget)
  SCVSet.SCV_StruggleDispel.cast(akTarget)
EndFunction

Function insertLeveledItems(Actor akTarget, Int aiStorageType, LeveledItem akItemList)
  If SCVSet.SCV_InsertItemsChest.prepInsert(akTarget, aiStorageType)
    SCVSet.SCV_InsertItemsChest.AddItem(akItemList, 1, True)
  EndIf
  SCVSet.SCV_InsertItemsChest.finishInsert()
EndFunction

Bool Function sendStruggleFinishEvent(Actor akPred, Actor akPrey, Int aiItemType)
  Int FinishEvent = ModEvent.Create("SCV_StruggleFinish")
  ModEvent.PushForm(FinishEvent, akPred)
  ModEvent.PushForm(FinishEvent, akPrey)
  ModEvent.pushInt(FinishEvent, aiItemType)
  Return ModEvent.Send(FinishEvent)
EndFunction

Float[] Function genNormalDist()
	{Generates 2 randomly distributed numbers inside a 2x1 array
	See https://en.wikipedia.org/wiki/Marsaglia_polar_method and https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
	for more information
	Will be between -1 and 1
	Needs to be adjusted to be useful}
	Float u
	Float v
	Float s
	While s == 0 || s >= 1
		u = Utility.RandomFloat(-1, 1)
		v = Utility.RandomFloat(-1, 1)
		s = Math.pow(u, 2) + Math.pow(v, 2)
	EndWhile
	Float z = Math.sqrt((-2 * ApproximateNaturalLog(s, 0.1)) / s)
	Float Result1 = u * z
	Float Result2 = v * z
	Float[] Results = new Float[2]
	Results[0] = Result1
	Results[1] = Result2
	Return Results
EndFunction

Float Function ApproximateNaturalLog(Float x, Float precision)
	{Taken from http://www.gamesas.com/logarithm-function-t345141.html}
	 precision *= 2 ; since we double the result at the end
	 Float term = (x - 1) / (x + 1)
	 Float step = term * term
	 Float result = term
	 Float divisor = 1
	 Float delta = precision
	 While delta >= precision
		 term *= step
		 divisor += 2
		 delta = term / divisor
		 result += delta
	 EndWhile
	 Return 2.0 * result
 EndFunction

Int Function getPredDifficulty()
  Return 30
EndFunction

Int Function getPreyDifficulty()
  Return 30
EndFunction

Int Function genSoulSize(Actor akTarget)
  Race TargetRace = akTarget.GetRace()
  If TargetRace.HasKeyword(SCVSet.ActorTypeDwarven)
    Return 0
  EndIf
  Int Level = akTarget.GetLevel()
  If TargetRace.HasKeyword(SCVSet.ActorTypeDragon)
    Return 8
  ElseIf isBossActor(akTarget)
    Return 7
  ElseIf TargetRace.HasKeyword(SCVSet.ActorTypeNPC)
    Return 6
  ElseIf Level >= 38
    Return 5
  ElseIf Level >= 28
    Return 4
  ElseIf Level >= 16
    Return 3
  ElseIf Level >= 4
    Return 2
  ElseIf Level >= 1
    Return 1
  EndIf
EndFunction

Int Function fillGem(Actor akPred, Actor akPrey, Int aiTargetData = 0)
  {Searchs for a gem to fill and does so. Returns what kind of gem was filled.
  Returns -1 if a new gem was created, -2 if no gem was filled.}
  Int TargetData = getData(akPred, aiTargetData)
  Int PerkLevel = getCurrentPerkLevel(akPred, "SCV_PitOfSouls") - 1 ;We subtract one because the first level enables the function, the others increase gem size
  If PerkLevel < 0
    Return 0
  EndIf
  Notice("Bonus Level = " + PerkLevel)
  Int SoulSize = genSoulSize(akPrey)
  If SoulSize == 0  ;Has no soul to begin with
    Return -2
  EndIf
  Notice("Soul Size = " + SoulSize)
  Int[] Gems = getGemList(akPred, aiTargetData = TargetData)
  Int i = SoulSize
  i -= PerkLevel
  If i <= -1  ;Inserts SoulGem fragment if they have the lv 2 perk
    Notice("Soul fill size is less than 0! Inserting new gem...")
    addItem(akPred, akBaseObject = getGemTypes(0)[Utility.RandomInt(0, 4)], aiItemType = 2)
    Return -1
  EndIf
  Int Num = Gems.length - 1
  Bool Done
  While i < Num && !Done
    If Gems[i] > 0  ;If there is a gem with size equal to or greater than the soul size
      Notice("Found fillable gem! Soul Size = " + SoulSize + ", Gem size = " + i)
      replaceGem(akPred, i, SoulSize) ;input the original size and the new size
      Done = True
    Else
      i += 1
    EndIf
  EndWhile
  JMap.setInt(TargetData, "SCV_SoulsCaptured", JMap.getINt(TargetData, "SCV_SoulsCaptured") + 1)
  Return i
EndFunction

Bool Function hasGems(Actor akTarget, Int aiItemType = 2, Int aiTargetData = 0)
  {Returns if actor has valid soul gems located in contents 2, or whatever override
  Excludes dragon gems, as they can't be filled again}
  Int TargetData = getData(akTarget, aiTargetData)
  Int Contents = getContents(akTarget, aiItemType, TargetData)
  If JValue.empty(Contents)
    Return False
  EndIf
  Form i = JFormMap.nextKey(Contents)
  While i
    Form BaseObject
    If i as SCLBundle
      BaseObject = (i as SCLBundle).ItemForm
    ElseIf i as ObjectReference
      BaseObject = (i as ObjectReference).GetBaseObject()
    EndIf
    If BaseObject
      If BaseObject == SCVSet.SCV_SplendidSoulGem
        Return True
      ElseIf BaseObject == SCVSet.SoulGemBlack || BaseObject == SCVSet.SoulGemBlackFilled
        Return True
      ElseIf BaseObject == SCVSet.SoulGemGrand || BaseObject == SCVSet.SoulGemGrandFilled
        Return True
      ElseIf BaseObject == SCVSet.SoulGemGreater || BaseObject == SCVSet.SoulGemGreaterFilled
        Return True
      ElseIf BaseObject == SCVSet.SoulGemCommon || BaseObject == SCVSet.SoulGemCommonFilled
        Return True
      ElseIf BaseObject == SCVSet.SoulGemLesser || BaseObject == SCVSet.SoulGemLesserFilled
        Return True
      ElseIf BaseObject == SCVSet.SoulGemPetty || BaseObject == SCVSet.SoulGemPettyFilled
        Return True
      ElseIf BaseObject == SCVSet.SoulGemPiece001  || BaseObject == SCVSet.SoulGemPiece002 || BaseObject == SCVSet.SoulGemPiece003 || BaseObject == SCVSet.SoulGemPiece004 || BaseObject == SCVSet.SoulGemPiece005
        Return True
      EndIf
    EndIf
    i = JFormMap.nextKey(Contents, i)
  EndWhile
  Return False
EndFunction


Int[] Function getGemList(Actor akTarget, Int aiItemType = 2, Int aiTargetData = 0)
  {Returns array of soul gems located in contents 2, or whatever override
  Excludes dragon gems, as they can't be filled again}
  Int TargetData = getData(akTarget, aiTargetData)
  Int[] ReturnArray = New Int[8]
  Int Contents = getContents(akTarget, aiItemType, TargetData)
  If JValue.empty(Contents)
    Return ReturnArray
  EndIf
  Form i = JFormMap.nextKey(Contents)
  While i
    Form BaseObject
    If i as SCLBundle
      BaseObject = (i as SCLBundle).ItemForm
    ElseIf i as ObjectReference
      BaseObject = (i as ObjectReference).GetBaseObject()
    EndIf
    If BaseObject
      If BaseObject == SCVSet.SCV_SplendidSoulGem
        ReturnArray[7] = ReturnArray[7] + 1
      ElseIf BaseObject == SCVSet.SoulGemBlack || BaseObject == SCVSet.SoulGemBlackFilled
        ReturnArray[6] = ReturnArray[6] + 1
      ElseIf BaseObject == SCVSet.SoulGemGrand || BaseObject == SCVSet.SoulGemGrandFilled
        ReturnArray[5] = ReturnArray[5] + 1
      ElseIf BaseObject == SCVSet.SoulGemGreater || BaseObject == SCVSet.SoulGemGreaterFilled
        ReturnArray[4] = ReturnArray[4] + 1
      ElseIf BaseObject == SCVSet.SoulGemCommon || BaseObject == SCVSet.SoulGemCommonFilled
        ReturnArray[3] = ReturnArray[3] + 1
      ElseIf BaseObject == SCVSet.SoulGemLesser || BaseObject == SCVSet.SoulGemLesserFilled
        ReturnArray[2] = ReturnArray[2] + 1
      ElseIf BaseObject == SCVSet.SoulGemPetty || BaseObject == SCVSet.SoulGemPettyFilled
        ReturnArray[1] = ReturnArray[1] + 1
      ElseIf BaseObject == SCVSet.SoulGemPiece001  || BaseObject == SCVSet.SoulGemPiece002 || BaseObject == SCVSet.SoulGemPiece003 || BaseObject == SCVSet.SoulGemPiece004 || BaseObject == SCVSet.SoulGemPiece005
        ReturnArray[0] = ReturnArray[0] + 1
      EndIf
    EndIf
    i = JFormMap.nextKey(Contents, i)
  EndWhile
  Return ReturnArray
EndFunction

Form[] Function getGemTypes(Int aiSize)
  {Filled gems put in first}
  Form[] ReturnArray = new Form[5]
  If aiSize == 0
    ReturnArray[0] = SCVSet.SoulGemPiece001
    ReturnArray[1] = SCVSet.SoulGemPiece002
    ReturnArray[2] = SCVSet.SoulGemPiece003
    ReturnArray[3] = SCVSet.SoulGemPiece004
    ReturnArray[4] = SCVSet.SoulGemPiece005
  ElseIf aiSize == 1
    ReturnArray[0] = SCVSet.SoulGemPettyFilled
    ReturnArray[1] = SCVSet.SoulGemPetty
  ElseIf aiSize == 2
    ReturnArray[0] = SCVSet.SoulGemLesserFilled
    ReturnArray[1] = SCVSet.SoulGemLesser
  ElseIf aiSize == 3
    ReturnArray[0] = SCVSet.SoulGemCommonFilled
    ReturnArray[1] = SCVSet.SoulGemCommon
  ElseIf aiSize == 4
    ReturnArray[0] = SCVSet.SoulGemGreaterFilled
    ReturnArray[1] = SCVSet.SoulGemGreater
  ElseIf aiSize == 5
    ReturnArray[0] = SCVSet.SoulGemGrandFilled
    ReturnArray[1] = SCVSet.SoulGemGrand
  ElseIf aiSize == 6
    ReturnArray[0] = SCVSet.SoulGemBlackFilled
    ReturnArray[1] = SCVSet.SoulGemBlack
  ElseIf aiSize == 7
    ReturnArray[0] = SCVSet.SCV_SplendidSoulGem
  ElseIf aiSize == 8
    ReturnArray[0] = SCVSet.SCV_DragonGem
  EndIf
  Return ReturnArray
EndFunction

Function replaceGem(Actor akTarget, Int aiOriginal, Int aiNew, Int aiItemType = 2, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Form[] OriginalArray = getGemTypes(aiOriginal)
  Form[] NewArray = getGemTypes(aiNew)
  If aiOriginal == 0
    Form Fragment = findGemFragment(akTarget, aiItemType, TargetData)
    If Fragment
      RemoveItem(akTarget, akBaseObject = Fragment, aiItemType = aiItemType, abDelete = True, aiTargetData = TargetData)
    Else
      Return
    EndIf
  ElseIf !removeItem(akTarget, akBaseObject = OriginalArray[1], aiItemType = aiItemType, abDelete = True, aiTargetData = TargetData)
    If !removeItem(akTarget, akBaseObject = OriginalArray[0], aiItemType = aiItemType, abDelete = True, aiTargetData = TargetData)
      Return
    EndIf
  EndIf
  Notice("Default soul size for new gem = " + (OriginalArray[0] as SoulGem).GetSoulSize())
  addItem(akTarget, akBaseObject = NewArray[0], aiItemType = aiItemType)  ;Choose filled gem
EndFunction

Form Function findGemFragment(Actor akTarget, Int aiItemType, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Int Contents = getContents(akTarget, aiItemType, TargetData)
  Form SearchForm = JFormMap.nextKey(Contents)
  While SearchForm
    If SearchForm as ObjectReference
      Form CurrentForm
      If SearchForm as SCLBundle
        CurrentForm = (SearchForm as SCLBundle).ItemForm
      Else
        CurrentForm = (SearchForm as ObjectReference).GetBaseObject()
      EndIf
      If CurrentForm == SCVSet.SoulGemPiece001
        Return SCVSet.SoulGemPiece001
      ElseIf CurrentForm == SCVSet.SoulGemPiece002
        Return SCVSet.SoulGemPiece002
      ElseIf CurrentForm == SCVSet.SoulGemPiece003
        Return SCVSet.SoulGemPiece003
      ElseIf CurrentForm == SCVSet.SoulGemPiece004
        Return SCVSet.SoulGemPiece004
      ElseIf CurrentForm == SCVSet.SoulGemPiece005
        Return SCVSet.SoulGemPiece005
      EndIf
    EndIf
    SearchForm = JFormMap.nextKey(Contents, SearchForm)
  EndWhile
  Return None
EndFunction

;Perk Functions ****************************************************************
Spell[] Function getAbilityArray(String asPerkID)
  If asPerkID == "SCV_IntenseHunger"
    Return SCVSet.SCV_IntenseHungerAbilityArray
  ElseIf asPerkID == "SCV_MetalMuncher"
    Return SCVSet.SCV_MetalMuncherAbilityArray
  ElseIf asPerkID == "SCV_FollowerofNamira"
    Return SCVSet.SCV_FollowerofNamiraAbilityArray
  ElseIf asPerkID == "SCV_DragonDevourer"
    Return SCVSet.SCV_DragonDevourerAbilityArray
  ElseIf asPerkID == "SCV_SpiritSwallower"
    Return SCVSet.SCV_SpiritSwallowerAbilityArray
  ElseIf asPerkID == "SCV_ExpiredEpicurian"
    Return SCVSet.SCV_ExpiredEpicurianAbilityArray
  ElseIf asPerkID == "SCV_DaedraDieter"
    Return SCVSet.SCV_DaedraDieterAbilityArray
  ElseIf asPerkID == "SCV_Acid"
    Return SCVSet.SCV_AcidAbilityArray
  ElseIf asPerkID == "SCV_Stalker"
    Return SCVSet.SCV_StalkerAbilityArray
  ElseIf asPerkID == "SCV_RemoveLimits"
    Return SCVSet.SCV_RemoveLimitsAbilityArray
  ElseIf asPerkID == "SCV_Constriction"
    Return SCVSet.SCV_ConstrictionAbilityArray
  ElseIf asPerkID == "SCV_Nourish"
    Return SCVSet.SCV_NourishAbilityArray
  ElseIf asPerkID == "SCV_PitOfSouls"
    Return SCVSet.SCV_PitOfSoulsAbilityArray
  ElseIf asPerkID == "SCV_StrokeOfLuck"
    Return SCVSet.SCV_StrokeOfLuckAbilityArray
  ElseIf asPerkID == "SCV_ExpectPushback"
    Return SCVSet.SCV_ExpectPushbackAbilityArray
  ElseIf asPerkID == "SCV_CorneredRat"
    Return SCVSet.SCV_CorneredRatAbilityArray
  ElseIf asPerkID == "SCV_FillingMeal"
    Return SCVSet.SCV_FillingMealAbilityArray
  ElseIf asPerkID == "SCV_ThrillingStruggle"
    Return SCVSet.SCV_ThrillingStruggleAbilityArray
  ElseIf asPerkID == "SCV_PredLevel"
    Return SCVSet.SCV_PredLevelAbilityArray
  Else
    Return Parent.getAbilityArray(asPerkID)
  EndIf
EndFunction

Bool Function canTakePerk(Actor akTarget, String asPerkID, Bool abOverride = False, Int aiTargetData = 0)
  Int TargetData = getData(akTarget, aiTargetData)
  Int PerkLevel = getCurrentPerkLevel(akTarget, asPerkID)
  If abOverride && PerkLevel < getAbilityArray(asPerkID).Length - 1
    Return True
  ElseIf asPerkID == "SCV_IntenseHunger"
    If isOVPred(akTarget, TargetData)
      Int aiPerkLevel = PerkLevel + 1
      Int Req1
      Int Req2
      If aiPerkLevel == 1
        Req1 = 10
        Req2 = 15
      ElseIf aiPerkLevel == 2
        Req1 = 60
        Req2 = 35
      ElseIf aiPerkLevel == 3
        Req1 = 150
        Req2 = 60
      EndIf
      Int OVLevel = getOVLevelTotal(akTarget, TargetData)
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumOVPreyEaten")
      If aiPerkLevel <= 3 && NumEatenPrey >= Req2 && OVLevel >= Req2
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_MetalMuncher"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float DigestRate = JMap.getFlt(TargetData, "STDigestionRate")
      Int Level = akTarget.GetLevel()
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumDwarvenEaten")
      If aiPerkLevel == 1 && DigestRate >= 2 && Level >= 15 && PlayerRef.HasSpell(SCVSet.MS04Reward) ;Complete quest Unfathomable Depths
        Return True
      ElseIf aiPerkLevel == 2 && DigestRate >= 5 && Level >= 25 && NumEatenPrey >= 30 && SCVSet.MG06.GetStage() == 200 ;Complete Quest Revealing the Unseen
        Return True
      ElseIf aiPerkLevel == 3 && DigestRate >= 8 && Level >= 30 && NumEatenPrey >= 60 && (SCVSet.DA04.GetStage() == 100 || SCVSet.DA04.GetStage() == 105)  ;Complete (or fail) Quest Discerning the Transmundane
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_FollowerofNamira"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float Health = akTarget.GetBaseActorValue("Health")
      Int Level = akTarget.GetLevel()
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumHumansEaten")
      If aiPerkLevel == 1 && Health >= 150 && Level >= 5 && (SCVSet.DA11Intro.GetStage() == 20 || SCVSet.DA11Intro.GetStage() == 200) ;Complete Quest Investigate the Hall of The Dead
        Return True
      ElseIf aiPerkLevel == 2 && Health >= 250 && Level >= 10 && NumEatenPrey >= 30 && (SCVSet.DA05.GetStage() == 100 || SCVSet.DA05.GetStage() == 105 || SCVSet.DA05.GetStage() == 205 || SCVSet.C03.GetStage() == 200) ;Complete (or fail) Quest Ill Met By Moonlight || The Silver Hand
        Return True
      ElseIf aiPerkLevel == 3 && Health >= 350 && Level >= 30 && NumEatenPrey >= 100 && JMap.getInt(TargetData, "SCV_ImportantNPCsEaten") >= 10
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_DragonDevourer"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Int DragonsKilled = SCVSet.DragonsAbsorbed.GetValueInt()
      Int CurrentDragonSouls = JMap.getInt(getTargetData(PlayerRef), "SCV_DragonGemsConsumed")
      Int Level = akTarget.GetLevel()
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumDragonsEaten")
      If aiPerkLevel == 1 && DragonsKilled >= 30 && Level >= 30 && SCVSet.MQ203.GetStage() == 280 ;Complete Quest Alduin's Wall
        Return True
      ElseIf aiPerkLevel == 2 && DragonsKilled >= 70 && Level >= 50 && NumEatenPrey >= 20 && SCVSet.MQ305.GetStage() == 200 ;Complete Quest Dragonslayer
        Return True
      ElseIf aiPerkLevel == 3 && DragonsKilled >= 100 && Level >= 70 && NumEatenPrey >= 100 && CurrentDragonSouls >= 10
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_SpiritSwallower"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float Magicka = akTarget.GetBaseActorValue("Magicka")
      Int Level = akTarget.GetLevel()
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumGhostsEaten")
      If aiPerkLevel == 1 && Magicka >= 150 && Level >= 5 && SCVSet.FreeformIvarstead01.GetStage() == 200 ;Complete Quest Lifting the Shroud.
        Return True
      ElseIf aiPerkLevel == 2 && Magicka >= 200 && Level >= 10 && NumEatenPrey >= 5 && SCVSet.MG07.GetStage() == 200 ;Complete The Staff of Magnus
        Return True
      ElseIf aiPerkLevel == 3 && Magicka >= 300 && Level >= 15 && NumEatenPrey >= 15 && SCVSet.MS06.GetStage() == 250  ;Complete The Wolf Queen Awakened.
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_ExpiredEpicurian"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float Stamina = akTarget.GetBaseActorValue("Stamina")
      Int Level = akTarget.GetLevel()
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumUndeadEaten")
      If aiPerkLevel == 1 && Stamina >= 150 && Level >= 5 && SCVSet.dunAnsilvundQST.GetStage() == 100 ;Complete Ansilvund
        Return True
      ElseIf aiPerkLevel == 2 && Stamina >= 200 && Level >= 10 && NumEatenPrey >= 25 && SCVSet.dunGualdursonQST.GetStage() == 225 ;Complete Forbidden Legend
        Return True
      ElseIf aiPerkLevel == 3 && Stamina >= 300 && Level >= 15 && NumEatenPrey >= 15 && PlayerRef.HasMagicEffect(SCVSet.EnchDragonPriestUltraMaskEffect)  ;Obtain Konahrik
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_DaedraDieter"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float Conjure = akTarget.GetActorValue("Conjuration")
      Int Level = akTarget.GetLevel()
      Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumDaedraEaten")
      If aiPerkLevel == 1 && Conjure >= 25 && Level >= 10 && (SCVSet.DA01.GetStage() == 100 || SCVSet.DA01.GetStage() == 110 || SCVSet.DA01.GetStage() == 250);Complete The Black Star
        Return True
      ElseIf aiPerkLevel == 2 && Conjure >= 40 && Level >= 20 && NumEatenPrey >= 20 && (SCVSet.DA10.GetStage() == 200 || SCVSet.DA10.GetStage() == 500 || SCVSet.DA10.GetStage() == 550);Complete The House of Horrors
        Return True
      ElseIf aiPerkLevel == 3 && Conjure >= 60 && Level >= 30 && NumEatenPrey >= 50 && (SCVSet.DA07.GetStage() == 100 || SCVSet.DA07.GetStage() == 150 || SCVSet.DA07.GetStage() == 200) ;Complete Pieces of the Past
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_Acid"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float DigestRate = JMap.getFlt(TargetData, "STDigestionRate")
      Float NumFoodEaten = JMap.getFlt(TargetData, "STTotalDigestedFood")
      Float Req1
      Float Req2
      If aiPerkLevel == 1
        Req1 = 4
        Req2 = 350
      ElseIf aiPerkLevel == 2
        Req1 = 10
        Req2 = 700
      ElseIf aiPerkLevel == 3
        Req1 = 20
        Req2 = 1200
      EndIf
      If aiPerkLevel <= 3 && DigestRate >= Req1 && NumFoodEaten >= Req2
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_Stalker"
    If isPred(akTarget)
      Int aiPerkLevel = PerkLevel + 1
      Float Sneak = akTarget.GetActorValue("Sneak")
      Int Level = akTarget.GetLevel()
      If aiPerkLevel == 1 && PlayerRef.HasPerk(SCVSet.QuietCasting) && Sneak >= 25 && Level >= 10
        Return True
      ElseIf aiPerkLevel == 2 && Sneak >= 50 && Level >= 25 && SCVSet.TG08A.GetStage() == 200 ;Complete Trinity Restored
        Return True
      ElseIf aiPerkLevel == 3 && Sneak >= 75 && Level >= 35 && SCVSet.DB11.GetStage() == 200 ;Complete Hail Sithis!
        Return True
      EndIf
    EndIf
  ElseIf asPerkID == "SCV_RemoveLimits"
    Return False
    ;/Int aiPerkLevel = PerkLevel + 1
    If aiPerkLevel <= 3 && (isOVPred(akTarget) || abOverride)
      Return True
    EndIf/;
  ElseIf asPerkID == "SCV_Constriction"
    Int aiPerkLevel = PerkLevel + 1
    Int ArmorLevel = akTarget.GetActorValue("HeavyArmor") as Int
    Int Stamina = akTarget.GetActorValue("Stamina") as Int
    If aiPerkLevel == 1 && ArmorLevel >= 20 && Stamina >= 200 && SCVSet.dunTrevasWatchQST.GetStage() == 100 ;Complete Infiltration
      Return True
    ElseIf aiPerkLevel == 2 && ArmorLevel >= 40 && Stamina >= 300 && SCVSet.dunIronbindQST.GetStage() == 200  ;Complete Coming of Age at Ironbind Barrow
      Return True
    ElseIf aiPerkLevel == 3 && ArmorLevel >= 60 && Stamina >= 400 && SCVSet.dunMistwatchQST.GetStage() == 100
      Return True
    EndIf
    ;Others must be found in skill books
    ;The Serpent Stone
    ;Serpent's Bluff Redoubt
  ElseIf asPerkID == "SCV_Nourish"
    Int aiPerkLevel = PerkLevel + 1
    Int ArmorLevel = akTarget.GetActorValue("LightArmor") as Int
    Int Magicka = akTarget.GetActorValue("Magicka") as Int
    If aiPerkLevel == 1 && ArmorLevel >= 20 && Magicka >= 200 && SCVSet.MS14Quest.GetStage() == 200  ;Complete Laid to Rest
      Return True
    ElseIf aiPerkLevel == 2 && ArmorLevel >= 40 && Magicka >= 300 && SCVSet.Favor109.GetStage() == 20  ;Complete Kill the Vampire
      Return True
    ElseIf aiPerkLevel == 3 && ArmorLevel >= 60 && Magicka >= 400 && SCVSet.FreeformFalkreathQuest03B.GetStage() == 200  ;Complete Dark Ancestor
      Return True
    EndIf
    ;Somewhere in the jarl's palaces or a rich person's house.
  ElseIf asPerkID == "SCV_PitOfSouls"
    Int aiPerkLevel = PerkLevel + 1
    Int Enchant = akTarget.GetActorValue("Enchanting") as Int
    Int SpiritLevel = getCurrentPerkLevel(akTarget, "SCV_SpiritSwallower")
    Int Level = akTarget.GetLevel()
    Int NumSoulsCaptured = JMap.getInt(TargetData, "SCV_SoulsCaptured")
    If aiPerkLevel == 1 && Enchant >= 30 && SpiritLevel >= 1 && Level >= 15 && PlayerRef.hasPerk(SCVSet.SoulSqueezer)
      Return True
    ElseIf aiPerkLevel == 2 && Enchant >= 55 && SpiritLevel >= 2 && Level >= 30 && NumSoulsCaptured >= 30 && SCVSet.MGRArniel04.GetStage() == 200 ;Complete Arniel's Endeavor
      Return True
    ElseIf aiPerkLevel == 3 && Enchant >= 90 && Level >= 50 && NumSoulsCaptured >= 70 && SCVSet.MGRitual03.GetStage() == 200  ;Complete Conjuration Ritual Spell
      Return True
    EndIf
  ElseIf asPerkID == "SCV_StrokeOfLuck"
    Int aiPerkLevel = PerkLevel + 1
    Int Lockpicking = akTarget.GetActorValue("Lockpicking") as Int
    If aiPerkLevel == 1 && JMap.getInt(TargetData, "SCV_StrokeOfLuckAvoidVore") >= 5 && Lockpicking >= 25
      Return True
    ElseIf aiPerkLevel == 2 && JMap.getInt(TargetData, "SCV_StrokeOfLuckActivate") >= 5 && Lockpicking >= 55 && PlayerRef.HasPerk(SCVSet.GoldenTouch)
      Return True
    ElseIf aiPerkLevel == 3 && JMap.getInt(TargetData, "SCV_StrokeOfLuckActivate") >= 20 && Lockpicking >= 80 && SCVSet.TG09.GetStage() == 200  ;Complete Darkness Returns
      Return True
    EndIf
  ElseIf asPerkID == "SCV_ExpectPushback"
    Int Level = akTarget.GetLevel()
    Int aiPerkLevel = PerkLevel + 1
    If aiPerkLevel == 1 && PlayerRef.HasSpell(SCVSet.VoiceUnrelentingForce1) && Level >= 7 && SCVSet.FreeformRiften19.GetStage() == 20  ;Complete Bloody Nose
      Return True
    ElseIf aiPerkLevel == 2 && PlayerRef.HasSpell(SCVSet.VoiceUnrelentingForce2) && Level >= 15 && SCVSet.FreeformRiften09.GetStage() == 200 ;Complete Grimsever's Return
      Return True
    ElseIf aiPerkLevel == 2 && PlayerRef.HasSpell(SCVSet.VoiceUnrelentingForce3) && Level >= 25 && SCVSet.MQ204.GetStage() == 200 ;Complete The Throat of the World
    EndIf
  ElseIf asPerkID == "SCV_CorneredRat"
    Int aiPerkLevel = PerkLevel + 1
    If aiPerkLevel == 1 && JMap.getInt(TargetData, "SCV_NumTimesEaten") >= 1 && SCVSet.MQ202.GetStage() == 180  ;Complete A Cornered Rat
      Return True
    ElseIf aiPerkLevel == 2 && JMap.getInt(TargetData, "SCV_NumTimesEaten") >= 5 && SCVSet.MG08.GetStage() == 200 ;Complete The Eye of Magnus
      Return True
    ElseIf aiPerkLevel == 3 && JMap.getInt(TargetData, "SCV_NumTimesEaten") >= 15 && SCVSet.MQ301.GetStage() == 220 ; Complete The Fallen
      Return True
    EndIf
  ElseIf asPerkID == "SCV_FillingMeal"
    Int aiPerkLevel = PerkLevel + 1
    Float DigestValue = genDigestValue(akTarget, True)
    Int Level = akTarget.GetLevel()
    Int Resist = getResLevel(akTarget, TargetData)
    If aiPerkLevel == 1 && DigestValue >= 300 && Level >= 15
      Return True
    ElseIf aiPerkLevel == 2 && DigestValue >= 500 && Resist >= 30 && Level >= 25
      Return True
    ElseIf aiPerkLevel == 3 && DigestValue >= 800 && Resist >= 50 && Level >= 35
      Return True
    EndIf
  ElseIf asPerkID == "SCV_ThrillingStruggle"
    Int aiPerkLevel = PerkLevel + 1
    Int Resist = getResLevel(akTarget, TargetData)
    Float Energy = akTarget.GetBaseActorValue("Stamina") + akTarget.GetBaseActorValue("Magicka")
    If aiPerkLevel == 1 && Energy >= 250 && Resist >= 20
      Return True
    ElseIf aiPerkLevel == 1 && Energy >= 350 && Resist >= 40 && (SCVSet.MS02.GetStage() == 100 || SCVSet.MS02.GetStage() == 250)  ;Complete No One Escapes Cidhna Mine
      Return True
    ElseIf aiPerkLevel == 3 && Energy >= 700 && Resist >= 60 && SCVSet.MS07.GetStage() == 250 ;Complete Lights Out!
      Return True
    EndIf
  Else
    Return Parent.canTakePerk(akTarget, asPerkID, abOverride, TargetData)
  EndIf
EndFunction


;/Perk List
SCV_IntenseHunger
SCV_MetalMuncher
SCV_ExpiredEpicurian
SCV_FollowerofNamira
SCV_DaedraDieter
SCV_DragonDevourer
SCV_Constriction
SCV_SpiritSwallower
SCV_RemoveLimits
SCV_Nourish
SCV_Acid
SCV_Stalker
SCV_PitOfSouls

SCV_StruggleSorcery
SCV_StrokeOfLuck
SCV_ExpectPushback
SCV_CorneredRat
SCV_FillingMeal
SCV_ThrillingStruggle/;

;Menu Functions ***************************************************************
;If this works right, its the only one we actually need.
Bool Function buildActorStatsMenu(Actor akTarget)
  If !Parent.buildActorStatsMenu(akTarget)
    Return False
  EndIf
  UIListMenu LM_ST_Stats = UIExtensions.GetMenu("UIListMenu", False) as UIListMenu
  Int TargetData = getTargetData(akTarget)
  String TargetName = nameGet(akTarget)

  LM_ST_Stats.AddEntryItem("Resistance Level = " + getResLevel(akTarget, TargetData))
  JArray.addStr(JA_Description, TargetName + "'s learned resistance skill.")

  LM_ST_Stats.AddEntryItem("Resistance EXP = " + getResEXP(akTarget, TargetData) + "/" + getResEXPThreshold(getResLevel(akTarget, TargetData)))
  JArray.addStr(JA_Description, TargetName + "'s resistance experience.")

  LM_ST_Stats.AddEntryItem("")
  JArray.addStr(JA_Description, "")

  Bool isPred
  If (isOVPred(akTarget, TargetData) && isOVPred(PlayerRef)) || SCLSet.DebugEnable
    LM_ST_Stats.AddEntryItem("Oral Vore Level = " + getOVLevel(akTarget, TargetData))
    JArray.addStr(JA_Description, TargetName + "'s learned oral vore skill.")

    LM_ST_Stats.AddEntryItem("Extra Oral Vore Level = " + getOVLevelExtra(akTarget, TargetData))
    JArray.addStr(JA_Description, TargetName + "'s acquired oral vore skill.")

    LM_ST_Stats.AddEntryItem("Oral Vore EXP = " + getOVEXP(akTarget, TargetData) + "/" + getOVEXPThreshold(getOVLevel(akTarget, TargetData)))
    JArray.addStr(JA_Description, TargetName + "'s oral vore experience.")

    LM_ST_Stats.AddEntryItem("")
    JArray.addStr(JA_Description, "")
    isPred = True
  EndIf

  If (isAVPred(akTarget, TargetData) && isOVPred(PlayerRef)) || SCLSet.DebugEnable
    LM_ST_Stats.AddEntryItem("Anal Vore Level = " + getAVLevel(akTarget, TargetData))
    JArray.addStr(JA_Description, TargetName + "'s learned anal vore skill.")

    LM_ST_Stats.AddEntryItem("Extra Anal Vore Level = " + getAVLevelExtra(akTarget, TargetData))
    JArray.addStr(JA_Description, TargetName + "'s acquired anal vore skill.")

    LM_ST_Stats.AddEntryItem("Oral Vore EXP = " + getAVEXP(akTarget, TargetData) + "/" + getAVEXPThreshold(getAVLevel(akTarget, TargetData)))
    JArray.addStr(JA_Description, TargetName + "'s anal vore experience.")

    LM_ST_Stats.AddEntryItem("")
    JArray.addStr(JA_Description, "")
    isPred = True
  EndIf

  ;/If isPVPred(akTarget, TargetData)
    LM_ST_Stats.AddEntryItem("Urethral Vore Level = " + getPVLevel(akTarget, TargetData))
    JArray.addStr(JA_Description, TargetName + "'s learned anal vore skill.")

    LM_ST_Stats.AddEntryItem("Extra Urethral Vore Level = " + getPVLevelExtra(akTarget, TargetData))
    JArray.addStr(JA_Description, TargetName + "'s acquired anal vore skill.")

    LM_ST_Stats.AddEntryItem("Urethral Vore EXP = " + getPVEXP(akTarget, TargetData) + "/" + getOVEXPThreshold(getPVLevel(akTarget, TargetData)))
    JArray.addStr(JA_Description, TargetName + "'s anal vore experience.")
    isPred = True
  EndIf/;

  If isPred
    LM_ST_Stats.AddEntryItem("Predator Rank = " + calculatePredLevel(akTarget))
    JArray.addStr(JA_Description, TargetName + "'s Predator Ranking.")
  EndIf
  Return True
EndFunction

Bool Function buildActorMainMenu(Actor akTarget, Int aiMode = 0)
  UIWheelMenu WM_ActorMenu = UIExtensions.GetMenu("UIWheelMenu", True) as UIWheelMenu
  String ActorName = nameGet(akTarget)
  Int TargetData = getTargetData(akTarget)
  If !TargetData
    Notice(ActorName + " has no data! Can't build actor main menu! Canceling...")
    Return False
  EndIf
  Bool AllowCommandFunctions = False
  If akTarget == PlayerRef || akTarget.IsPlayerTeammate() || SCLSet.DebugEnable
    AllowCommandFunctions = True
  EndIf
  setWMItems(0, "Show Stats", "View Stomach Statistics", True)
  String PreviousMenuName = getActorMainMenuName(getPreviousActorMainMenu(0))
  If PreviousMenuName
    setWMItems(1, PreviousMenuName, "Display previous menu", True)
  EndIf
  If AllowCommandFunctions && isInPred(akTarget)
    setWMItems(2, "Pred", "Switch to pred menu", True)
  EndIf
  setWMItems(3, "Force Vomit", "Force actor to vomit all items", AllowCommandFunctions)
  setWMItems(4, "Perks Menu", "Show and take perks", True)
  String NextMenuName = getActorMainMenuName(getNextActorMainMenu(0))
  If NextMenuName
    setWMItems(5, NextMenuName, "Display Next Menu", True)
  EndIf
  If AllowCommandFunctions
    setWMItems(6, "Stomach Contents", "View contents and vomit specific items", True)
  Else
    setWMItems(6, "Stomach Contents", "Show all items in stomach", True)
  EndIf
  setWMItems(7, "Add Items", "Transfer items to stomach", AllowCommandFunctions)
  Return True
EndFunction

Function handleActorMainMenu(Actor akTarget, Int aiOption, Int aiMode)
  If aiOption == 0
    showActorStatsMenu(akTarget)
  ElseIf aiOption == 1
    openPreviousActorMainMenu(akTarget, 0)
  ElseIf aiOption == 2
    Actor Pred = getPred(akTarget)
    If Pred && (akTarget == PlayerRef || akTarget.IsPlayerTeammate() || SCLSet.DebugEnable) && (Pred == playerRef || Pred.IsPlayerTeammate() || SCLSet.DebugEnable)
      sendActorMainMenuOpenEvent(getPred(akTarget), 0)
    EndIf
  ElseIf aiOption == 3
    vomitAll(akTarget, False, False)
    quickUpdate(akTarget, True)
  ElseIf aiOption == 4
    showPerksList(akTarget)
  ElseIf aiOption == 5
    openNextActorMainMenu(akTarget, 0)
  ElseIf aiOption == 6
    If akTarget == PlayerRef || akTarget.IsPlayerTeammate() || SCLSet.DebugEnable
      showContentsList(akTarget, 1)
    Else
      showContentsList(akTarget)
    EndIf
  ElseIf aiOption == 7
    openTransferMenu(akTarget)
  EndIf
EndFunction

Function checkDebugSpells()
  If SCLSet.DebugEnable
    If !PlayerRef.HasSpell(SCVSet.SCV_MaxPredSpell)
      PlayerRef.AddSpell(SCVSet.SCV_MaxPredSpell, True)
    EndIf

    If !PlayerRef.HasSpell(SCVSet.SCV_ForceOVoreSpell)
      PlayerRef.AddSpell(SCVSet.SCV_ForceOVoreSpell, True)
    EndIf
    If !PlayerRef.HasSpell(SCVSet.SCV_ForceOVoreSpellNonLethal)
      PlayerRef.AddSpell(SCVSet.SCV_ForceOVoreSpellNonLethal, True)
    EndIf

    If !PlayerRef.HasSpell(SCVSet.SCV_ForceRandomOVoreSpell)
      PlayerRef.AddSpell(SCVSet.SCV_ForceRandomOVoreSpell, True)
    EndIf
    If !PlayerRef.HasSpell(SCVSet.SCV_ForceRandomOVoreSpellNonLethal)
      PlayerRef.AddSpell(SCVSet.SCV_ForceRandomOVoreSpellNonLethal, True)
    EndIf

    If !PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificOVoreSpell)
      PlayerRef.AddSpell(SCVSet.SCV_ForceSpecificOVoreSpell, True)
    EndIf
    If !PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificOVoreSpellNonLethal)
      PlayerRef.AddSpell(SCVSet.SCV_ForceSpecificOVoreSpellNonLethal, True)
    EndIf

    If !PlayerRef.HasSpell(SCVSet.SCV_ForceAVoreSpell)
      PlayerRef.AddSpell(SCVSet.SCV_ForceAVoreSpell, True)
    EndIf
    If !PlayerRef.HasSpell(SCVSet.SCV_ForceAVoreSpellNonLethal)
      PlayerRef.AddSpell(SCVSet.SCV_ForceAVoreSpellNonLethal, True)
    EndIf

    If !PlayerRef.HasSpell(SCVSet.SCV_ForceRandomAVoreSpell)
      PlayerRef.AddSpell(SCVSet.SCV_ForceRandomAVoreSpell, True)
    EndIf
    If !PlayerRef.HasSpell(SCVSet.SCV_ForceRandomAVoreSpellNonLethal)
      PlayerRef.AddSpell(SCVSet.SCV_ForceRandomAVoreSpellNonLethal, True)
    EndIf

    If !PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificAVoreSpell)
      PlayerRef.AddSpell(SCVSet.SCV_ForceSpecificAVoreSpell, True)
    EndIf
    If !PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificAVoreSpellNonLethal)
      PlayerRef.AddSpell(SCVSet.SCV_ForceSpecificAVoreSpellNonLethal, True)
    EndIf
  Else
    If PlayerRef.HasSpell(SCVSet.SCV_MaxPredSpell)
      PlayerRef.RemoveSpell(SCVSet.SCV_MaxPredSpell)
    EndIf

    If PlayerRef.HasSpell(SCVSet.SCV_ForceOVoreSpell)
			PlayerRef.RemoveSpell(SCVSet.SCV_ForceOVoreSpell)
		EndIf
    If PlayerRef.HasSpell(SCVSet.SCV_ForceOVoreSpellNonLethal)
      PlayerRef.RemoveSpell(SCVSet.SCV_ForceOVoreSpellNonLethal)
    EndIf

    If PlayerRef.HasSpell(SCVSet.SCV_ForceRandomOVoreSpell)
      PlayerRef.removespell(SCVSet.SCV_ForceRandomOVoreSpell)
    EndIf
    If PlayerRef.HasSpell(SCVSet.SCV_ForceRandomOVoreSpellNonLethal)
      PlayerRef.removespell(SCVSet.SCV_ForceRandomOVoreSpellNonLethal)
    EndIf

    If PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificOVoreSpell)
      PlayerRef.removespell(SCVSet.SCV_ForceSpecificOVoreSpell)
    EndIf
    If PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificOVoreSpellNonLethal)
      PlayerRef.removespell(SCVSet.SCV_ForceSpecificOVoreSpellNonLethal)
    EndIf

    If PlayerRef.HasSpell(SCVSet.SCV_ForceAVoreSpell)
      PlayerRef.RemoveSpell(SCVSet.SCV_ForceAVoreSpell)
    EndIf
    If PlayerRef.HasSpell(SCVSet.SCV_ForceAVoreSpellNonLethal)
      PlayerRef.RemoveSpell(SCVSet.SCV_ForceAVoreSpellNonLethal)
    EndIf

    If PlayerRef.HasSpell(SCVSet.SCV_ForceRandomAVoreSpell)
      PlayerRef.removespell(SCVSet.SCV_ForceRandomAVoreSpell)
    EndIf
    If PlayerRef.HasSpell(SCVSet.SCV_ForceRandomAVoreSpellNonLethal)
      PlayerRef.removespell(SCVSet.SCV_ForceRandomAVoreSpellNonLethal)
    EndIf

    If PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificAVoreSpell)
      PlayerRef.removespell(SCVSet.SCV_ForceSpecificAVoreSpell)
    EndIf
    If PlayerRef.HasSpell(SCVSet.SCV_ForceSpecificAVoreSpellNonLethal)
      PlayerRef.removespell(SCVSet.SCV_ForceSpecificAVoreSpellNonLethal)
    EndIf
  EndIf
EndFunction

;/String Function getPerkDescription(String asPerkID, Int aiPerkLevel = 0)
  If asPerkID == "SCV_IntenseHunger"
    If aiPerkLevel == 0
      Return "No Requirement"
    ElseIf aiPerkLevel == 1
      Return "Increases success chance of swallow spells by 5%." ;Each rank increase it by 5%, so we need to adjust the magnitudes in the CK
    ElseIf aiPerkLevel == 2
      Return "Increases success chance of swallow spells by another 5%."
    ElseIf aiPerkLevel >= 3
      Return "Increases success chance of swallow spells by 10%."
    EndIf
  ElseIf asPerkID == "SCV_MetalMuncher"
    If aiPerkLevel == 0 || aiPerkLevel == 1
      Return "Allows you to eat Dwemer Automatons."
    ElseIf aiPerkLevel == 2
      Return "Increases chances of success in devouring Dwemer Automatons by 5% and gives a chance of acquiring bonus items from them."
    ElseIf aiPerkLevel >= 3
      Return "Increases chances of success in devouring Dwemer Automatons by 10%."
    EndIf
  ElseIf asPerkID == "SCV_FollowerofNamira"
    If aiPerkLevel == 0 || aiPerkLevel == 1
      Return "Allows you to eat humans."
    ElseIf aiPerkLevel == 2
      Return "Increases chances of success in devouring humans by 5% and gives a chance of acquiring bonus items from them."
    ElseIf aiPerkLevel >= 3
      Return "Increases chances of success in devouring humans by 10%."
    EndIf
  ElseIf asPerkID == "SCV_DragonDevourer"
    If aiPerkLevel == 0 || aiPerkLevel == 1
      Return "Allows you to eat dragons."
    ElseIf aiPerkLevel == 2
      Return "Increases chances of success in devouring dragons by 5%."
    ElseIf aiPerkLevel >= 3
      Return "Increases chances of success in devouring dragons by another 5% and gives a chance of acquiring bonus items from them."
    EndIf
  ElseIf asPerkID == "SCV_SpiritSwallower"
    If aiPerkLevel == 0 || aiPerkLevel == 1
      Return "Allows you to eat ghosts."
    ElseIf aiPerkLevel == 2
      Return "Increases chances of success in devouring ghosts by 5% and gives a chance of acquiring bonus items from them."
    ElseIf aiPerkLevel >= 3
      Return "Increases chances of devouring ghosts by 10%."
    EndIf
  ElseIf asPerkID == "SCV_ExpiredEpicurian"
    If aiPerkLevel == 0 || aiPerkLevel == 1
      Return "Allows you to eat the undead."
    ElseIf aiPerkLevel == 2
      Return "Increases chances of success in devouring the undead by 5% and gives a chance of acquiring bonus items from them."
    ElseIf aiPerkLevel >= 3
      Return "Increases chances of devouring the undead by 10%."
    EndIf
  ElseIf asPerkID == "SCV_DaedraDieter"
    If aiPerkLevel == 0 || aiPerkLevel == 1
      Return "Allows you to eat daedra."
    ElseIf aiPerkLevel == 2
      Return "Increases chances of devouring daedra by 5%."
    ElseIf aiPerkLevel >= 3
      Return "Increases chances of success in devouring daedra by another 5% and gives a chance of acquiring bonus items from them."
    EndIf
  ElseIf asPerkID == "SCV_Acid"
    If aiPerkLevel == 0
      Return "Deals health damage to struggling prey."
    ElseIf aiPerkLevel == 1
      Return "Deals slight health damage to struggling prey."
    ElseIf aiPerkLevel == 2
      Return "Deals moderate health damage to struggling prey."
    ElseIf aiPerkLevel >= 3
      Return "Deals heavy health damage to struggling prey."
    EndIf
  ElseIf asPerkID == "SCV_Stalker"
    If aiPerkLevel == 0
      Return "Increases swallow success chance when sneaking and unseen by your prey."
    ElseIf aiPerkLevel == 1
      Return "Increases swallow success chance by 20% when sneaking and unseen by your prey."
    ElseIf aiPerkLevel == 2
      Return "Increases swallow success chance by another 20% when sneaking and unseen by your prey. Increases movement speed slightly while you have struggling prey and are sneaking."
    ElseIf aiPerkLevel >= 3
      Return "Increases swallow success chance by yet another 20% when sneaking and unseen by your prey. Increases movement speed significantly while you have struggling prey and are sneaking."
    EndIf
  ElseIf asPerkID == "SCV_RemoveLimits"
    Return "Allows one to devour even if it would it put one above their max."
  ElseIf asPerkID == "SCV_Constriction"
    If aiPerkLevel == 0
      Return "Increases stamina/magicka damage done to struggling prey."
    ElseIf aiPerkLevel == 1
      Return "Increases stamina/magicka damage done to struggling prey slightly."
    ElseIf aiPerkLevel == 2
      Return "Increases stamina/magicka damage done to struggling prey moderately."
    ElseIf aiPerkLevel >= 3
      Return "Increases stamina/magicka damage done to struggling prey significantly."
    EndIf
  ElseIf asPerkID == "SCV_Nourish"
    If aiPerkLevel == 0
      Return "Gives health regeneration when one has digesting prey."
    ElseIf aiPerkLevel == 1
      Return "Gives slight health regeneration when one has digesting prey."
    ElseIf aiPerkLevel == 2
      Return "Gives slight health and stamina regeneration when one has digesting prey."
    ElseIf aiPerkLevel >= 3
      Return "Gives slight health, stamina, and magicka regeneration when one has digesting prey."
    EndIf
  ElseIf asPerkID == "SCV_PitOfSouls"
    If aiPerkLevel == 0
      Return "Enables one to capture enemy souls."
    ElseIf aiPerkLevel == 1
      Return "Enables one to capture enemy souls by storing soul gems in their stomach."
    ElseIf aiPerkLevel == 2
      Return "Soul gems can now capture souls one size bigger."
    ElseIf aiPerkLevel == 3
      Return "Soul gems can now capture souls two sizes bigger."
    EndIf
  ElseIf asPerkID == "SCV_StrokeOfLuck"
    If aiPerkLevel == 0
      Return "Gives a chance that a pred's devour attempt will fail."
    ElseIf aiPerkLevel == 1
      Return "Gives a 10% chance that a predator's devour attempt will fail."
    ElseIf aiPerkLevel == 2
      Return "Gives a 20% chance that a predator's devour attempt will fail."
    ElseIf aiPerkLevel >= 3
      Return "Gives a 30% chance that a predator's devour attempt will fail."
    EndIf
  ElseIf asPerkID == "SCV_ExpectPushback"
    If aiPerkLevel == 0
      Return "Knock back enemies back after an enemy's failed devour attempt."
    ElseIf aiPerkLevel == 1
      Return "Has a 50% chance of knocking enemies back after an enemy's failed devour attempt."
    ElseIf aiPerkLevel == 2
      Return "Increases range of knock back."
    ElseIf aiPerkLevel >= 3
      Return "Knock back occurs for every failed devour attempt."
    EndIf
  ElseIf asPerkID == "SCV_CorneredRat"
    If aiPerkLevel == 0
      Return "Deals health damage to one's pred."
    ElseIf aiPerkLevel == 1
      Return "Deals slight health damage to one's predator."
    ElseIf aiPerkLevel == 2
      Return "Deals moderate health damage to one's predator."
    ElseIf aiPerkLevel >= 3
      Return "Deals heavy health damage to one's predator."
    EndIf
  ElseIf asPerkID == "SCV_FillingMeal"
    If aiPerkLevel == 0
      Return "Increase's one's size while inside a predator."
    ElseIf aiPerkLevel == 1
      Return "Increase's one's size while inside a predator by 20%."
    ElseIf aiPerkLevel == 2
      Return "Increase's one's size while inside a predator by 40%."
    ElseIf aiPerkLevel >= 3
      Return "Increase's one's size while inside a predator by 60%."
    EndIf
  ElseIf asPerkID == "SCV_ThrillingStruggle"
    If aiPerkLevel == 0
      Return "Increases stamina/magicka damage done to one's predator."
    ElseIf aiPerkLevel == 1
      Return "Increases stamina/magicka damage done to one's predator slightly."
    ElseIf aiPerkLevel == 2
      Return "Increases stamina/magicka damage done to one's predator moderately."
    ElseIf aiPerkLevel == 3
      Return "Increases stamina/magicka damage done to one's predator significantly."
    EndIf
  Else
    Return Parent.getPerkDescription(asPerkID, aiPerkLevel)
  EndIf
EndFunction

String Function getPerkRequirements(String asPerkID, Int aiPerkLevel)
  If asPerkID == "SCV_IntenseHunger"
    Int Req1
    Int Req2
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Req1 = 10
      Req2 = 15
    ElseIf aiPerkLevel == 2
      Req1 = 60
      Req2 = 35
    ElseIf aiPerkLevel == 3
      Req1 = 150
      Req2 = 60
    EndIf
    Return "Have an oral predator skill level of " + Req2 + " and consume " + Req1 + " prey."
  ElseIf asPerkID == "SCV_MetalMuncher"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have a digestion rate of at least 2, be at level 15, and possess the knowledge of the ancient Dwemer."
    ElseIf aiPerkLevel == 2
      Return "Have a digestion rate of at least 5, be at level 25, consume 30 Dwemer Automatons, and discover the secret of the Dwemer Oculory."
    ElseIf aiPerkLevel == 3
      Return "Have a digestion rate of at least 8, be at level 30, consume 60 Dwemer Automatons, and unlock the container with the heart of a god."
    EndIf
  ElseIf asPerkID == "SCV_FollowerofNamira"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have more than 150 health, be at level 5, and experience contact with the Lady of Decay."
    ElseIf aiPerkLevel == 2
      Return "Have more than 250 health, be at level 10, consume 30 humans, and discover your inner beast for the first time."
    ElseIf aiPerkLevel == 3
      Return "Have more than 350 health, be at level 30, consume 60 humans, and devour 10 important people."
    EndIf
  ElseIf asPerkID == "SCV_DragonDevourer"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Slay more than 30 dragons, be at level 30, and learn more about your nemesis."
    ElseIf aiPerkLevel == 2
      Return "Slay more than 70 dragons, consume 20 of them, be at level 50, and defeat the one who will consume the world."
    ElseIf aiPerkLevel == 3
      Return "Slay more than 100 dragons, consume 100 of them, be at level 70, and consume the essence of dragons at least 10 times."
    EndIf
  ElseIf asPerkID == "SCV_SpiritSwallower"
    If aiPerkLevel == 0
      Return "No Requirements"
    ElseIf aiPerkLevel == 1
      Return "Have more than 150 magicka, be at level 5, and discover the source of the mysterious events happening in Ivarstead."
    ElseIf aiPerkLevel == 2
      Return "Have more than 200 magicka, be at level 10, consume 5 spirits, and free the spirits trapped in the maze."
    ElseIf aiPerkLevel == 3
      Return "Have more than 300 magicka, be at level 15, consume 15 spirits, and stop a terrible evil from being reawakened."
    EndIf
  ElseIf asPerkID == "SCV_ExpiredEpicurian"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have more than 150 Stamina, be at level 5, and defeat the conjurer keeping the lovers apart."
    ElseIf aiPerkLevel == 2
      Return "Have more than 200 Stamina, be at level 10, consume 5 undead, and retrieve the amulet that destroyed a family."
    ElseIf aiPerkLevel == 3
      Return "Have more than 300 Stamina, be at level 15, consume 15 undead, and wear the mysterious mask of Konahrik."
    EndIf
  ElseIf asPerkID == "SCV_DaedraDieter"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 25 Conjuration Skill, be at level 10, and perform a task for the Prince of Dawn and Dusk."
    ElseIf aiPerkLevel == 2
      Return "Have at least 40 Conjuration Skill, be at level 20, consume 20 daedric enemies, and investigate the cursed stone home."
    ElseIf aiPerkLevel == 3
      Return "Have at least 60 Conjuration Skill, be at level 30, consume 50 daedric enemies, and reassemble a terrible weapon."
    EndIf
  ElseIf asPerkID == "SCV_Acid"
    Float Req1
    Float Req2
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Req1 = 4
      Req2 = 35
    ElseIf aiPerkLevel == 2
      Req1 = 10
      Req2 = 70
    ElseIf aiPerkLevel == 3
      Req1 = 20
      Req2 = 120
    EndIf
    Return "Have a Digestion Rate of at least " + Req1 + " and digest at least " + Req2 + " units of food."
  ElseIf asPerkID == "SCV_Stalker"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 25 Sneak, be at least level 10, and have the ability to cast spells quietly."
    ElseIf aiPerkLevel == 2
      Return "Have at least 50 Sneak, be at least level 25, and join with the Nightingales."
    ElseIf aiPerkLevel == 3
      Return "Have at least 75 Sneak, be at least level 35 and pull off the greatest assassination in all of Tamriel."
    EndIf
  ElseIf asPerkID == "SCV_RemoveLimits"
    Return "????"
  ElseIf asPerkID == "SCV_Constriction"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 20 Heavy Armor, have at least 200 Stamina, and infiltrate an ancient fort on the behalf of another."
    ElseIf aiPerkLevel == 2
      Return "Have at least 40 Heavy Armor, have at least 300 Stamina, and help a young woman discover the truth about her companion."
    ElseIf aiPerkLevel == 3
      Return "Have at least 60 Heavy Armor, have at least 400 Stamina and help set a man's wife free."
    EndIf
  ElseIf asPerkID == "SCV_Nourish"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 20 Light Armor, have at least 200 Magicka, and discover the cause of a tragic fire."
    ElseIf aiPerkLevel == 2
      Return "Have at least 40 Light Armor, have at least 300 Magicka, and assist the wizard of the Blue Palace."
    ElseIf aiPerkLevel == 3
      Return "Have at least 60 Light Armor, have at least 400 Magicka and put an end to a sealed evil in Falkreath."
    EndIf
  ElseIf asPerkID == "SCV_PitOfSouls"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 30 Enchanting, have at least Spirit Swallower Lv. 1, be at level 15, and have the perk 'Soul Squeezer'."
    ElseIf aiPerkLevel == 2
      Return "Have at least 55 Enchanting, have at least Spirit Swallower Lv. 2, be at level 30, capture at least 30 souls by devouring them, and assist a wizard in his studies into the Dwemer disappearance."
    ElseIf aiPerkLevel == 3
      Return "Have at least 90 Enchanting, be at level 50, capture at least 70 souls by devouring them, and become a master Conjurer."
    EndIf
  ElseIf asPerkID == "SCV_StrokeOfLuck"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 25 Lockpicking, and avoid being eaten 5 times."
    ElseIf aiPerkLevel == 2
      Return "Have at least 55 Lockpicking, have at least 5 lucky moments, and be very fortunate in finding gold."
    ElseIf aiPerkLevel == 3
      Return "Have at least 60 Lockpicking, have at least 20 lucky moments, and perform your deed to the darkness."
    EndIf
  ElseIf asPerkID == "SCV_ExpectPushback"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Possess the word 'Force', be at level 7, and show your prowess of hand-to-hand combat in Riften."
    ElseIf aiPerkLevel == 2
      Return "Possess the word 'Balance', be at level 15, and a retrieve a woman's prized weapon for her."
    ElseIf aiPerkLevel == 3
      Return "Possess the word 'Push', be at level 25, and meet a true master of the Voice."
    EndIf
  ElseIf asPerkID == "SCV_CorneredRat"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Be eaten at least once and survive, and locate a man hiding for his life surrounded by rats."
    ElseIf aiPerkLevel == 2
      Return "Be eaten at least 5 times and survive, and put an end to the man who sealed himself away for a chance at power."
    ElseIf aiPerkLevel == 3
      Return "Be eaten at least 15 times and survive, and help capture a powerful beast."
    EndIf
  ElseIf asPerkID == "SCV_FillingMeal"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Take up at least 300 units in a prey's stomach and be at level 15."
    ElseIf aiPerkLevel == 2
      Return "Take up at least 500 units in a prey's stomach, be at level 25, and have a resistance skill of at least 30."
    ElseIf aiPerkLevel == 3
      Return "Take up at least 800 units in a prey's stomach, be at level 35, and have a resistance skill of at least 50."
    EndIf
  ElseIf asPerkID == "SCV_ThrillingStruggle"
    If aiPerkLevel == 0
      Return "No Requirements."
    ElseIf aiPerkLevel == 1
      Return "Have at least 250 points of energy and a resistance skill of at least 20."
    ElseIf aiPerkLevel == 2
      Return "Have at least 350 points of energy, a resistance skill of at least 40, and escape a wrongful imprisonment."
    ElseIf aiPerkLevel == 3
      Return "Have at least 700 points of energy, a resistance skill of at least 60, and cause an incident at sea."
    EndIf
  Else
    Return Parent.getPerkRequirements(asPerkID, aiPerkLevel)
  EndIf
EndFunction/;
