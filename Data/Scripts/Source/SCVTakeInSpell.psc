ScriptName SCVTakeInSpell Extends ActiveMagicEffect
Int DMID = 9
String Property DebugName
  String Function Get()
    Return "[SCVTakeIn " + PredName + ", " + PreyName + "] "
  EndFunction
EndProperty

SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Actor property PlayerRef Auto
Formlist Property SCV_InVoreActionList Auto ; Prevents any vore actions if they are already in one

Keyword Property ActorTypeDwarven Auto
Keyword Property ActorTypeDragon Auto
Keyword Property ActorTypeGhost Auto
Keyword Property ActorTypeDaedra Auto
Keyword Property ActorTypeUndead Auto
Keyword Property ActorTypeNPC Auto

Bool Property Setting_Lethal = False Auto ;Will the prey be digested or stored afterwards (Type 4 or Type 6?)

Actor Pred
String PredName
Int PredData

Actor Prey
String PreyName
Int PreyData

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Pred = akCaster
  PredName = SCVLib.nameGet(Pred)
  PredData = SCVLib.getTargetData(Pred, True)

  Prey = akTarget
  PreyName = SCVLib.nameGet(Prey)
  PreyData = SCVLib.getTargetData(Prey, True)
  Notice("Take in spell cast! Pred=" + PredName + ", Prey=" + PreyName)

  If SCV_InVoreActionList.HasForm(Prey)
    Notice("Failed. Prey is in a vore action already.")
    Dispel()
    Return
  EndIf

  If !SCVLib.isAVPred(Pred, PredData)
    Notice("Failed. Pred is not an AVPred")
    Dispel()
    Return
  EndIf

  If Pred != PlayerRef
    If Pred.GetLeveledActorBase().GetSex() == 0
      If (!SCVSet.EnableMTeamPreds && Pred.IsPlayerTeammate()) || (!SCVSet.EnableMPreds)
        Notice("Failed. Pred gender (M) has been disabled")
        Dispel()
        Return
      EndIf
    Else
      If (!SCVSet.EnableFTeamPreds && Pred.IsPlayerTeammate()) || (!SCVSet.EnableFPreds)
        Notice("Failed. Pred gender (F) has been disabled")
        Dispel()
        Return
      EndIf
    EndIf
  EndIf

  If SCVLib.isAVPredBlocked(Pred, PredData)
    Notice("Failed. Pred has been blocked.")
    Dispel()
    Return
  EndIf

  If Prey.IsEssential()
    If Pred == PlayerRef
      If !SCVSet.EnablePlayerEssentialVore
        Notice("Failed. Player has been restricted from eating essential NPCs")
        Dispel()
        Return
      EndIf
    ElseIf !SCVSet.EnableEssentialVore
      Notice("Failed. Actors have been restricted from eating essential NPCs")
      Dispel()
      Return
    EndIf
  EndIf

  If SCVLib.isPreyProtected(Prey, PredData)
    Notice("Failed. Prey is protected.")
    Dispel()
    Return
  EndIf

  ;;Pred.PlayIdle(SCVSet.SCV_GrabIdle)

  Notice("Actor checks succeeded.")
  If !SCVSet.SCA_Initialized || SCVSet.AVDestinationChoice == 1
    Float DigestValue = SCVLib.genDigestValue(Prey, True)
    Float Fullness = JMap.getFlt(PredData, "STFullness")
    Float Max = SCVLib.getMax(Pred, PredData)
    If (Fullness + (DigestValue * (1 + (SCVLib.getCurrentPerkLevel(Pred, "SCV_FillingMeal") / 10))) > Max) || \
      (SCVLib.getCurrentPerkLevel(Pred, "SCV_RemoveLimits") >= 1 && SCVLib.getCurrentPerkLevel(Pred, "SCLAllowOverflow") >= 1 && Fullness > Max)
      If !SCLSet.GodMode1
        Notice("Failed. Pred cannot fit prey.")
        PlayerThoughtDB(Pred, "SCVPredCantEatFull")
        ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
        ;Pred.PlayIdle(SCVSet.IdleStop)
        Dispel()
        Return
      EndIf
    EndIf
  ;Else
  EndIf

  Int Type
  If Setting_Lethal
    Type = 4
  Else
    Type = 6
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
  Float Chance = calculateChance(Pred, Prey)
  Float Success = Utility.RandomFloat()
  Notice("Rolling Dice. Chance = " + Success + "/" + Chance)
  If Success < Chance
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
    If PerkRank == 1 || PerkRank == 2
      Bool KnockBackChance = Utility.RandomInt(0, 1) as Bool
      If KnockBackChance
        If PerkRank == 1
          Notice("Knockback lv 1")
          akTarget.KnockAreaEffect(1, 180)
        Else
          Notice("Knockback lv 2")
          akTarget.KnockAreaEffect(1, 240)
        EndIf
      EndIf
    ElseIf PerkRank == 3
      Notice("Knockback lv 3")
      akTarget.KnockAreaEffect(1, 240)
    EndIf
  EndIf
  Dispel()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  ;Pred.PlayIdle(SCVSet.SCV_GrabFailIdle)
  Notice("Swallow effect removed!")
EndEvent

Float Function calculateChance(Actor akPred, Actor akPrey)
  Float Chance

  Int PredSkill = SCVLib.getAVLevelTotal(akPred, PredData)
  Int PreySkill = SCVLib.getResLevel(akPrey, PreyData)

  ;Chance = SCVLib.ClampFloat(PredSkill - PreySkill, 0, 100)
  Chance = 1
  Chance *= GetMagnitude()
  Notice("Initial Generated chance = " + Chance)

  Int LuckPerk = SCVLib.getTotalPerkLevel(akPrey, "SCV_StrokeOfLuck")
  If LuckPerk > 0
    Int LuckChance = Utility.RandomInt()
    Notice("Luck Perk = " + LuckPerk + ", Chance = " + LuckChance)
    If LuckChance < (LuckPerk * 10)
    ;If (LuckPerk == 1 && LuckChance < 10) || (LuckPerk == 2 && LuckChance < 20) || (LuckPerk == 3 && LuckChance < 30)
      Notice("Stroke of Luck success. Returning 0")
      JMap.setInt(PreyData, "SCV_StrokeOfLuckActivate", JMap.getInt(PreyData, "SCV_StrokeOfLuckActivate") + 1)
      ;Play noise here
      PlayerThought(akPrey, "A stroke of luck!")
      Return 0
    EndIf
  EndIf

  ;Stalker Perk
  If akPred.IsSneaking() && !akPred.IsDetectedBy(akPrey)
    Int StealthPerk = SCVLib.getTotalPerkLevel(akPred, "SCV_Stalker")
    Notice("Stealth perk valid. Perk level = " + StealthPerk)
    If StealthPerk
      Chance *= (1 + (StealthPerk/5))
    EndIf
  EndIf

  If akPrey.IsBleedingOut()
    Notice("Prey is bleeding out. Chance set to 1")
    Chance = 1
  EndIf

  ;HungerPerks
  Int Hunger = SCVLib.getTotalPerkLevel(akPred, "SCV_IntenseHunger")
  If Hunger
    Notice("Hunger perk valid. Perk level = " + Hunger)
    Chance *= (1 + (Hunger / 20))
  EndIf

  Race PreyRace = akPrey.GetRace()
  If PreyRace.HasKeyword(ActorTypeNPC)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(akPred, "SCV_FollowerofNamira")
    Int PerkRank = SCVLib.getTotalPerkLevel(akPred, "SCV_FollowerofNamira")
    If TruePerkRank < 1
      Notice("Actor Type NPC. Perk not taken. Returning 0")
      PlayerThought(akPred, "They're human! I can't eat them!", "They're human! You can't eat them!", "They're human! " + PredName + " can't eat them!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + (PerkRank * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDragon)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(akPred, "SCV_DragonDevourer")
    Int PerkRank = SCVLib.getTotalPerkLevel(akPred, "SCV_DragonDevourer")
    If TruePerkRank < 1
      Notice("Actor Type Dragon. Perk not taken. Returning 0")
      Notice(PreyName + " is a Dragon! " + PredName + " does not have perk! Returning 0")
      PlayerThought(akPred, "That's a bloody dragon! I can't even imagine eating that!", "That's a dragon! How could you even think about eating that!?", "That's a dragon! " + PredName + " can't eat that!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDwarven)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(akPred, "SCV_MetalMuncher")
    Int PerkRank = SCVLib.getTotalPerkLevel(akPred, "SCV_MetalMuncher")
    If TruePerkRank < 1
      Notice("Actor Type Dwarven. Perk not taken. Returning 0")
      Notice(PreyName + " is automaton! " + PredName + " does not have perk! Returning 0")
      PlayerThought(akPred, "It's made of metal! I can't eat that!", "It's made of metal! You can't eat that!", "It's made of metal! " + PredName +" can't eat that!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeGhost)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(akPred, "SCV_SpiritSwallower")
    Int PerkRank = SCVLib.getTotalPerkLevel(akPred, "SCV_SpiritSwallower")
    If TruePerkRank < 1
      Notice("Actor Type Ghost. Perk not taken. Returning 0")
      Notice(PreyName + " is a Ghost! " + PredName + " does not have perk! Returning 0")
      PlayerThought(akPred, "By the gods, I can't eat a ghost! What was I thinking!?", "You fail to grab hold of the ghost, because there's nothing there.", PredName + " can't hold the ghost!")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeUndead)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(akPred, "SCV_ExpiredEpicurian")
    Int PerkRank = SCVLib.getTotalPerkLevel(akPred, "SCV_ExpiredEpicurian")
    If TruePerkRank < 1
      Notice("Actor Type Undead. Perk not taken. Returning 0")
      Notice(PreyName + " is Undead! " + PredName + " does not have perk! Returning 0")
      PlayerThought(akPred, "It's bones and dust! I don't want to eat that!", "You most certainly don't want to eat that.", PredName + "recoils at the thought of eating dusty bones.")
      Return 0
    ElseIf PerkRank > 1
      Chance *= 1 + ((PerkRank - 1) * 0.5)
    EndIf
  EndIf

  If PreyRace.HasKeyword(ActorTypeDaedra)
    Int TruePerkRank = SCVLib.getCurrentPerkLevel(akPred, "SCV_DaedraDieter")
    Int PerkRank = SCVLib.getTotalPerkLevel(akPred, "SCV_DaedraDieter")
    If TruePerkRank < 1
      Notice("Actor Type Daedra. Perk not taken. Returning 0")
      Notice(PreyName + " is Daedra! " + PredName + " does not have perk! Returning 0")
      PlayerThought(akPred, "It's a daedra! I can't eat that!", "You don't have the nerve to try and eat the daedra", PredName + " couldn't overpower the daedra")
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
