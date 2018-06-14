ScriptName SCVSettings Extends Quest

GlobalVariable Property SCV_SET_OVPredPercent Auto
Int Property OVPredPercent
  Int Function Get()
    Return SCV_SET_OVPredPercent.GetValueInt()
  EndFunction
  Function Set(Int a_val)
    If a_val >= 0 && a_val <= 100
      SCV_SET_OVPredPercent.SetValueInt(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_AVPredPercent Auto
Int Property AVPredPercent
  Int Function Get()
    Return SCV_SET_AVPredPercent.GetValueInt()
  EndFunction
  Function Set(Int a_val)
    If a_val >= 0 && a_val <= 100
      SCV_SET_AVPredPercent.SetValueInt(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_EnablePlayerEssentialVore Auto
Bool Property EnablePlayerEssentialVore
  Bool Function Get()
    Return SCV_SET_EnablePlayerEssentialVore.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCV_SET_EnablePlayerEssentialVore.SetValueInt(1)
    Else
      SCV_SET_EnablePlayerEssentialVore.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_EnableEssentialVore Auto
Bool Property EnableEssentialVore
  Bool Function Get()
    Return SCV_SET_EnableEssentialVore.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCV_SET_EnableEssentialVore.SetValueInt(1)
    Else
      SCV_SET_EnableEssentialVore.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_EnableMPreds Auto
Bool Property EnableMPreds
  Bool Function Get()
    Return SCV_SET_EnableMPreds.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCV_SET_EnableMPreds.SetValueInt(1)
    Else
      SCV_SET_EnableMPreds.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_EnableMTeamPreds Auto
Bool Property EnableMTeamPreds
  Bool Function Get()
    Return SCV_SET_EnableMTeamPreds.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCV_SET_EnableMTeamPreds.SetValueInt(1)
    Else
      SCV_SET_EnableMTeamPreds.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_EnableFPreds Auto
Bool Property EnableFPreds
  Bool Function Get()
    Return SCV_SET_EnableFPreds.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCV_SET_EnableFPreds.SetValueInt(1)
    Else
      SCV_SET_EnableFPreds.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_EnableFTeamPreds Auto
Bool Property EnableFTeamPreds
  Bool Function Get()
    Return SCV_SET_EnableFTeamPreds.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCV_SET_EnableFTeamPreds.SetValueInt(1)
    Else
      SCV_SET_EnableFTeamPreds.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_StruggleMod Auto ;Default 1
Float Property StruggleMod
  Float Function Get()
    Return SCV_SET_StruggleMod.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCV_SET_StruggleMod.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_DamageMod Auto  ;Default 1
Float Property DamageMod
  Float Function Get()
    Return SCV_SET_DamageMod.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCV_SET_DamageMod.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCV_SET_AVDestinationChoice Auto
Int Property AVDestinationChoice
  Int Function Get()
    Return SCV_SET_AVDestinationChoice.GetValueInt()
  EndFunction
  Function Set(Int a_val)
    SCV_SET_AVDestinationChoice.SetValueInt(a_val)
  EndFunction
EndProperty

Spell Property SCV_SwallowLethal Auto
Spell Property SCV_SwallowNonLethal Auto
Spell Property SCV_TakeInLethal Auto
Spell Property SCV_TakeInNonLethal Auto

Keyword Property SCV_DamageKeyword Auto

Spell Property SCV_StruggleDispel Auto
Spell Property SCV_PredMarker Auto
Spell Property SCV_OVPredMarker Auto
Spell Property SCV_AVPredMarker Auto
Spell Property SCV_OVFrenzySelfSpell01 Auto
Spell Property SCV_Alpha0Spell01 Auto

MagicEffect Property SCV_FrenzyLevel2 Auto
MagicEffect Property SCV_FrenzyLevel1 Auto

Spell[] Property StruggleArray Auto
Spell[] Property DamageArray Auto
Spell[] Property NourishArray Auto

Spell [] Property SCV_IntenseHungerAbilityArray Auto
Spell [] Property SCV_MetalMuncherAbilityArray Auto
Spell [] Property SCV_FollowerofNamiraAbilityArray Auto
Spell [] Property SCV_DragonDevourerAbilityArray Auto
Spell [] Property SCV_SpiritSwallowerAbilityArray Auto
Spell [] Property SCV_ExpiredEpicurianAbilityArray Auto
Spell [] Property SCV_DaedraDieterAbilityArray Auto
Spell [] Property SCV_AcidAbilityArray Auto
Spell [] Property SCV_StalkerAbilityArray Auto
Spell [] Property SCV_RemoveLimitsAbilityArray Auto
Spell [] Property SCV_ConstrictionAbilityArray Auto
Spell [] Property SCV_NourishAbilityArray Auto
Spell [] Property SCV_PitOfSoulsAbilityArray Auto
Spell [] Property SCV_PredLevelAbilityArray Auto


Spell [] Property SCV_StrokeOfLuckAbilityArray Auto
Spell [] Property SCV_ExpectPushbackAbilityArray Auto
Spell [] Property SCV_CorneredRatAbilityArray Auto
Spell [] Property SCV_FillingMealAbilityArray Auto
Spell [] Property SCV_ThrillingStruggleAbilityArray Auto
Spell Property StruggleSorceryPerk Auto
Spell Property SCV_ExpectPushbackBuffSpell Auto


Spell Property SCV_MaxPredSpell Auto

Spell Property SCV_ForceOVoreSpell Auto
Spell Property SCV_ForceOVoreSpellNonLethal Auto
Spell Property SCV_ForceRandomOVoreSpell Auto
Spell Property SCV_ForceRandomOVoreSpellNonLethal Auto
Spell Property SCV_ForceSpecificOVoreSpell Auto
Spell Property SCV_ForceSpecificOVoreSpellNonLethal Auto

Spell Property SCV_ForceAVoreSpell Auto
Spell Property SCV_ForceAVoreSpellNonLethal Auto
Spell Property SCV_ForceRandomAVoreSpell Auto
Spell Property SCV_ForceRandomAVoreSpellNonLethal Auto
Spell Property SCV_ForceSpecificAVoreSpell Auto
Spell Property SCV_ForceSpecificAVoreSpellNonLethal Auto


Spell Property SCV_HasOVStrugglePrey Auto
Spell Property SCV_HasAVStrugglePrey Auto

Spell Property SCV_HasDigestingPrey Auto

Keyword Property ActorTypeDwarven Auto
Keyword Property ActorTypeDragon Auto
Keyword Property ActorTypeGhost Auto
Keyword Property ActorTypeDaedra Auto
Keyword Property ActorTypeUndead Auto
Keyword Property ActorTypeNPC Auto

Race Property WolfRace Auto

LeveledItem Property SCV_LeveledHumanItems Auto
LeveledItem Property SCV_LeveledDragonItems Auto
LeveledItem Property SCV_LeveledDwarvenItems Auto
LeveledItem Property SCV_LeveledGhosttems Auto
LeveledItem Property SCV_LeveledUndeadItems Auto
LeveledItem Property SCV_LeveledDaedraItems Auto
LeveledItem Property SCV_LeveledBossItems Auto

Formlist Property SCV_InVoreActionList Auto ; Prevents any vore actions if they are already in one
Faction Property SCV_FACT_OVPredBlocked Auto
Faction Property SCV_FACT_AVPredBlocked Auto
Faction Property SCV_FACT_PreyProtected Auto
Faction Property SCV_FACT_Animated Auto

ReferenceAlias Property SCV_FollowPred Auto

ObjectReference Property SCV_TransferChest Auto

SCVInsertPreyThreadManager Property InsertPreyThreadManager Auto
SCVProcessPreyThreadManager Property ProcessPreyThreadManager Auto
SCVAnimationThreadHandler Property AnimationThreadHandler Auto
SCVInsertItemsContainer Property SCV_InsertItemsChest Auto
SCVEssentialTracker Property SCVEssential Auto

;AI Package Spells
Spell Property SCV_AIFindOVPreySpell01a Auto
Spell Property SCV_AIFindOVPreySpellStop01 Auto

;Mod References (Fill these in using a patch)
;SCA ---------------------------------------------------------------------------
;Bool Property SCA_Initialized = False Auto
;/SCALibrary Property SCALib Auto
SCASettings Property SCASet Auto
SCADatabase Property SCAData Auto
SCAModConfig Property SCAMCM Auto/;

;Size Matters ------------------------------------------------------------------
Bool Property SizeMatters_Initialized = False Auto
Bool Property SizeMattersActive = True Auto

;Sound Effects *****************************************************************
Topic Property SCV_SwallowSound Auto
Topic Property SCV_TakeInSound Auto

Topic Property SCV_BurpSound Auto
Topic Property SCV_HurtSound Auto
Topic Property SCV_AFinishSound Auto
;Animations ********************************************************************
Idle Property IdleStop Auto
Idle Property pa_HugA Auto
Idle Property SCV_GrabIdle Auto
Idle Property SCV_GrabFailIdle Auto
Idle Property SCV_GrabSuccessIdle Auto

FormList Property SCV_VoreSpellList Auto
Container Property SCV_TransferBase Auto

MiscObject Property SCV_DragonGem Auto
MiscObject Property SCV_SplendidSoulGem Auto
Soulgem Property SoulGemBlack Auto
Soulgem Property SoulGemBlackFilled Auto
Soulgem Property SoulGemGrand Auto
Soulgem Property SoulGemGrandFilled Auto
Soulgem Property SoulGemGreater Auto
Soulgem Property SoulGemGreaterFilled Auto
Soulgem Property SoulGemCommon Auto
Soulgem Property SoulGemCommonFilled Auto
Soulgem Property SoulGemLesser Auto
Soulgem Property SoulGemLesserFilled Auto
Soulgem Property SoulGemPetty Auto
Soulgem Property SoulGemPettyFilled Auto
MiscObject Property SoulGemPiece001 Auto
MiscObject Property SoulGemPiece002 Auto
MiscObject Property SoulGemPiece003 Auto
MiscObject Property SoulGemPiece004 Auto
MiscObject Property SoulGemPiece005 Auto
;Perk Requirement Properties ***************************************************
Spell Property MS04Reward Auto
Spell Property VoiceUnrelentingForce1 Auto
Spell Property VoiceUnrelentingForce2 Auto
Spell Property VoiceUnrelentingForce3 Auto

MagicEffect Property EnchDragonPriestUltraMaskEffect Auto ;Konahrik

Perk Property QuietCasting Auto
Perk Property GoldenTouch Auto
Perk Property SoulSqueezer Auto

Quest Property MG06 Auto
Quest Property DA04 Auto
Quest Property DA11Intro Auto
Quest Property DA05 Auto
Quest Property C03 Auto
Quest Property MQ203 Auto
Quest Property MQ305 Auto
Quest Property FreeformIvarstead01 Auto
Quest Property MG07 Auto
Quest Property MS06 Auto
Quest Property dunAnsilvundQST Auto
Quest Property dunGualdursonQST Auto
Quest Property DA01 Auto
Quest Property DA10 Auto
Quest Property DA07 Auto
Quest Property TG08A Auto
Quest Property DB11 Auto
Quest Property dunTrevasWatchQST Auto
Quest Property dunIronbindQST Auto
Quest Property dunMistwatchQST Auto
Quest Property MS14Quest Auto
Quest Property Favor109 Auto
Quest Property FreeformFalkreathQuest03B Auto
Quest Property MQ204 Auto
Quest Property TG09 Auto
Quest Property FreeformRiften09 Auto
Quest Property FreeformRiften19 Auto
Quest Property MQ202 Auto
Quest Property MG08 Auto
Quest Property MQ301 Auto
Quest Property MS02 Auto
Quest Property MS07 Auto
Quest Property MGRArniel04 Auto
Quest Property MGRitual03 Auto

GlobalVariable Property DragonsAbsorbed Auto

Float _FollowTimer = 0.5
Float Property FollowTimer
  Float Function Get()
    Return _FollowTimer
  EndFunction
  Function Set(Float a_val)
    If a_val > 0
      _FollowTimer = a_val
    EndIf
  EndFunction
EndProperty
