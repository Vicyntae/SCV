ScriptName SCVMonitor Extends SCLMonitor

SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto
String ScriptID = "SCVMonitor"
Function Setup()
  Parent.Setup()
  If MyActor
    SCVLib.checkSCVData(MyActor, ActorData)
  EndIf
EndFunction

Event OnQuickUpdate()
  ;Note("quickUpdate received")
  Bool Sent
  If !Sent && SCVLib.isInPred(MyActor)
    Float ReactChance = Utility.RandomFloat()
    If ReactChance <= 0.01
      Sent = True
      If MyActor.GetActorValuePercentage("Stamina") < 0.3
        PlayerThoughtDB(MyActor, "SCVPreyStruggleTired")
      ElseIf SCVLib.isBeingHurt(MyActor)
        PlayerThoughtDB(MyActor, "SCVPreyStruggleDamage")
      Else
        PlayerThoughtDB(MyActor, "SCVPreyStruggle")
      EndIf
    EndIf
  EndIf

  If !Sent && SCVLib.getFrenzyLevel(MyActor)
    Float ReactChance = Utility.RandomFloat()
    If ReactChance <= 0.01
      Sent = True
      If SCVLib.getFrenzyLevel(MyActor) >= 2
        PlayerThoughtDB(MyActor, "SCVPredFrenzyHigh")
      Else
        PlayerThoughtDB(MyActor, "SCVPredFrenzyLow")
      EndIf
    EndIf
  EndIf

  If !Sent && !SCVLib.isOVPred(MyActor, ActorData) && SCVLib.getFrenzyLevel(MyActor) == 0 && (SCVLib.hasStrugglePrey(MyActor, ActorData) || SCVLib.hasPreyType(MyActor, 1, ActorData) || SCVLib.hasPreyType(MyActor, 3, ActorData))
    Float ReactChance = Utility.RandomFloat()
    If ReactChance <= 0.01
      Sent = True
      ;Play topic here
      PlayerThoughtDB(MyActor, "SCVPredShocked")
    EndIf
  EndIf

  If SCVLib.hasPreyType(MyActor, 1, ActorData) && !MyActor.HasSpell(SCVSet.SCV_HasDigestingPrey)
    MyActor.AddSpell(SCVSet.SCV_HasDigestingPrey, False)
  ElseIf MyActor.HasSpell(SCVSet.SCV_HasDigestingPrey)
    MyActor.RemoveSpell(SCVSet.SCV_HasDigestingPrey)
  EndIf

  Bool HasStruggle

  If SCVLib.hasOVStrugglePrey(MyActor, ActorData)
    Float StaminaPercent = MyActor.GetActorValuePercentage("Stamina")
    If !Sent
      Float ReactChance = Utility.RandomFloat()
      If ReactChance <= 0.01
        Sent = True
        If StaminaPercent < 0.3
          PlayerThoughtDB(MyActor, "SCVOVPredStruggleTired")
        ElseIf SCVLib.getDamageTier(MyActor)
          PlayerThoughtDB(MyActor, "SCVOVPredStruggleDamage")
        Else
          PlayerThoughtDB(MyActor, "SCVOVPredStruggle")
        EndIf
      EndIf
    EndIf
    If !MyActor.HasSpell(SCVSet.SCV_HasOVStrugglePrey)
      MyActor.AddSpell(SCVSet.SCV_HasOVStrugglePrey, False)
    EndIf
    HasStruggle = True
  ElseIf MyActor.HasSpell(SCVSet.SCV_HasOVStrugglePrey)
    MyActor.RemoveSpell(SCVSet.SCV_HasOVStrugglePrey)
  EndIf

  If SCVLib.hasAVStrugglePrey(MyActor, ActorData)
    If !Sent
      Float ReactChance = Utility.RandomFloat()
      If ReactChance <= 0.01
        Sent = True
        If MyActor.GetActorValuePercentage("Stamina") < 0.3
          PlayerThoughtDB(MyActor, "SCVAVPredStruggleTired")
        ElseIf SCVLib.getDamageTier(MyActor)
          PlayerThoughtDB(MyActor, "SCVAVPredStruggleDamage")
        Else
          PlayerThoughtDB(MyActor, "SCVAVPredStruggle")
        EndIf
      EndIf
    EndIf
    If !MyActor.HasSpell(SCVSet.SCV_HasAVStrugglePrey)
      MyActor.AddSpell(SCVSet.SCV_HasAVStrugglePrey, False)
    EndIf
    HasStruggle = True
  ElseIf MyActor.HasSpell(SCVSet.SCV_HasAVStrugglePrey)
    MyActor.RemoveSpell(SCVSet.SCV_HasAVStrugglePrey)
  EndIf

  If HasStruggle
    ;Note("Has Struggling Prey! Registering for updates.")
    RegisterForSingleUpdate(1)
  Else
    ;/If !SCVLib.isInPred(MyActor) && MyActor.Is3DLoaded()  ;Making sure that these are kept consistent.
      SCVLib.setProxy(MyActor, "Health", MyActor.GetActorValue("Health"))
      SCVLib.setProxy(MyActor, "Stamina", MyActor.GetActorValue("Stamina"))
      SCVLib.setProxy(MyActor, "Magicka", MyActor.GetActorValue("Magicka"))
    EndIf/;
  EndIf
  Parent.OnQuickUpdate()
EndEvent

Function checkAutoEat(Float afFullness, Float afCurrentUpdateTime)
  Parent.checkAutoEat(afFullness, afCurrentUpdateTime)
  If SCLSet.AutoEatActive
    If MyActor != PlayerRef
      Float EatTimePassed = ((afCurrentUpdateTime - (JMap.getFlt(ActorData, "LastEatTime")))*24) ;In hours
      If EatTimePassed >= 36
        PlayerThoughtDB(MyActor, "SCVStarvingFrenzy")
        SCVSet.SCV_OVFrenzySelfSpell01.Cast(MyActor)
      EndIf
    EndIf
  EndIf
EndFunction

Bool isAnimated = False
Event OnSpellCast(Form akSpell)
  ;Note("Spell cast!")
  If !isAnimated
    If SCVSet.SCV_VoreSpellList.HasForm(akSpell)
      ;Note("Valid spell cast!")
      isAnimated = True
      Bool Drawn = MyActor.IsWeaponDrawn()
      If Drawn
        MyActor.SheatheWeapon()
      EndIf
      ;/Form RWeapon = MyActor.GetEquippedObject(1)
      Form LWeapon = MyActor.GetEquippedObject(0)
      If RWeapon
        If RWeapon as Weapon || (RWeapon as Armor).IsShield()
          MyActor.UnequipItemEx(RWeapon, 1, False)
        ElseIf RWeapon as Spell
          MyActor.UnequipSpell(RWeapon as Spell, 1)
        EndIf
      EndIf

      If LWeapon
        If LWeapon as Weapon || (LWeapon as Armor).IsShield()
          MyActor.UnequipItemEx(LWeapon, 2, False)
        ElseIf LWeapon as Spell
          MyActor.UnequipSpell(LWeapon as Spell, 0)
        EndIf
      EndIf
      Utility.Wait(0.5)/;
      Debug.SendAnimationEvent(MyActor, "SCV_GrabEvent01")
      ;MyActor.PlayIdle(SCVSet.SCV_GrabIdle)
      Utility.Wait(0.5)
      Debug.SendAnimationEvent(MyActor, "IdleForceDefaultState")
      ;MyActor.PlayIdle(SCVSet.IdleStop)
      ;/If RWeapon
        If RWeapon as Weapon || (RWeapon as Armor && (RWeapon as Armor).IsShield())
          MyActor.EquipItemEx(RWeapon, 1, False, True)
        ElseIf RWeapon as Spell
          MyActor.EquipSpell(RWeapon as Spell, 1)
        EndIf
      EndIf

      If LWeapon
        If LWeapon as Weapon || (LWeapon as Armor && (LWeapon as Armor).IsShield())
          MyActor.EquipItemEx(LWeapon, 2, False, True)
        ElseIf LWeapon as Spell
          MyActor.EquipSpell(LWeapon as Spell, 0)
        EndIf
      EndIf/;
      If Drawn
        MyActor.DrawWeapon()
      EndIf
      isAnimated = False
    EndIf
  EndIf
EndEvent

Function ForceRefTo(ObjectReference akNewRef)
  If MyActor
    MyActor.RemoveSpell(SCVSet.SCV_HasOVStrugglePrey)
    MyActor.RemoveSpell(SCVSet.SCV_HasAVStrugglePrey)
  EndIf
  Parent.ForceRefTo(akNewRef)
EndFunction

Function Clear()
  If MyActor
    MyActor.RemoveSpell(SCVSet.SCV_HasOVStrugglePrey)
    MyActor.RemoveSpell(SCVSet.SCV_HasAVStrugglePrey)
  EndIf
  Parent.Clear()
EndFunction

Function updateFullness()
  Int JF_Contents = SCVLib.getContents(MyActor, 8, ActorData)
  Form ItemKey = JFormMap.nextKey(JF_Contents) as Form
  Int JI_StruggleValues = JIntMap.object()
  Int JA_Remove
  If ItemKey
    While ItemKey
      If ItemKey as Actor
        Int JM_Item = JFormMap.getObj(JF_Contents, ItemKey)
        Int StoredType = JMap.getInt(JM_Item, "StoredItemType")
        JIntMap.setFlt(JI_StruggleValues, StoredType, JIntMap.getFlt(JI_StruggleValues, StoredType) + JMap.getFlt(JM_Item, "DigestValue"))
      Else
        If !JA_Remove
          JA_Remove = JArray.object()
        EndIf
        JArray.addForm(JA_Remove, ItemKey)
      EndIf
      ItemKey = JFormMap.nextKey(JF_Contents, ItemKey) as Form
    EndWhile
  Else
    Int f = JIntMap.nextKey(SCLSet.JI_ItemTypes)
    While f
      If JMap.hasKey(ActorData, "StruggleFullness" + f)
        JMap.setFlt(ActorData, "StruggleFullness" + f, 0)
      EndIf
      f = JIntMap.nextKey(SCLSet.JI_ItemTypes, f)
    EndWhile
  EndIf
  Int i = JIntMap.nextKey(JI_StruggleValues)
  While i
    JMap.setFlt(ActorData, "StruggleFullness" + i, JIntMap.getFlt(JI_StruggleValues, i))
    i = JIntMap.nextKey(JI_StruggleValues, i)
  EndWhile
  If JA_Remove
    Int k = JArray.count(JA_Remove)
    While k
      k -= 1
      JFormMap.removeKey(JF_Contents, JArray.getForm(JA_Remove, k))
    EndWhile
    JValue.zeroLifetime(JA_Remove)
  EndIf
  JValue.zeroLifetime(JI_StruggleValues)
  Parent.updateFullness()
EndFunction

Function performStruggle(Actor akTarget, Int aiTargetData = 0)
  {Recursive function, deals struggle damage to predator and all prey within them}
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  Int Struggle = JMap.getInt(TargetData, "SCV_StruggleRank")
  Int Damage = JMap.getInt(TargetData, "SCV_DamageRank")
  Bool MagicPerk = akTarget.hasSpell(SCVSet.StruggleSorceryPerk)
  If Struggle
    If MagicPerk
      akTarget.DamageActorValue("Stamina", Struggle*5)
      akTarget.DamageActorValue("Magicka", Struggle*5)
      SCVLib.modProxy(akTarget, "Stamina", -(Struggle * 5))
      SCVLib.modProxy(akTarget, "Magicka", -(Struggle * 5))
    Else
      akTarget.DamageActorValue("Stamina", Struggle * 10)
      SCVLib.modProxy(akTarget, "Stamina", -(Struggle * 10))
    EndIf
  EndIf
  If Damage
    akTarget.DamageActorValue("Health", Damage * 5)
    SCVLib.modProxy(akTarget, "Health", -(Damage * 5))
  EndIf
  Float Stamina = akTarget.GetActorValuePercentage("Stamina")
  Float StaminaProxy = SCVLib.getProxyPercent(akTarget, "Stamina")
  ;Note(SCVLib.nameGet(akTarget) + " Stamina Percent = " + Stamina)
  If SCVLib.isInPred(akTarget, TargetData)
    SCVLib.giveResExp(akTarget, Struggle + Damage, TargetData)
  EndIf
  If akTarget.Is3DLoaded()
    If akTarget.IsDead()
      SCVLib.handleFinishedActor(akTarget)
    ElseIf Stamina <= 0.05
      Float Magicka = akTarget.GetActorValuePercentage("Magicka")
      If !MagicPerk || Magicka <= 0.05
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

Function updateStruggle(Actor akTarget, Int aiHigherStruggle = 0, Int aiHigherDamage = 0, Int aiTargetData = 0)
  {Recursive function, checks pred and all prey for how much damage is done.}
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  Int Contents = SCVLib.getContents(akTarget, 8, TargetData)
  Int PredStruggleLevel = SCVLib.getTotalPerkLevel(akTarget, "SCV_Constriction", TargetData) + 1
  Int PredDamageLevel = SCVLib.getTotalPerkLevel(akTarget, "SCV_Acid", TargetData)
  Int TotalPreyStruggle = aiHigherStruggle
  Int TotalPreyDamage = aiHigherDamage
  Actor i = JFormMap.nextKey(Contents) as Actor
  While i
    Int PreyData = SCVLib.getTargetData(i)
    If PreyData
      TotalPreyStruggle += SCVLib.getTotalPerkLevel(i, "SCV_ThrillingStruggle", PreyData) + 1
      TotalPreyDamage += SCVLib.getTotalPerkLevel(i, "SCV_CorneredRat", PreyData)
    Else
      TotalPreyStruggle += 1
    EndIf
    updateStruggle(i, PredStruggleLevel, PredDamageLevel, PreyData)
    i = JFormMap.nextKey(Contents, i) as Actor
  EndWhile
  JMap.setInt(TargetData, "SCV_StruggleRank", TotalPreyStruggle)
  ;Note(SCVLib.nameGet(akTarget) + " struggle rank = " + TotalPreyStruggle)
  JMap.setInt(TargetData, "SCV_DamageRank", TotalPreyDamage)
  ;Note(SCVLib.nameGet(akTarget) + " damage rank = " + TotalPreyDamage)
EndFunction

Event OnUpdate()
  ;Note("Performing Struggle.")
  If !SCVLib.isInPred(MyActor, ActorData)
    SCVSet.ProcessPreyThreadManager.ProcessPreyAsync(MyActor)
  EndIf
  If SCVLib.hasStrugglePrey(MyActor)
    RegisterForSingleUpdate(1)
  EndIf
EndEvent

Event OnDeath(Actor akKiller)
  If SCVlib.hasPrey(MyActor, ActorData)
    SCVLib.handleFinishedActor(MyActor)
  EndIf
  UnregisterForUpdate()
EndEvent

Function performDailyUpdate(Actor akTarget)
  Parent.performDailyUpdate(akTarget)
  SCVLib.checkPredAbilities(akTarget)
EndFunction
