ScriptName SCVDatabase Extends SCLDatabase

String ScriptID = "SCVData"
SCVSettings Property SCVSet Auto
Import SCVAnimCreate
Function setupActorMainMenus()
  Parent.setupActorMainMenus()
  SCLibrary.addActorMainMenu(8, "SCV Main Menu", True)
EndFunction

Function setupItemTypes()
  Parent.setupItemTypes()
  SCLibrary.addItemType(8, "Struggling", "Currently struggling prey.", "StrugglingFullness", True)
EndFunction

Function setupAggregateValues()
  Parent.setupAggregateValues()

  Int JA_AggValues = JArray.object()
  JArray.addStr(JA_AggValues, "StruggleFullness1")
  JArray.addStr(JA_AggValues, "StruggleFullness2")
  SCLibrary.addAggregateValue("STFullness", JA_AggValues)

  JA_AggValues = JArray.object()
  JArray.addStr(JA_AggValues, "StruggleFullness3")
  JArray.addStr(JA_AggValues, "StruggleFullness4")
  SCLibrary.addAggregateValue("WF_SolidTotalFullness", JA_AggValues)
EndFunction

;/Function setupPerksList()
  Parent.setupPerksList()

  ;Intense Hunger **************************************************************
  Int JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Increases chance of success of swallow spells.")
  JArray.addStr(JA_Desc, "Increases success chance of swallow spells by 5%.")
  JArray.addStr(JA_Desc, "Increases success chance of swallow spells by another 5%.")
  JArray.addStr(JA_Desc, "Increases success chance of swallow spells by 10%.")


  Int JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have an oral predator skill level of 15 and consume 10 prey.")
  JArray.addStr(JA_Reqs, "Have an oral predator skill level of 35 and consume 35 prey.")
  JArray.addStr(JA_Reqs, "Have an oral predator skill level of 60 and consume 150 prey.")

  ;Metal Muncher ***************************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Allows you to eat Dwemer Automatons.")
  JArray.addStr(JA_Desc, "Allows you to eat Dwemer Automatons.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring Dwemer Automatons by 5% and gives a chance of acquiring bonus items from them.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring Dwemer Automatons by 10%.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have a digestion rate of at least 2, be at level 15, and possess the knowledge of the ancient Dwemer.")
  JArray.addStr(JA_Reqs, "Have a digestion rate of at least 5, be at level 25, consume 30 Dwemer Automatons, and discover the secret of the Dwemer Oculory.")
  JArray.addStr(JA_Reqs, "Have a digestion rate of at least 8, be at level 30, consume 60 Dwemer Automatons, and unlock the container with the heart of a god.")

  SCLibrary.addPerkID("SCV_MetalMuncher", JA_Desc, JA_Reqs)

  ;Follower of Namira **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Allows you to eat humans.")
  JArray.addStr(JA_Desc, "Allows you to eat humans.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring humans by 5% and gives a chance of acquiring bonus items from them.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring humans by 10%.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have more than 150 health, be at level 5, and experience contact with the Lady of Decay.")
  JArray.addStr(JA_Reqs, "Have more than 250 health, be at level 10, consume 30 humans, and discover your inner beast for the first time.")
  JArray.addStr(JA_Reqs, "Have more than 350 health, be at level 30, consume 60 humans, and devour 10 important people.")

  SCLibrary.addPerkID("SCV_FollowerofNamira", JA_Desc, JA_Reqs)

  ;Dragon Devourer **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Allows you to eat dragons.")
  JArray.addStr(JA_Desc, "Allows you to eat dragons.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring dragons by 5%.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring dragons by another 5% and gives a chance of acquiring bonus items from them.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Slay more than 30 dragons, be at level 30, and learn more about your nemesis.")
  JArray.addStr(JA_Reqs, "Slay more than 70 dragons, consume 20 of them, be at level 50, and defeat the one who will consume the world.")
  JArray.addStr(JA_Reqs, "Slay more than 100 dragons, consume 100 of them, be at level 70, and consume the essence of dragons at least 10 times.")

  SCLibrary.addPerkID("SCV_DragonDevourer", JA_Desc, JA_Reqs)

  ;Spirit Swallower **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Allows you to eat ghosts.")
  JArray.addStr(JA_Desc, "Allows you to eat ghosts.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring ghosts by 5% and gives a chance of acquiring bonus items from them.")
  JArray.addStr(JA_Desc, "Increases chances of devouring ghosts by 10%.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have more than 150 magicka, be at level 5, and discover the source of the mysterious events happening in Ivarstead.")
  JArray.addStr(JA_Reqs, "Have more than 200 magicka, be at level 10, consume 5 spirits, and free the spirits trapped in the maze.")
  JArray.addStr(JA_Reqs, "Have more than 300 magicka, be at level 15, consume 15 spirits, and stop a terrible evil from being reawakened.")

  SCLibrary.addPerkID("SCV_SpiritSwallower", JA_Desc, JA_Reqs)

  ;Expired Epicurian **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Allows you to eat the undead.")
  JArray.addStr(JA_Desc, "Allows you to eat the undead.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring the undead by 5% and gives a chance of acquiring bonus items from them.")
  JArray.addStr(JA_Desc, "Increases chances of devouring the undead by 10%.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have more than 150 Stamina, be at level 5, and defeat the conjurer keeping the lovers apart.")
  JArray.addStr(JA_Reqs, "Have more than 200 Stamina, be at level 10, consume 5 undead, and retrieve the amulet that destroyed a family.")
  JArray.addStr(JA_Reqs, "Have more than 300 Stamina, be at level 15, consume 15 undead, and wear the mysterious mask of Konahrik.")

  SCLibrary.addPerkID("SCV_ExpiredEpicurian", JA_Desc, JA_Reqs)

  ;Daedra Dieter **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Allows you to eat daedra.")
  JArray.addStr(JA_Desc, "Allows you to eat daedra.")
  JArray.addStr(JA_Desc, "Increases chances of devouring daedra by 5%.")
  JArray.addStr(JA_Desc, "Increases chances of success in devouring daedra by another 5% and gives a chance of acquiring bonus items from them.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 25 Conjuration Skill, be at level 10, and perform a task for the Prince of Dawn and Dusk.")
  JArray.addStr(JA_Reqs, "Have at least 40 Conjuration Skill, be at level 20, consume 20 daedric enemies, and investigate the cursed stone home.")
  JArray.addStr(JA_Reqs, "Have at least 60 Conjuration Skill, be at level 30, consume 50 daedric enemies, and reassemble a terrible weapon.")

  SCLibrary.addPerkID("SCV_DaedraDieter", JA_Desc, JA_Reqs)

  ;Strong Acid **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Deals health damage to struggling prey.")
  JArray.addStr(JA_Desc, "Deals slight health damage to struggling prey.")
  JArray.addStr(JA_Desc, "Deals moderate health damage to struggling prey.")
  JArray.addStr(JA_Desc, "Deals heavy health damage to struggling prey.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have a Digestion Rate of at least 4 and digest at least 350 units of food.")
  JArray.addStr(JA_Reqs, "Have a Digestion Rate of at least 10 and digest at least 700 units of food.")
  JArray.addStr(JA_Reqs, "Have a Digestion Rate of at least 20 and digest at least 1200 units of food.")

  SCLibrary.addPerkID("SCV_Acid", JA_Desc, JA_Reqs)

  ;Stalker **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Increases swallow success chance when sneaking and unseen by your prey.")
  JArray.addStr(JA_Desc, "Increases swallow success chance by 5% when sneaking and unseen by your prey.")
  JArray.addStr(JA_Desc, "Increases swallow success chance by another 5% when sneaking and unseen by your prey. Increases movement speed slightly while you have struggling prey and are sneaking.")
  JArray.addStr(JA_Desc, "Increases swallow success chance by yet another 5% when sneaking and unseen by your prey. Increases movement speed significantly while you have struggling prey and are sneaking.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 25 Sneak, be at least level 10, and have the ability to cast spells quietly.")
  JArray.addStr(JA_Reqs, "Have at least 50 Sneak, be at least level 25, and join with the Nightingales.")
  JArray.addStr(JA_Reqs, "Have at least 75 Sneak, be at least level 35 and pull off the greatest assassination in all of Tamriel.")

  SCLibrary.addPerkID("SCV_Stalker", JA_Desc, JA_Reqs)

  ;Constriction **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to struggling prey.")
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to struggling prey slightly.")
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to struggling prey moderately.")
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to struggling prey significantly.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 20 Heavy Armor, have at least 200 Stamina, and infiltrate an ancient fort on the behalf of another.")
  JArray.addStr(JA_Reqs, "Have at least 40 Heavy Armor, have at least 300 Stamina, and help a young woman discover the truth about her companion.")
  JArray.addStr(JA_Reqs, "Have at least 60 Heavy Armor, have at least 400 Stamina and help set a man's wife free.")

  SCLibrary.addPerkID("SCV_Constriction", JA_Desc, JA_Reqs)

  ;Nourishment **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Gives health regeneration when one has digesting prey.")
  JArray.addStr(JA_Desc, "Gives slight health regeneration when one has digesting prey.")
  JArray.addStr(JA_Desc, "Gives slight health and stamina regeneration when one has digesting prey.")
  JArray.addStr(JA_Desc, "Gives slight health, stamina, and magicka regeneration when one has digesting prey.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 20 Light Armor, have at least 200 Magicka, and discover the cause of a tragic fire.")
  JArray.addStr(JA_Reqs, "Have at least 40 Light Armor, have at least 300 Magicka, and assist the wizard of the Blue Palace.")
  JArray.addStr(JA_Reqs, "Have at least 60 Light Armor, have at least 400 Magicka and put an end to a sealed evil in Falkreath.")

  SCLibrary.addPerkID("SCV_Nourish", JA_Desc, JA_Reqs)

  ;Pit of Souls **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Enables one to capture enemy souls.")
  JArray.addStr(JA_Desc, "Enables one to capture enemy souls by storing soul gems in their stomach.")
  JArray.addStr(JA_Desc, "Soul gems can now capture souls one size bigger.")
  JArray.addStr(JA_Desc, "Soul gems can now capture souls two sizes bigger.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 30 Enchanting, have at least Spirit Swallower Lv. 1, be at level 15, and have the perk 'Soul Squeezer'.")
  JArray.addStr(JA_Reqs, "Have at least 55 Enchanting, have at least Spirit Swallower Lv. 2, be at level 30, capture at least 30 souls by devouring them, and assist a wizard in his studies into the Dwemer disappearance.")
  JArray.addStr(JA_Reqs, "Have at least 90 Enchanting, be at level 50, capture at least 70 souls by devouring them, and become a master Conjurer.")

  SCLibrary.addPerkID("SCV_PitOfSouls", JA_Desc, JA_Reqs)

  ;Stroke of Luck **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Gives a chance that a pred's devour attempt will fail.")
  JArray.addStr(JA_Desc, "Gives a 5% chance that a predator's devour attempt will fail.")
  JArray.addStr(JA_Desc, "Gives a 10% chance that a predator's devour attempt will fail.")
  JArray.addStr(JA_Desc, "Gives a 20% chance that a predator's devour attempt will fail.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 25 Lockpicking, and avoid being eaten 5 times.")
  JArray.addStr(JA_Reqs, "Have at least 55 Lockpicking, have at least 5 lucky moments, and be very fortunate in finding gold.")
  JArray.addStr(JA_Reqs, "Have at least 60 Lockpicking, have at least 20 lucky moments, and perform your deed to the darkness.")

  SCLibrary.addPerkID("SCV_StrokeOfLuck", JA_Desc, JA_Reqs)

  ;Expect Pushback **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Knock back enemies back after an enemy's failed devour attempt.")
  JArray.addStr(JA_Desc, "Staggers enemies after an enemy's failed devour attempt. Restores stamina.")
  JArray.addStr(JA_Desc, "Increases force of knock back. Restores magicka.")
  JArray.addStr(JA_Desc, "Increases force of knock back even more. Buffs your attacking power.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Possess the word 'Force', be at level 7, and show your prowess of hand-to-hand combat in Riften.")
  JArray.addStr(JA_Reqs, "Possess the word 'Balance', be at level 15, and a retrieve a woman's prized weapon for her.")
  JArray.addStr(JA_Reqs, "Possess the word 'Push', be at level 25, and meet a true master of the Voice.")

  SCLibrary.addPerkID("SCV_ExpectPushback", JA_Desc, JA_Reqs)

  ;Cornered Rat **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Deals health damage to one's pred.")
  JArray.addStr(JA_Desc, "Deals slight health damage to one's predator.")
  JArray.addStr(JA_Desc, "Deals moderate health damage to one's predator.")
  JArray.addStr(JA_Desc, "Deals heavy health damage to one's predator.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Be eaten at least once and survive, and locate a man hiding for his life surrounded by rats.")
  JArray.addStr(JA_Reqs, "Be eaten at least 5 times and survive, and put an end to the man who sealed himself away for a chance at power.")
  JArray.addStr(JA_Reqs, "Be eaten at least 15 times and survive, and help capture a powerful beast.")

  SCLibrary.addPerkID("SCV_CorneredRat", JA_Desc, JA_Reqs)

  ;Filling Meal **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Increase's one's size while inside a predator.")
  JArray.addStr(JA_Desc, "Increase's one's size while inside a predator by 20%.")
  JArray.addStr(JA_Desc, "Increase's one's size while inside a predator by 40%.")
  JArray.addStr(JA_Desc, "Increase's one's size while inside a predator by 60%.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Take up at least 300 units in a prey's stomach and be at level 15.")
  JArray.addStr(JA_Reqs, "Take up at least 500 units in a prey's stomach, be at level 25, and have a resistance skill of at least 30.")
  JArray.addStr(JA_Reqs, "Take up at least 800 units in a prey's stomach, be at level 35, and have a resistance skill of at least 50.")

  SCLibrary.addPerkID("SCV_FillingMeal", JA_Desc, JA_Reqs)

  ;Thrilling Struggle **********************************************************
  JA_Desc = JArray.object()
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to one's predator.")
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to one's predator slightly.")
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to one's predator moderately.")
  JArray.addStr(JA_Desc, "Increases stamina/magicka damage done to one's predator significantly.")


  JA_Reqs = JArray.object()
  JArray.addStr(JA_Reqs, "No Requirements")
  JArray.addStr(JA_Reqs, "Have at least 250 points of energy and a resistance skill of at least 20.")
  JArray.addStr(JA_Reqs, "Have at least 350 points of energy, a resistance skill of at least 40, and escape a wrongful imprisonment.")
  JArray.addStr(JA_Reqs, "Have at least 700 points of energy, a resistance skill of at least 60, and cause an incident at sea.")

  SCLibrary.addPerkID("SCV_ThrillingStruggle", JA_Desc, JA_Reqs)
EndFunction/;

Function setupMessages()
  Parent.setupMessages()
  SCLibrary.addMessage("SCVPredSwallow1", "Hmm! Tasty!")
  SCLibrary.addMessage("SCVPredSwallow1", "So nice to have you for dinner!")
  SCLibrary.addMessage("SCVPredSwallow1", "Not bad.")
  SCLibrary.addMessage("SCVPredSwallow1", "Nice to EAT you! Maybe I should keep these things to myself.")
  SCLibrary.addMessage("SCVPredSwallow1", "Could use some seasoning, but it's acceptable.")
  SCLibrary.addMessage("SCVPredSwallow1", "I've had better.")
  SCLibrary.addMessage("SCVPredSwallow1", "Mmm, HMM! *GULP*")
  SCLibrary.addMessage("SCVPredSwallow1", "Yum!")
  SCLibrary.addMessage("SCVPredSwallow1", "More, please!")
  SCLibrary.addMessage("SCVPredSwallow1", "Into my belly you go!")
  SCLibrary.addMessage("SCVPredSwallow1", "In my mouth. NOW.")
  SCLibrary.addMessage("SCVPredSwallow1", "A meal fit for... well, not a king, but someone.")
  SCLibrary.addMessage("SCVPredSwallow1", "No complaints.")
  SCLibrary.addMessage("SCVPredSwallow1", "I should try to find more... appetizing, meals")
  SCLibrary.addMessage("SCVPredSwallow1", "I should start carrying salt with me.")
  SCLibrary.addMessage("SCVPredSwallow1", "Down the hatch!")
  SCLibrary.addMessage("SCVPredSwallow1", "Don't worry, my belly will take good care of you.")
  SCLibrary.addMessage("SCVPredSwallow1", "I hope no one minds the bulge in my stomach.")
  SCLibrary.addMessage("SCVPredSwallow1", "Not the best.")
  SCLibrary.addMessage("SCVPredSwallow1", "*BEEEELLLLCH!!!*... Excuse me.")
  SCLibrary.addMessage("SCVPredSwallow1", "Welcome to your new home.")
  SCLibrary.addMessage("SCVPredSwallow1", "Thank the gods, you tasted okay.")
  SCLibrary.addMessage("SCVPredSwallow1", "Feels nice having someone new in my belly.")
  SCLibrary.addMessage("SCVPredSwallow1", "Alright! Who's next!")
  SCLibrary.addMessage("SCVPredSwallow1", "I wouldn't mind eating you again.")
  SCLibrary.addMessage("SCVPredSwallow1", "Perhaps a nice sauce would improve this meal.")

  SCLibrary.addMessage("SCVPredCantEatFull1", "I can't eat that! I'm too full!")
  SCLibrary.addMessage("SCVPredCantEatFull1", "I would love to eat that, but I don't think it'll fit.")
  SCLibrary.addMessage("SCVPredCantEatFull1", "Tempting, but no. Too full.")
  SCLibrary.addMessage("SCVPredCantEatFull1", "Nope. Have to think about my figure.")
  SCLibrary.addMessage("SCVPredCantEatFull1", "I'd need a lot of muscle relaxers to be able to eat that.")
  SCLibrary.addMessage("SCVPredCantEatFull2", "You can't eat that. You're too full.")
  SCLibrary.addMessage("SCVPredCantEatFull2", "You would love to eat that, but you don't think it'll fit.")
  SCLibrary.addMessage("SCVPredCantEatFull2", "You find the meal very tempting, but worry it would be too much.")
  SCLibrary.addMessage("SCVPredCantEatFull2", "You would need to take a lot of muscle relaxers before you could eat that.")
  SCLibrary.addMessage("SCVPredCantEatFull3", "%p can't eat that; they're too full.")
  SCLibrary.addMessage("SCVPredCantEatFull3", "%p would love to eat that, but they don't think it'll fit.")
  SCLibrary.addMessage("SCVPredCantEatFull3", "%p thinks that it is very tempting, but fears that it would be too much.")
  SCLibrary.addMessage("SCVPredCantEatFull3", "%p would need to take a lot of muscle relaxers before they could eat that.")

  SCLibrary.addMessage("SCVPredSwallowPositive1", "Oh GODS, let me eat you again!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "I'm tempted to vomit you up just so I can eat you again.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "*GASP* That's GOOD!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "If I never ate again after this, I could still die happy.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "Perfection.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "More! MORE!!!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "So delicious!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "How do you taste SO GOOD!?")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "Sorry I licked you on the way down, you just tasted so good.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "Let me savor this moment.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "I haven't eaten this good since that incident in the Reach!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "I can't think of anything to make this meal better.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "Going back for seconds! Maybe even thirds!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "There's just. So much FLAVOR!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "The finest chefs in all of Tamriel couldn't make a better meal.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "I feel so pampered!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "What did I do to deserve such a blessed meal!?")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "How do you make yourself so tasty?")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "If only you were fatter... More for me to eat!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "Finally, some good food.")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "It's a party in my mouth!")
  SCLibrary.addMessage("SCVPredSwallowPositive1", "My compliments to the chef.")

  SCLibrary.addMessage("SCVPredSwallowStealth1", "Sneaky sneaky, munchy munchy.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "Shhh. That's right, in you go.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "Quickly! Hide in my mouth!")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "Shush stomach, food's coming right now.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "*Rumble*... Nobody heard that, right?")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "*Burrp!*... Excuse me.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "It's going to be hard to sneak with you in my belly.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "You better not get me spotted.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "I'm going to need you to be quiet.")
  SCLibrary.addMessage("SCVPredSwallowStealth1", "Keep quiet, and I may let you out.")

  SCLibrary.addMessage("SCVPredSwallowNegative1", "Yikes. You did NOT taste good.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Ugh, I think I liked you outside my belly than in.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "When was the last you bathed? Just foul.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "You taste like dirt and sadness.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "If I wanted to eat crap, I would've gone to eat at your mother's.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "You taste like something cooked by a falmer.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "The best spices in Cyrodiil couldn't save this meal.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Bleh, I'm going to need a strong ale to wash this down.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Send this back to the chef!")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Looks better than it tastes.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I don't want to finish this... Not worth the effort.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "What have I done to deserve this wretched meal?")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I can barely keep this down.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "PLAYER! Do NOT feed me that again!")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "With a decent sauce, this.. would still be terrible.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Must not puke. Must NOT puke.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I should puke you up on taste alone.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "My tongue feels violated.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I detect a hint of fetid cheese, and an aftertaste of orc ass.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "SOAP, people! Do you know what it is?")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I regret every decision that led up to me eating you.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I'm sure you're very pleasant to be around, but you leave a bad taste in my mouth.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "I feel there was more productive and flavor things that I could've done instead of eating you.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Why do you taste BITTER!?")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Is there a spell to make you taste better? Or at least numb my tongue?")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "Sometimes I regret becoming a predator.")
  SCLibrary.addMessage("SCVPredSwallowNegative1", "This... this tastes like death.")

  SCLibrary.addMessage("SCVOVPredStruggle1", "Ohh, feisty!")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Stop moving already!")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Belly's bouncing!")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Yeah, keep fighting! See what happens!")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Are you done yet?")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Let's get you some light. *Yawn*")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Relax! It'll be over soon.")
  SCLibrary.addMessage("SCVOVPredStruggle1", "I have more important things to do than to wait for you to fall asleep.")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Your struggles only amuse me.")
  SCLibrary.addMessage("SCVOVPredStruggle1", "Hey, that tickles!")
  SCLibrary.addMessage("SCVOVPredStruggle1", "What's that? I can't hear you over my stomach rumbling.")
  ;SCLibrary.addMessage("SCVOVPredStruggle1", "")

  SCLibrary.addMessage("SCVAVPredStruggle1", "Ohh, feisty!")
  SCLibrary.addMessage("SCVAVPredStruggle1", "Stop moving already!")
  SCLibrary.addMessage("SCVAVPredStruggle1", "Yeah, keep fighting! See what happens!")
  SCLibrary.addMessage("SCVAVPredStruggle1", "Are you done yet?")
  SCLibrary.addMessage("SCVAVPredStruggle1", "Relax! It'll be over soon.")
  SCLibrary.addMessage("SCVAVPredStruggle1", "I have more important things to do than to wait for you to fall asleep.")
  SCLibrary.addMessage("SCVAVPredStruggle1", "Your struggles only amuse me.")
  SCLibrary.addMessage("SCVAVPredStruggle1", "Hey, that tickles!")

  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "Ow, hey!")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "That hurts!")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "My tummy hurts.")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "I don't have butterflys in my stomach, apparently I have BEES!")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "Oof!")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "Oh, gods. This hurts.")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "Feels like I ate a porcupine.")
  SCLibrary.addMessage("SCVOVPredStruggleDamage1", "What are you DOING in there!?")
  ;SCLibrary.addMessage("SCVOVPredStruggleDamage1", "")

  SCLibrary.addMessage("SCVAVPredStruggleDamage1", "Ow, hey!")
  SCLibrary.addMessage("SCVAVPredStruggleDamage1", "That hurts!")
  SCLibrary.addMessage("SCVAVPredStruggleDamage1", "Oof!")
  SCLibrary.addMessage("SCVAVPredStruggleDamage1", "Oh, gods. This hurts.")
  SCLibrary.addMessage("SCVAVPredStruggleDamage1", "What are you DOING in there!?")
  ;SCLibrary.addMessage("SCVAVPredStruggleDamage1", "")

  SCLibrary.addMessage("SCVOVPredStruggleTired1", "You can't go on forever...")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "Don't know if I can last much longer...")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "Can't go on...")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "Hope you finish soon...")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "I feel something crawling up my throat!")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "Dammit, stay down!")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "*Pant* *Pant* This better finish soon")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "I should drink a stamina potion.")
  SCLibrary.addMessage("SCVOVPredStruggleTired1", "You're wearing me out!")
  ;SCLibrary.addMessage("SCVOVPredStruggleTired1", "")

  SCLibrary.addMessage("SCVAVPredStruggleTired1", "You can't go on forever...")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "Don't know if I can last much longer...")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "Can't go on...")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "Hope you finish soon...")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "Dammit, stay down!")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "*Pant* *Pant* This better finish soon")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "I should drink a stamina potion.")
  SCLibrary.addMessage("SCVAVPredStruggleTired1", "You're wearing me out!")


  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "*Beeeelch!* Oh, that felt good!")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "Hey! You awake in there?")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "Another one bites the dust.")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "*Poke's belly* You OK?")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "Don't feel bad! You were eaten by the Dragonborn!")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "Oof. That was a rough meal.")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "Good! Less of a strain on my poor belly.")
  SCLibrary.addMessage("SCVOVPredStruggleFinished1", "Ugh, this is going to go straight to my thighs.")
  ;SCLibrary.addMessage("SCVOVPredStruggleFinished1", "")

  SCLibrary.addMessage("SCVAVPredStruggleFinished1", "Are you done in there? It hurts to sit when you're in my ass.")
  SCLibrary.addMessage("SCVAVPredStruggleFinished1", "Hey! You awake in there?")
  SCLibrary.addMessage("SCVAVPredStruggleFinished1", "Another one bites the dust.")
  ;SCLibrary.addMessage("SCVAVPredStruggleFinished1", "")


  SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "Finally! I need a belly rub.")
  SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "Hmm? Oh, all gone.")
  SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "Pity; it was starting to feel good.")
  SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "BUURRRRRRPPPP. Nice.")
  SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "Feeling pretty dead in there.")
  SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "*Jiggle* *Jiggle* Anybody awake in there?")
  ;SCLibrary.addMessage("SCVOVPredAllStruggleFinished1", "")

  SCLibrary.addMessage("SCVAVPredAllStruggleFinished1", "Finally! That was a pain in the rear.")
  SCLibrary.addMessage("SCVAVPredAllStruggleFinished1", "Pity; it was starting to feel good.")
  SCLibrary.addMessage("SCVAVPredAllStruggleFinished1", "Hmm? Oh, all gone.")

  SCLibrary.addMessage("SCVPredStartFrenzy1", "I suddenly feel very... hungry.")
  SCLibrary.addMessage("SCVPredStartFrenzy1", "I... I... I NEED FOOD!!!")
  SCLibrary.addMessage("SCVPredStartFrenzy1", "HUNGRY!")
  SCLibrary.addMessage("SCVPredStartFrenzy1", "I can't think... I can't think... Except... FOOOODDD!")
  SCLibrary.addMessage("SCVPredStartFrenzy1", "*RUMBLE* That can't be good.")
  ;SCLibrary.addMessage("SCVPredStartFrenzy1", "")

  SCLibrary.addMessage("SCVPredFrenzyLow1", "Need to find food... Need to find food!")
  SCLibrary.addMessage("SCVPredFrenzyLow1", "I'm wasting away!")
  SCLibrary.addMessage("SCVPredFrenzyLow1", "It feels like my stomach is eating itself!")
  SCLibrary.addMessage("SCVPredFrenzyLow1", "I need to find food NOW!")
  SCLibrary.addMessage("SCVPredFrenzyLow1", "Gotta fill this belly!")
  SCLibrary.addMessage("SCVPredFrenzyLow1", "Do I have anything in my pack to eat?")
  SCLibrary.addMessage("SCVPredFrenzyLow1", "Mmmmhh... Food...")

  SCLibrary.addMessage("SCVPredFrenzyFollowerLow1", "Maybe I should ask %t if they have any food.")
  SCLibrary.addMessage("SCVPredFrenzyFollowerLow1", "I wonder if %t have a snack?")
  SCLibrary.addMessage("SCVPredFrenzyFollowerLow1", "Did %t always smell so nice?")
  SCLibrary.addMessage("SCVPredFrenzyFollowerLow1", "Is %t withholding food from me? I smell something really good!")
  SCLibrary.addMessage("SCVPredFrenzyFollowerLow1", "Why do I drool when I look at %t?")
  SCLibrary.addMessage("SCVPredFrenzyFollowerLow1", "For some reason, %t is just... irresitable right now.")

  ;Check pFollowerAlias to see if we can't find who our teammate is.


  SCLibrary.addMessage("SCVPredFrenzyFindFood1", "I need to eat this NOW.")
  SCLibrary.addMessage("SCVPredFrenzyFindFood1", "I don't think this will help... but it can't hurt!")
  SCLibrary.addMessage("SCVPredFrenzyFindFood1", "Hope this helps!")
  SCLibrary.addMessage("SCVPredFrenzyFindFood1", "Ohhh... Tasty!")
  SCLibrary.addMessage("SCVPredFrenzyFindFood1", "Looks delicious!")
  SCLibrary.addMessage("SCVPredFrenzyFindFood1", "Hope no one minds if I take this.")
  ;SCLibrary.addMessage("SCVPredFrenzyFindFood1", "")

  SCLibrary.addMessage("SCVPredFrenzyFindPrey1", "Ohhh, you look tasty!")
  SCLibrary.addMessage("SCVPredFrenzyFindPrey1", "IN MY MOUTH. NOW.")
  ;SCLibrary.addMessage("SCVPredFrenzyFindPrey1", "")

  SCLibrary.addMessage("SCVPredFrenzySatisfyLow1", "Better!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyLow1", "Hooo... Needed that!")
  ;SCLibrary.addMessage("SCVPredFrenzySatisfyLow1", "")

  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "MORE!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "IT'S NOT ENOUGH!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "MORE! GIVE ME MORE!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "TOO SMALL! NEED SOMETHING BIGGER!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "I WILL CONSUME THE WORLD!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "ALDUIN HAS NOTHING ON ME!")
  SCLibrary.addMessage("SCVPredFrenzySatisfyHigh1", "ALL OF NIRN WILL FEAR MY APPETITE!")

  ;SCLibrary.addMessage("SCVPredFrenzyHigh1", "")

  SCLibrary.addMessage("SCVPreySwallowed1", "HEY! Let go!")
  SCLibrary.addMessage("SCVPreySwallowed1", "Why is it dark all of a sudden?")
  SCLibrary.addMessage("SCVPreySwallowed1", "Eww, your breath smells!")
  SCLibrary.addMessage("SCVPreySwallowed1", "How DARE you swallow me!?")
  SCLibrary.addMessage("SCVPreySwallowed1", "No! NO!")

  SCLibrary.addMessage("SCVPreyTakenIn1", "NO! Not in there!")
  ;SCLibrary.addMessage("SCVPreyTakenIn1", "")


  SCLibrary.addMessage("SCVPreyStruggle1", "I need to get out of here!")
  ;SCLibrary.addMessage("SCVPreyStruggle1", "")


  SCLibrary.addMessage("SCVPreyStruggleTired1", "I can't go on much longer...")
  ;SCLibrary.addMessage("SCVPreyStruggleTired1", "")

  SCLibrary.addMessage("SCVPreyStruggleDamage1", "Ouch!")
  ;SCLibrary.addMessage("SCVPreyStruggleDamage1", "")


  SCLibrary.addMessage("SCVPreyFinished1", "I'm finished...")
  SCLibrary.addMessage("SCVPreyFinished1", "I... can't go on...")
  SCLibrary.addMessage("SCVPreyFinished1", "No more...")
  SCLibrary.addMessage("SCVPreyFinished1", "Goodbye world...")
  ;SCLibrary.addMessage("SCVPreyFinished1", "")
EndFunction


Function setupItemDatabase()
  Parent.setupItemDatabase()
  ;RaceData
  ;ArgonianRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013740, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.8)
  ;ArgonianRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x0008883A, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;BretonRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013741, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;BretonRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x0005553C, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;DarkElfRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013742, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;DarkElfRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x0008883D, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;ElderRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00067CD8, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;ElderRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x000A82BA, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;ImperialRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013744, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;ImperialRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x00088844, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;KhajiitRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013745, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;KhajiitRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x00088845, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;NordRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013746, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;NordRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x00088794, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;OrcRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013747, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;OrcRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x000A82B9, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;RedguardRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013748, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;RedguardRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x00088846, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;WoodElfRace
  ;JFormDB.setInt(Game.GetFormFromFile(0x00013749, "Skyrim.esm") as Race, ".SCLItemDatabase.STValidRace", 1)
  ;WoodElfRaceVampire
  JFormDB.setFlt(Game.GetFormFromFile(0x00088884, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightModifier", 0.5)

  ;Animal Races ****************************************************************

  ;BearBlackRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131E8, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 300)

  ;BearBrownRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131E7, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 300)

  ;BearSnowRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131E9, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 300)

  ;ChaurusRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131EB, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 200)
  JFormDB.setFlt(Game.GetFormFromFile(0x000131EB, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.4)

  ;ChaurusReaperRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000A5601, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 250)
  JFormDB.setFlt(Game.GetFormFromFile(0x000A5601, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.6)

  ;ChickenRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000A919D, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 3)

  ;Cow Race
  JFormDB.setFlt(Game.GetFormFromFile(0x0004E785, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 300)

  ;DeerRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000CF89B, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 150)

  ;DogRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131EE, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 75)

  ;ElkRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131ED, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 250)

  ;FoxRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00109C7C, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 5)

  ;FrostbiteSpiderRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131F8, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 75)
  JFormDB.setFlt(Game.GetFormFromFile(0x000131F8, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.8)

  ;FrostbiteSpiderRaceGiant
  JFormDB.setFlt(Game.GetFormFromFile(0x0004E507, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 400)
  JFormDB.setFlt(Game.GetFormFromFile(0x0004E507, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.8)

  ;FrostbiteSpiderRaceLarge
  JFormDB.setFlt(Game.GetFormFromFile(0x00053477, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 200)
  JFormDB.setFlt(Game.GetFormFromFile(0x00053477, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.8)

  ;GiantRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131F9, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 600)

  ;GoatDomesticsRace
  JFormDB.setFlt(Game.GetFormFromFile(0x0006FC4A, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 30)

  ;GoatRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FA, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 30)

  ;HagravenRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FB, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 60)

  ;HareRace
  JFormDB.setFlt(Game.GetFormFromFile(0x0006DC99, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 3)

  ;HorkerRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FC, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 500)

  ;HorseRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FD, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 550)

  ;IceWrathRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FE, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 5)
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FE, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.7)

  ;MagicAnomalyRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000B6F95, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 1)

  ;MammothRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131FF, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 2000)

  ;MudcrabRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000BA545, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 15)
  JFormDB.setFlt(Game.GetFormFromFile(0x000BA545, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.75)

  ;RigidSkeletonRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000B9FD7, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 40)
  JFormDB.setFlt(Game.GetFormFromFile(0x000B9FD7, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.5)


  ;SabreCatRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013200, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 200)

  ;SabreCatSnowyRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013202, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 200)

  ;SkeeverRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013201, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 5)

  ;SkeeverWhiteRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000C3EDF, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 5)

  ;SkeletonNecroRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000EB872, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 40)
  JFormDB.setFlt(Game.GetFormFromFile(0x000EB872, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.5)

  ;SkeletonRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000B7998, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 40)
  JFormDB.setFlt(Game.GetFormFromFile(0x000B7998, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.5)

  ;SlaughterFishRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013203, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 5)

  ;SprigganMatronRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000F3903, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 120)
  JFormDB.setFlt(Game.GetFormFromFile(0x000F3903, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.7)

  ;SprigganRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013204, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 100)
  JFormDB.setFlt(Game.GetFormFromFile(0x00013204, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.8)

  ;SprigganSwarmRace
  JFormDB.setInt(Game.GetFormFromFile(0x0009AA44, "Skyrim.esm") as Race, ".SCLItemDatabase.SCVPreyBlocked", 1)

  ;SwarmRace
  JFormDB.setInt(Game.GetFormFromFile(0x0009AA3C, "Skyrim.esm") as Race, ".SCLItemDatabase.SCVPreyBlocked", 1)

  ;TrollFrostRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013206, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 300)

  ;TrollRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00013205, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 300)

  ;WerewolfBeastRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000CDD84, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 350)

  ;WhiteStagRace
  JFormDB.setInt(Game.GetFormFromFile(0x00104F45, "Skyrim.esm") as Race, ".SCLItemDatabase.SCVPreyBlocked", 1)

  ;WispRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131E8, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 1)

  ;WolfRace
  JFormDB.setFlt(Game.GetFormFromFile(0x0001320A, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 80)

  ;Dragon Races ****************************************************************
  ;AlduinRace
  JFormDB.setFlt(Game.GetFormFromFile(0x000131E8, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 3000)
  JFormDB.setFlt(Game.GetFormFromFile(0x000131E8, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.2)

  ;DragonRace
  JFormDB.setFlt(Game.GetFormFromFile(0x00012E82, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 2500)
  JFormDB.setFlt(Game.GetFormFromFile(0x00012E82, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.4)

  ;UndeadDragonRace
  JFormDB.setFlt(Game.GetFormFromFile(0x001052A3, "Skyrim.esm") as Race, ".SCLItemDatabase.WeightOverride", 1500)
  JFormDB.setFlt(Game.GetFormFromFile(0x001052A3, "Skyrim.esm") as Race, ".SCLItemDatabase.Durablity", 0.3)

EndFunction

String[] Function setupInstalledMods()
  String[] ModsChanged = Parent.setupInstalledMods()
  Int JA_ModsChanged = JValue.retain(JArray.objectWithStrings(ModsChanged))
  Int JFD_Items = JDB.solveObj(".SCLItemDatabase")
;FNIS --------------------------------------------------------------------------
  If SCLibrary.isModInstalled("FNIS.esp") && !SCVSet.FNIS_Initialized
    setupFNIS(JFD_Items)
    SCVSet.FNIS_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added FNIS.esp")
  ElseIf !SCLibrary.isModInstalled("FNIS.esp") && SCVSet.FNIS_Initialized
    removeFNIS(JFD_Items)
    SCVSet.FNIS_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed FNIS.esp")
  EndIf

  ;Size Matters ----------------------------------------------------------------
  If SCLibrary.isModInstalled("GTS.esp") && !SCVSet.SizeMatters_Initialized
    setupSizeMatters(JFD_Items)
    SCVSet.SizeMatters_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added GTS.esp")
  ElseIf !SCLibrary.isModInstalled("GTS.esp") && SCVSet.SizeMatters_Initialized
    removeSizeMatters(JFD_Items)
    SCVSet.SizeMatters_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed GTS.esp")
  EndIf
  ;*****************************************************************************
  String[] Results = Utility.CreateStringArray(JArray.count(JA_ModsChanged), "")
  JArray.writeToStringPArray(JA_ModsChanged, Results)
  JValue.release(JA_ModsChanged)
  Return Results
EndFunction

Function setupFNIS(Int JFD_Items)
  ;SCV_ThroatGrabSwallowAnim01 *************************************************
  Int Anim = createAnimationBase("ThroatGrabSwallow01", "Oral", "human", "human", 0, "Combat")
  setActorOffset(Anim, 0, 1, 100, 0, 0, 0)
  setAnimation(Anim, 0, 0, "SCV_ThroatGrabSwallow01aEvent")
  setAnimation(Anim, 0, 1, "SCV_ThroatGrabSwallow01bEvent")
  setTimer(Anim, 0, 1.5)

  setOpenMouth(Anim, 1, 0, 1)
  setTimer(Anim, 1, 0.3333)

  setBoneScale(Anim, 2, 1, "NPC Neck [Neck]", 0.1)
  setTimer(Anim, 2, 0.3333)

  setBoneScale(Anim, 3, 1, "NPC Spine2 [Spn2]", 0.1)
  setTimer(Anim, 3, 0.5)

  setBoneScale(Anim, 4, 1, "NPC COM [COM]", 0.1)
  setTimer(Anim, 4, 0.3333)
  ;JValue.writeToFile(Anim, "SCV_AnimTest.txt")
  ;*****************************************************************************
EndFunction

Function removeFNIS(Int JFD_Items)
EndFunction

Function setupSizeMatters(Int JFD_Items)
EndFunction

Function removeSizeMatters(Int JFD_Items)
EndFunction
