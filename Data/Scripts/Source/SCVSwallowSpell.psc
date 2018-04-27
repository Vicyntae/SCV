ScriptName SCVSwallowSpell Extends SCVoreSpell
Int DMID = 9
String VoreType = "Swallow"

Bool Function checkSpecificConditions()
  If !SCVLib.isOVPred(Pred, PredData)
    Notice("Failed. Pred is not an OVPred")
    Return False
  EndIf

  If SCVLib.isOVPredBlocked(Pred, PredData)
    Notice("Failed. Pred has been blocked.")
    Return False
  EndIf

  Float DigestValue = SCVLib.genDigestValue(Prey, True)
  Float Fullness = JMap.getFlt(PredData, "STFullness")
  Float Max = SCVLib.getMax(Pred, PredData)
  If (Fullness + (DigestValue * (1 + (SCVLib.getCurrentPerkLevel(Pred, "SCV_FillingMeal") / 10))) > Max) || \
    (SCVLib.getCurrentPerkLevel(Pred, "SCV_RemoveLimits") >= 1 && SCVLib.getCurrentPerkLevel(Pred, "SCLAllowOverflow") >= 1 && Fullness > Max)
    If !SCLSet.GodMode1
      Notice("Failed. Pred cannot fit prey.")
      PlayerThoughtDB(Pred, "SCVPredCantEatFull")
      ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
      Return False
    EndIf
  EndIf

  Return True
EndFunction

Function runVore()
  If Prey.IsDead() || Prey.IsUnconscious()
    Notice("Success. Prey is dead or unconscious")
    If Setting_Lethal
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      SCVLib.insertPrey(Pred, Prey, 1, False, False)
      Dispel()
      Return
    Else
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      SCVLib.insertPrey(Pred, Prey, 2, False, False)
      Dispel()
      Return
    EndIf
  ElseIf Pred == PlayerRef
    If SCVLib.allowsFriendlyOV(Prey, PreyData)
      If SCVLib.allowsFriendlyLethalOV(Prey, PreyData) && Setting_Lethal
        Notice("Success. Player is allowed to eat and digest friendly NPC.")
        ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
        SCVLib.insertPrey(Pred, Prey, 1, True, True)
        Dispel()
        Return
      Else
        Notice("Success. Player is allowed to eat friendly NPC.")
        ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
        SCVLib.insertPrey(Pred, Prey, 2, True, True)
        Dispel()
        Return
      EndIf
      Return
    Else
      If !Pred.IsSneaking() || Pred.IsDetectedBy(Prey)
        Prey.SendAssaultAlarm()
      EndIf
    EndIf
  ElseIf Prey == PlayerRef
    If SCVLib.isFriendlyOVPred(Pred, PredData)
      Notice("Success. Player has allowed this actor to eat them.")
      ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
      SCVLib.insertPrey(Pred, Prey, 2, True, True)
      Dispel()
      Return
    EndIf
  Else
    If SCVLib.isFriendlyOVPred(Pred, PreyData) && Prey.GetFactionReaction(Pred) >= 2
      If SCVLib.allowsFriendlyOV(Prey, PreyData)
        If SCVLib.allowsFriendlyLethalOV(Prey, PreyData) && Setting_Lethal
          ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
          SCVLib.insertPrey(Pred, Prey, 1, True, True)
          Dispel()
          Return
        Else
          ;Pred.PlayIdle(SCVSet.SCV_GrabSuccessIdle)
          SCVLib.insertPrey(Pred, Prey, 2, True, True)
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
    PredStaminaRestore *= self.GetMagnitude()
    Pred.RestoreActorValue("Stamina", PredStaminaRestore)
    Prey.RestoreActorValue("Stamina", PreyStaminaRestore)
    If Setting_Lethal
      SCVLib.insertPrey(Pred, Prey, 1, False)
    Else
      SCVLib.insertPrey(Pred, Prey, 2, False)
    EndIf
  Else
    Notice("Failed. Dice roll did not pass.")
    ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
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
EndFunction
