ScriptName SCVTakeInSpell Extends SCVoreSpell
Int DMID = 9
String VoreType = "TakeIn"

Bool Function checkSpecificConditions()
  If !SCVLib.isAVPred(Pred, PredData)
    Notice("Failed. Pred is not an AVPred")
    Return False
  EndIf

  If SCVLib.isAVPredBlocked(Pred, PredData)
    Notice("Failed. Pred has been blocked.")
    Return False
  EndIf

  If !SCLSet.WF_Active || SCVSet.AVDestinationChoice == 1
    Float DigestValue = SCVLib.genDigestValue(Prey, True)
    Float Fullness = JMap.getFlt(PredData, "STFullness")
    Float Max = SCVLib.getMax(Pred, PredData)
    If (Fullness + DigestValue > Max) || \
      (SCVLib.getCurrentPerkLevel(Pred, "SCV_RemoveLimits") >= 1 && SCVLib.getCurrentPerkLevel(Pred, "SCLAllowOverflow") >= 1 && Fullness > Max)
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
    Int NumItems = SCVLib.countItemTypes(Pred, 4, True)
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
  If !SCLSet.WF_Active || SCVSet.AVDestinationChoice == 1
    If Setting_Lethal
      Type = 1
    Else
      Type = 2
    EndIf
  Else
    If Setting_Lethal
      Type = 3
    Else
      Type = 4
    EndIf
  EndIf

  If Prey.IsDead() || Prey.IsUnconscious()
    Notice("Success. Prey is dead or unconscious")
      SCVLib.insertPrey(Pred, Prey, Type, False, False)
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      ;Pred.PlayIdle(SCVSet.IdleStop)
      Dispel()
      Return
  ElseIf Pred == PlayerRef
    If SCVLib.allowsFriendlyAV(Prey, PreyData)
      If SCVLib.allowsFriendlyLethalAV(Prey, PreyData) && Setting_Lethal
        Notice("Success. Player is allowed to eat and digest friendly NPC.")
        SCVLib.insertPrey(Pred, Prey, Type, True, True)
        ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
        ;Pred.PlayIdle(SCVSet.IdleStop)
        Dispel()
        Return
      ElseIf !Setting_Lethal
        Notice("Success. Player is allowed to eat friendly NPC.")
        SCVLib.insertPrey(Pred, Prey, Type, True, True)
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
      SCVLib.insertPrey(Pred, Prey, Type, True, True)
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      ;Pred.PlayIdle(SCVSet.IdleStop)
      Dispel()
      Return
    EndIf
  Else
    If SCVLib.isFriendlyAVPred(Pred, PreyData) && Prey.GetFactionReaction(Pred) >= 2
      If SCVLib.allowsFriendlyAV(Prey, PreyData)
        If SCVLib.allowsFriendlyLethalAV(Prey, PreyData) && Setting_Lethal
          SCVLib.insertPrey(Pred, Prey, Type, True, True)
          ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
          ;Pred.PlayIdle(SCVSet.IdleStop)
          Dispel()
          Return
        Else
          SCVLib.insertPrey(Pred, Prey, Type, True, True)
          ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
          ;Pred.PlayIdle(SCVSet.IdleStop)
          Dispel()
          Return
        EndIf
      EndIf
    EndIf
  EndIf
  Float Chance = calculateChance()
  Float Success = Utility.RandomFloat()
  Notice("Rolling Dice. Chance = " + Success + "/" + Chance)
  If Success < Chance
    ;Hide prey to make it seem that they disappeared immediately
    ;Begin animation here
    SCVSet.SCV_Alpha0Spell01.Cast(Prey)
    Prey.SetPosition(Prey.GetPositionX() + 1000, Prey.GetPositionY() + 1000, Prey.GetPositionZ() - 500)
    Notice("Success. Dice roll passed.")
    Float PredStaminaRestore = Pred.GetBaseActorValue("Stamina") / 4
    Float PreyStaminaRestore = PredStaminaRestore
    PredStaminaRestore *= GetMagnitude()
    Pred.RestoreActorValue("Stamina", PredStaminaRestore)
    Prey.RestoreActorValue("Stamina", PreyStaminaRestore)
    SCVLib.insertPrey(Pred, Prey, Type, False)
  Else
    Notice("Failed. Dice roll did not pass.")
    ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
    ;Pred.PlayIdle(SCVSet.IdleStop)
    JMap.setInt(PreyData, "SCV_StrokeOfLuckAvoidVore", JMap.getInt(PreyData, "SCV_StrokeOfLuckAvoidVore") + 1)
    Int PerkRank = SCVLib.getCurrentPerkLevel(Prey, "SCV_ExpectPushback")
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

  Int LuckPerk = SCVLib.getTotalPerkLevel(Prey, "SCV_StrokeOfLuck")
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
    Int StealthPerk = SCVLib.getTotalPerkLevel(Pred, "SCV_Stalker")
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
  Int Hunger = SCVLib.getTotalPerkLevel(Pred, "SCV_IntenseHunger")
  If Hunger
    Notice("Hunger perk valid. Perk level = " + Hunger)
    Chance *= (1 + (Hunger / 20))
  EndIf

  Race PreyRace = Prey.GetRace()
  If PreyRace.HasKeyword(ActorTypeNPC)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(Pred, "SCV_FollowerofNamira")
    Int PerkRank = SCVLib.getTotalPerkLevel(Pred, "SCV_FollowerofNamira")
    If TruePerkRank < 1
      Notice("Actor Type NPC. Perk not taken. Returning 0")
      PlayerThought(Pred, "They're human! I can't eat them!", "They're human! You can't eat them!", "They're human! " + PredName + " can't eat them!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + (PerkRank * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDragon)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(Pred, "SCV_DragonDevourer")
    Int PerkRank = SCVLib.getTotalPerkLevel(Pred, "SCV_DragonDevourer")
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
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(Pred, "SCV_MetalMuncher")
    Int PerkRank = SCVLib.getTotalPerkLevel(Pred, "SCV_MetalMuncher")
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
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(Pred, "SCV_SpiritSwallower")
    Int PerkRank = SCVLib.getTotalPerkLevel(Pred, "SCV_SpiritSwallower")
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
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(Pred, "SCV_ExpiredEpicurian")
    Int PerkRank = SCVLib.getTotalPerkLevel(Pred, "SCV_ExpiredEpicurian")
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
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(Pred, "SCV_DaedraDieter")
    Int PerkRank = SCVLib.getTotalPerkLevel(Pred, "SCV_DaedraDieter")
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
