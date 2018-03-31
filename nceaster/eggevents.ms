bind(player_interact, null, null, @event){
    #@starttime = time();
    # Player right clicked a block in the default world with their main hand
    if(@event['action'] == 'right_click_block' && @event['world'] == 'world' && @event['hand'] == 'main_hand'){
        # Array of known egg blocks (all 16 variants of terracotta)
        @eggs = array(235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250);
        if(array_contains(@eggs, split(':', @event['block'])[0])){ #only eggs trigger treats
            # Retrieve egg locations
            @egglocs = import('easter.egglocs', array());

            # Iterate through stored egg locations
            foreach(@eggloc in @egglocs){
                # Check if egg location matches one of the eggs stored (CONSIDER USING STRICT EQUALS)
                if(@event['location'][0] == @eggloc[0] && @event['location'][1] == @eggloc[1] && @event['location'][2] == @eggloc[2]){ # location matches
                    # Check if player has already claimed their rewards here for today
                    # NOTE: TIME IS TO BE STORED IN SECONDS. time() RETURNS IN MILLISECONDS.
                    @lastknocked = import(concat(@event['player'], '.', 'easter', '.', @event['location'][0], '.', @event['location'][1], '.', @event['location'][2]), 0);

                    # if the time that egg comes off cooldown was before the current time
                    if(add(@lastknocked, 72000) <= divide(time(), 1000)){ # 20 hour cooldown, leaves time for them to check the eggs at an earlier date the next day
                        @tier1 = array('apple 1 name:&eApple lore:&aEaster_2018_reward|&aTier_1',
                            'inksac 2 name:&eInk_Sac lore:&aEaster_2018_reward|&aTier_1',
                            'redstonedust 16 name:&eRedstone_Dust lore:&aEaster_2018_reward|&aTier_1',
                            'beetroot 8 name:&eBeetroot lore:&aEaster_2018_reward|&aTier_1'
                        );
                        @tier2 = array('rottenflesh 3 name:&eRotten_Flesh lore:&aEaster_2018_reward|&2Tier_2',
                            'pumpkinpie 12 name:&eSavoury_Pumpkin_Pie lore:&aEaster_2018_reward|&2Tier_2',
                            '383:96 1 name:&eMooshroom_Egg lore:&aEaster_2018_reward|&2Tier_2'
                        );
                        @tier3 = array('goldenapple 2 name:&eLesser_Golden_Apple lore:&aEaster_2018_reward|&cTier_3',
                            '322:1 1 name:&eGreater_Golden_Apple lore:&aEaster_2018_reward|&cTier_3'
                        );
                        @tier4 = concat('minecraft:leather_boots 1 0 {',
                            'display:{color:2023486,Name:"', color('GREEN'), 'Spring Boots",',
                            'Lore:["', color('YELLOW'), 'Puts some spring in your step.","', color('AQUA'), 'Easter Egg Hunt 2018"]},',
                            'Unbreakable:1,',
                            'AttributeModifiers:[',
                                '{AttributeName:"generic.movementSpeed",Name:"generic.movementSpeed",Slot:"feet",Amount:0.05,Operation:0,UUIDMost:43898,UUIDLeast:165650},', # ~ speed I/II
                                '{AttributeName:"generic.attackSpeed",Name:"generic.attackSpeed",Slot:"feet",Amount:-3,Operation:0,UUIDMost:26207,UUIDLeast:179573}],', #
#                                '{AttributeName:"generic.maxHealth",Name:"generic.maxHealth",Slot:"feet",Amount:-10,Operation:0,UUIDMost:76827,UUIDLeast:122954}],', # -10 max health (BUGGED)
                            'ench:[{id:71,lvl:1}]}' # curse of vanishing
                        );
                        # random high level enchanted book
                        @tier5 = array(
                            concat('StoredEnchantments:[{id:34,lvl:', rand(4, 11), '}]}'), # unbreaking, level 4 to 10
                            concat('StoredEnchantments:[{id:70,lvl:1}]}'), # mending, level 1
                            concat('StoredEnchantments:[{id:32,lvl:', rand(5, 8), '}]}'), # unbreaking, level 5 to 7
                            concat('StoredEnchantments:[{id:35,lvl:4}]}'), # fortune, level 4
                            concat('StoredEnchantments:[{id:33,lvl:1}]}'), # silk touch, level 1
                            concat('StoredEnchantments:[{id:2,lvl:', rand(4, 11), '}]}'), # feather falling, level 4 to 10
                            concat('StoredEnchantments:[{id:0,lvl:', rand(5, 9), '}]}'), # protection, level 5 to 8
                            concat('StoredEnchantments:[{id:7,lvl:', rand(4, 6), '}]}'), # thorns, level 4 to 5
                        );

                        # Give reward
                        @rand = rand(1, 26); # random number between 1-25, both inclusive
                        if(@rand > 10){
                            if(@rand > 18){
                                if(@rand > 22){
                                    if(@rand == 25){ #tier 5
                                        runas('~console', '/minecraft:give '.@event['player'].' enchanted_book 1 0 {display:{Lore:["Easter Egg Hunt 2018"]},'.array_rand(@tier5, 1, false)[0]);
                                        tmsg(@event['player'], colorize('&8[&bEaster&8] &bYou get a rare enchanted book!.'));
                                        broadcast(concat(colorize('&8[&bEaster&8] &e'), @event['player'], colorize('&b cracked open an egg and found a rare enchanted book!')));
                                        console('[NCEaster] Reward of tier 5 granted to '.@event['player'].'.');
                                    } else{ # tier 4
                                        #rolled number is 23-24
                                        runas('~console', '/minecraft:give '.@event['player'].' '.@tier4);
                                        runas('~console', '/perm player '.@event['player'].' set nc.title.theeggceptional');
                                        tmsg(@event['player'], colorize('&8[&bEaster&8] &bYou\'ve just unlocked the &e/nctitle&b prefix &a[The Eggceptional]!.'));
                                        broadcast(concat(colorize('&8[&bEaster&8] &e'), @event['player'], colorize('&b has just unlocked &aSpring Boots&b and the title &a[The Eggceptional]!')));
                                        console('[NCEaster] Reward of tier 4 granted to '.@event['player'].'.');
                                    }
                                } else{ #tier 3
                                    #rolled number is 19-22
                                    runas('~console', '/essentials:give '.@event['player'].' '.array_rand(@tier3, 1, false)[0]);
                                    tmsg(@event['player'], colorize('&8[&bEaster&8] &bYou get some treats.'));
                                    console('[NCEaster] Reward of tier 3 granted to '.@event['player'].'.');
                                }
                            } else{ #tier 2
                                #rolled number is 11-18
                                runas('~console', '/essentials:give '.@event['player'].' '.array_rand(@tier2, 1, false)[0]);
                                tmsg(@event['player'], colorize('&8[&bEaster&8] &bYou get some treats.'));
                                console('[NCEaster] Reward of tier 2 granted to '.@event['player'].'.');
                            }
                        } else{ #tier 1
                            #rolled number is 1-10
                            runas('~console', '/essentials:give '.@event['player'].' '.array_rand(@tier1, 1, false)[0]);
                            tmsg(@event['player'], colorize('&8[&bEaster&8] &bYou get some treats.'));
                            console('[NCEaster] Reward of tier 1 granted to '.@event['player'].'.');
                        }
                        export(@event['player'].'.easter.'.@event['location'][0].'.'.@event['location'][1].'.'.@event['location'][2], divide(time(), 1000));
                        # Prevent mcmmo unarmed ability from triggering
                        cancel();
                    } else{
                        # Nobody's home
                        @timediffS = subtract(add(@lastknocked, 72000), divide(time(), 1000));
                        if (@timediffS > 60){
                            @timediffM = floor(divide(@timediffS, 60)); # to mins
                            if (@timediffM > 60){
                                @timediffH = floor(divide(@timediffM, 60)); # to hours
                                @timediff = @timediffH.'h'.(floor(@timediffM) % 60).'m';
                            } else{
                                @timediff = @timediffM.'m'.(ceil(@timediffS) % 60).'s';
                            }
                        } else{
                            @timediff = @timediffS.'s';
                        }
                        tmsg(@event['player'], colorize('&8[&bEaster&8] &cYou have already looted this egg today.'));
                        tmsg(@event['player'], colorize('&eMaybe you could visit again tomorrow, in &a'.@timediff.'?'));
                    }
                    break();
                }
            }
            #broadcast('completed in '.subtract(time(), @starttime).'ms.');
        }
    }
}
