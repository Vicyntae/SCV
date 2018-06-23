ScriptName SCVTakeInSpell Extends ActiveMagicEffect
Int DMID = 9
String Property DebugName
  String Function Get()
    Return "[SCVoreSpell " + VoreType + ":" + PredName + ", " + PreyName + "] "
  EndFunction
EndProperty

String Property VoreType = "Anal" Auto
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Actor property PlayerRef Auto

Faction Property PotentialFollowerFaction Auto
Faction Property CurrentFollowerFaction Auto
Formlist Property SCV_InVoreActionList Auto ; Prevents any vore actions if they are already in one

SCLPerkBase Property SCV_ExpectPushback Auto

SCLPerkBase Property SCLAllowOverflow Auto

SCLPerkBase Property SCV_FriendlyFood Auto

SCLPerkBase Property SCV_StrokeOfLuck Auto
SCLPerkBase Property SCV_IntenseHunger Auto
SCLPerkBase Property SCV_Stalker Auto

SCLPerkBase Property SCV_FollowerofNamira Auto
Keyword Property ActorTypeNPC Auto

SCLPerkBase Property SCV_MetalMuncher Auto
Keyword Property ActorTypeDwarven Auto

SCLPerkBase Property SCV_DragonDevourer Auto
Keyword Property ActorTypeDragon Auto

SCLPerkBase Property SCV_SpiritSwallower Auto
Keyword Property ActorTypeGhost Auto

SCLPerkBase Property SCV_DaedraDieter Auto
Keyword Property ActorTypeDaedra Auto

SCLPerkBase Property SCV_ExpiredEpicurian Auto
Keyword Property ActorTypeUndead Auto

Bool Property Setting_Lethal = False Auto ;Will the prey be digested or stored afterwards (Type 1 or Type 2?)
Bool Property Setting_RunAnim = True Auto

Float ChanceResult = -1.0
Actor _Pred
Actor Property Pred
  Actor Function Get()
    Return _Pred
  EndFunction
  Function Set(Actor a_val)
    _Pred = a_val
    PredName = a_val.GetLeveledActorBase().GetName()
    PredData = SCVLib.getTargetData(a_val)
  EndFunction
EndProperty
String Property PredName Auto
Int Property PredData Auto

Actor _Prey
Actor Property Prey
  Actor Function Get()
    Return _Prey
  EndFunction
  Function Set(Actor a_val)
    _Prey = a_val
    PreyName = a_val.GetLeveledActorBase().GetName()
    PreyData = SCVLib.getTargetData(a_val)
  EndFunction
EndProperty
String Property PreyName Auto
Int Property PreyData Auto

Int AnimRecall = 0

Event OnChanceCall()
  Float Result = calculateChance()
  If Result < 0
    Result = 0
  EndIf
  ChanceResult = Result
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Pred = akCaster
  Prey = akTarget

  RegisterForModEvent("SCV_VoreChance" + PreyData, "OnChanceCall")
  Int Handle = ModEvent.Create("SCV_VoreChance" + PreyData)
  ModEvent.Send(Handle)
  Actor[] Actors = New Actor[2]
  Actors[0] = Pred
  Actors[1] = Prey
  If Setting_RunAnim
    String Situation
    If Pred.IsSneaking() && !Pred.IsDetectedBy(Prey) && SCVLib.getCurrentPerkLevel(Pred, "SCV_Stalker") >= 1
      Situation = "Stealth"
    ElseIf Pred.IsInCombat()
      Situation = "Combat"
    Else
      Situation = "Normal"
    EndIf
    AnimRecall = SCVSet.AnimationThreadHandler.queueAnimEvent(Actors, VoreType, Situation)
  EndIf

  If !checkConditions()
    SCVSet.AnimationThreadHandler.sendCancelEvent(AnimRecall)
    Dispel()
    Return
  EndIf

  If !checkSpecificConditions()
    SCVSet.AnimationThreadHandler.sendCancelEvent(AnimRecall)
    Dispel()
    Return
  EndIf

  runVore()
  Return
EndEvent

Bool Function checkConditions()
  ;/If SCV_InVoreActionList.HasForm(Prey)
    Notice("Failed. Prey is in a vore action already.")
    Return False
  EndIf/;

  If Pred != PlayerRef
    If Pred.GetLeveledActorBase().GetSex() == 0
      If (!SCVSet.EnableMTeamPreds && Pred.IsPlayerTeammate()) || (!SCVSet.EnableMPreds)
        Notice("Failed. Pred gender (M) has been disabled")
        Return False
      EndIf
    Else
      If (!SCVSet.EnableFTeamPreds && Pred.IsPlayerTeammate()) || (!SCVSet.EnableFPreds)
        Notice("Failed. Pred gender (F) has been disabled")
        Return False
      EndIf
    EndIf
  EndIf

  If Prey.IsEssential()
    If Pred == PlayerRef
      If !SCVSet.EnablePlayerEssentialVore
        Notice("Failed. Player has been restricted from eating essential NPCs")
        Return False
      EndIf
    ElseIf !SCVSet.EnableEssentialVore
      Notice("Failed. Actors have been restricted from eating essential NPCs")
      Return False
    EndIf
  EndIf

  ;/If SCVLib.isPreyProtected(Prey, PredData)
    Notice("Failed. Prey is protected.")
    Return False
  EndIf/;

  Return True
EndFunction

Bool Function checkSpecificConditions()
  ;/If !SCVLib.isAVPred(Pred, PredData)
    Notice("Failed. Pred is not an AVPred")
    Return False
  EndIf/;

  ;/If SCVLib.isAVPredBlocked(Pred, PredData)
    Notice("Failed. Pred has been blocked.")
    Return False
  EndIf/;

  If SCVSet.AVDestinationChoice == 1
    Float DigestValue = SCVLib.genDigestValue(Prey, True)
    Float Fullness = JMap.getFlt(PredData, "STFullness")
    Float Max = SCVLib.getMax(Pred, PredData)
    If (Fullness + DigestValue > Max) || \
      (SCLAllowOverflow.getFirstPerkLevel(Pred) >= 1 && Fullness < Max)
      If !SCLSet.GodMode1
        Notice("Failed. Pred cannot fit prey.")
        PlayerThoughtDB(Pred, "SCVPredCantEatFull")
        ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
        ;Pred.PlayIdle(SCVSet.IdleStop)
        Return False
      EndIf
    EndIf
  Else
    Float DigestValue = SCVLib.genDigestValue(Prey, True)
    Float MaxWeight = SCVLib.WF_getSolidMaxInsert(Pred, PredData)
    Int NumItems = SCVLib.countItemTypes(Pred, 4, True) + SCVLib.countItemTypes(Pred, 3, True)
    Int MaxNumItems = SCVLib.WF_getSolidMaxNumItems(Pred, PredData)
    If DigestValue > MaxWeight || NumItems >= MaxNumItems
      Notice("Failed. Pred cannot fit prey.")
      PlayerThoughtDB(Pred, "SCVPredCantEatFull")
      Return False
    EndIf
  EndIf
  Return True
EndFunction

Function runVore()
  Int Type
  ;/If SCVSet.AVDestinationChoice == 1
    If Setting_Lethal
      Type = 1
    Else
      Type = 2
    EndIf
  Else/;
    If Setting_Lethal
      Type = 3
    Else
      Type = 4
    EndIf
  ;EndIf

  If Prey.IsDead() || Prey.IsUnconscious()
    If ChanceResult < 0
      While ChanceResult < 0
        Utility.WaitMenuMode(0.1)
      EndWhile
    EndIf
    If ChanceResult > 0
      Notice("Success. Prey is dead or unconscious")
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      SCVLib.insertPrey(Pred, Prey, Type, False, 0)
      SCVSet.AnimationThreadHandler.sendCancelEvent(AnimRecall)
      ;Play Dead body eat here.
    EndIf
    Dispel()
    Return
  EndIf

  Int FriendlyPerkLevel = SCV_FriendlyFood.getFirstPerkLevel(Pred)
  If FriendlyPerkLevel >= 5
    SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
    SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
    Dispel()
    Return
  ElseIf Prey.IsInFaction(PotentialFollowerFaction) || Prey.IsInFaction(CurrentFollowerFaction)
    If Setting_Lethal && FriendlyPerkLevel >= 3
      SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
      SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
      Dispel()
      Return
    ElseIf FriendlyPerkLevel >= 1
      SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
      SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
      Dispel()
      Return
    ElseIf !Pred.IsSneaking() || Pred.IsDetectedBy(Prey)
      Prey.SendAssaultAlarm()
    EndIf
  ElseIf Prey.GetRelationshipRank(Pred) >= 2
    If Setting_Lethal && FriendlyPerkLevel >= 4
      SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
      SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
      Dispel()
      Return
    ElseIf FriendlyPerkLevel >= 2
      SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
      SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
      Dispel()
      Return
    ElseIf !Pred.IsSneaking() || Pred.IsDetectedBy(Prey)
      Prey.SendAssaultAlarm()
    EndIf
  EndIf

  ;/If Prey.IsDead() || Prey.IsUnconscious()
    Notice("Success. Prey is dead or unconscious")
      SCVLib.insertPrey(Pred, Prey, Type, False, 0)
      SCVSet.AnimationThreadHandler.sendCancelEvent(AnimRecall)
      ;Play Dead body eat here.
      Dispel()
      Return
  ElseIf Pred == PlayerRef
    If SCVLib.allowsFriendlyAV(Prey, PreyData)
      If SCVLib.allowsFriendlyLethalAV(Prey, PreyData) && Setting_Lethal
        Notice("Success. Player is allowed to eat and digest friendly NPC.")
        SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
        SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
        ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
        ;Pred.PlayIdle(SCVSet.IdleStop)
        Dispel()
        Return
      ElseIf !Setting_Lethal
        Notice("Success. Player is allowed to eat friendly NPC.")
        SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
        SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
        ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
        ;Pred.PlayIdle(SCVSet.IdleStop)
        Dispel()
        Return
      EndIf
    Else
      If !Pred.IsSneaking() || Pred.IsDetectedBy(Prey)
        Prey.SendAssaultAlarm()
      EndIf
    EndIf
  ElseIf Prey == PlayerRef
    If SCVLib.isFriendlyAVPred(Pred, PredData)
      Notice("Success. Player has allowed this actor to eat them.")
      SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
      SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      ;Pred.PlayIdle(SCVSet.IdleStop)
      Dispel()
      Return
    EndIf
  Else
    If SCVLib.isFriendlyAVPred(Pred, PreyData) && Prey.GetFactionReaction(Pred) >= 2
      If SCVLib.allowsFriendlyAV(Prey, PreyData)
        If SCVLib.allowsFriendlyLethalAV(Prey, PreyData) && Setting_Lethal
          SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
          SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
          ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
          ;Pred.PlayIdle(SCVSet.IdleStop)
          Dispel()
          Return
        Else
          SCVLib.insertPrey(Pred, Prey, Type, True, AnimRecall)
          ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
          ;Pred.PlayIdle(SCVSet.IdleStop)
          Dispel()
          Return
        EndIf
      EndIf
    EndIf
  EndIf/;

  ;Float Chance = calculateChance()
  If ChanceResult < 0
    While ChanceResult < 0
      Utility.WaitMenuMode(0.1)
    EndWhile
  EndIf

  Float Success = Utility.RandomFloat()
  Notice("Rolling Dice. Chance = " + Success + "/" + ChanceResult)
  If Success < ChanceResult
    ;Hide prey to make it seem that they disappeared immediately
    ;Begin animation here
    ;/SCVSet.SCV_Alpha0Spell01.Cast(Prey)
    Prey.SetPosition(Prey.GetPositionX() + 1000, Prey.GetPositionY() + 1000, Prey.GetPositionZ() - 500)
    Notice("Success. Dice roll passed.")/;
    Float PredStaminaRestore = Pred.GetBaseActorValue("Stamina") / 4
    Float PreyStaminaRestore = PredStaminaRestore
    PredStaminaRestore *= GetMagnitude()
    Pred.RestoreActorValue("Stamina", PredStaminaRestore)
    Prey.RestoreActorValue("Stamina", PreyStaminaRestore)
    SCVSet.AnimationThreadHandler.sendStartEvent(AnimRecall)
    SCVLib.insertPrey(Pred, Prey, Type, False, AnimRecall)
  Else
    Notice("Failed. Dice roll did not pass.")
    SCVSet.AnimationThreadHandler.sendCancelEvent(AnimRecall)
    ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
    ;Pred.PlayIdle(SCVSet.IdleStop)
    JMap.setInt(PreyData, "SCV_StrokeOfLuckAvoidVore", JMap.getInt(PreyData, "SCV_StrokeOfLuckAvoidVore") + 1)
    Int PerkRank = SCV_ExpectPushback.getFirstPerkLevel(Prey)
    Notice("Chance failed, checking perks, PerkRank = " + PerkRank)
    Float Mult = 1
    If PerkRank >= 3
      SCVSet.VoiceUnrelentingForce3.Cast(Prey, Pred)
      Mult = 2
    ElseIf PerkRank == 2
      SCVSet.VoiceUnrelentingForce2.Cast(Prey, Pred)
      Mult = 1.5
    ElseIf PerkRank == 1
      SCVSet.VoiceUnrelentingForce1.Cast(Prey, Pred)
    EndIf
    Int PerkVal = SCVLib.getTotalPerkLevel(Prey, "SCV_ExpectPushback")
    If PerkVal
      Prey.RestoreActorValue("Stamina", 50 * PerkVal * Mult)
      If PerkRank >= 2
        Prey.RestoreActorValue("Magicka", 25 * PerkVal * Mult)
      EndIf
      If PerkRank >= 3
        SCVSet.SCV_ExpectPushbackBuffSpell.Cast(Prey)
      EndIf
    EndIf
  EndIf
  Dispel()
EndFunction

Float Function calculateChance()
  Float Chance

  Int PredSkill = SCVLib.getAVLevelTotal(Pred, PredData)
  Int PreySkill = SCVLib.getResLevel(Prey, PreyData)
  Float PredHealthPercent = Pred.GetActorValuePercentage("Health")
  Float PreyHealthPercent = Prey.GetActorValuePercentage("Health")
  PredHealthPercent *= 1 + (PredSkill / 10)
  PreyHealthPercent *= 1 + (PreySkill / 10)

  ;Chance = SCVLib.clampFlt(PredHealthPercent - PreyHealthPercent, 0, 1)
  Chance = 1
  Chance *= GetMagnitude()
  Notice("Initial Generated chance = " + Chance)

  Int LuckPerk = JMap.getInt(PredData, "SCV_StrokeOfLuck")
  If LuckPerk > 0
    Float LuckChance = Utility.RandomFloat()
    Notice("Luck Perk = " + LuckPerk + ", Chance = " + LuckChance)
    Float LuckSuccess = LuckPerk / 20
    If LuckChance < LuckSuccess
    ;If (LuckPerk == 1 && LuckChance < 10) || (LuckPerk == 2 && LuckChance < 20) || (LuckPerk == 3 && LuckChance < 30)
      Notice("Stroke of Luck success. Returning 0")
      JMap.setInt(PreyData, "SCV_StrokeOfLuckActivate", JMap.getInt(PreyData, "SCV_StrokeOfLuckActivate") + 1)
      ;Play noise here
      PlayerThought(Prey, "A stroke of luck!")
      Return 0
    EndIf
  EndIf

  ;Stalker Perk
  If Pred.IsSneaking() && !Pred.IsDetectedBy(Prey)
    Int StealthPerk = JMap.getInt(PredData, "SCV_Stalker")
    Notice("Stealth perk valid. Perk level = " + StealthPerk)
    If StealthPerk
      Chance *= (1 + (StealthPerk/20))
    EndIf
  EndIf

  If Prey.IsBleedingOut()
    Notice("Prey is bleeding out. Chance set to 1")
    Chance = 1
  EndIf

  ;HungerPerks
  Int Hunger = JMap.getInt(PredData, "SCV_IntenseHunger")
  If Hunger
    Notice("Hunger perk valid. Perk level = " + Hunger)
    Chance *= (1 + (Hunger / 20))
  EndIf

  Race PreyRace = Prey.GetRace()
  If PreyRace.HasKeyword(ActorTypeNPC)
    Int TruePerkRank = SCV_FollowerofNamira.getFirstPerkLevel(Pred)
    Int PerkRank = JMap.getInt(PredData, "SCV_FollowerofNamira")
    If TruePerkRank < 1
      Notice("Actor Type NPC. Perk not taken. Returning 0")
      PlayerThought(Pred, "They're human! I can't eat them!", "They're human! You can't eat them!", "They're human! " + PredName + " can't eat them!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + (PerkRank * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDragon)
    Int TruePerkRank = SCV_DragonDevourer.getFirstPerkLevel(Pred)
    Int PerkRank = JMap.getInt(PredData, "SCV_DragonDevourer")
    If TruePerkRank < 1
      Notice("Actor Type Dragon. Perk not taken. Returning 0")
      Notice(PreyName + " is a Dragon! " + PredName + " does not have perk! Returning 0")
      PlayerThought(Pred, "That's a bloody dragon! I can't even imagine eating that!", "That's a dragon! How could you even think about eating that!?", "That's a dragon! " + PredName + " can't eat that!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDwarven)
    Int TruePerkRank = SCV_MetalMuncher.getFirstPerkLevel(Pred)
    Int PerkRank = JMap.getInt(PredData, "SCV_MetalMuncher")
    If TruePerkRank < 1
      Notice("Actor Type Dwarven. Perk not taken. Returning 0")
      Notice(PreyName + " is automaton! " + PredName + " does not have perk! Returning 0")
      PlayerThought(Pred, "It's made of metal! I can't eat that!", "It's made of metal! You can't eat that!", "It's made of metal! " + PredName +" can't eat that!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeGhost)
    Int TruePerkRank = SCV_SpiritSwallower.getFirstPerkLevel(Pred)
    Int PerkRank = JMap.getInt(PredData, "SCV_SpiritSwallower")
    If TruePerkRank < 1
      Notice("Actor Type Ghost. Perk not taken. Returning 0")
      Notice(PreyName + " is a Ghost! " + PredName + " does not have perk! Returning 0")
      PlayerThought(Pred, "By the gods, I can't eat a ghost! What was I thinking!?", "You fail to grab hold of the ghost, because there's nothing there.", PredName + " can't hold the ghost!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeUndead)
    Int TruePerkRank = SCV_ExpiredEpicurian.getFirstPerkLevel(Pred)
    Int PerkRank = JMap.getInt(PredData, "SCV_ExpiredEpicurian")
    If TruePerkRank < 1
      Notice("Actor Type Undead. Perk not taken. Returning 0")
      Notice(PreyName + " is Undead! " + PredName + " does not have perk! Returning 0")
      PlayerThought(Pred, "It's bones and dust! I don't want to eat that!", "You most certainly don't want to eat that.", PredName + "recoils at the thought of eating dusty bones.")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDaedra)
    Int TruePerkRank = SCV_DaedraDieter.getFirstPerkLevel(Pred)
    Int PerkRank = JMap.getInt(PredData, "SCV_DaedraDieter")
    If TruePerkRank < 1
      Notice("Actor Type Daedra. Perk not taken. Returning 0")
      Notice(PreyName + " is Daedra! " + PredName + " does not have perk! Returning 0")
      PlayerThought(Pred, "It's a daedra! I can't eat that!", "You don't have the nerve to try and eat the daedra", PredName + " couldn't overpower the daedra")
      Return  0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  Return Chance
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
