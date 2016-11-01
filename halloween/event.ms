bind(player_interact, null, null, @event){
        #@starttime = time();
        if(@event[action] == 'right_click_block' && @event[world] == 'world'){
                @doors = array(64, 193, 194, 195, 196, 197);
                if(array_contains(@doors, reg_split(':', @event[block])[0])){ #only doors are trigger treats
                        #@doorlocs = array(array(2005, -3848));
                        @doorlocs = import('halloween.doorlocs', array());
                        foreach(@doorloc in @doorlocs){
                                # Check if door location matches one of the doors stored (CONSIDER USING STRICT EQUALS)
                                if(@event[location][0] == @doorloc[0] && @event[location][2] == @doorloc[1]){ # NO SUPPORT FOR Y COORDINATES
                                        # Check if player has already claimed their rewards here for today
                                        # NOTE: TIME IS TO BE STORED IN SECONDS. time() RETURNS IN MILLISECONDS.
                                        @lastknocked = import(@event[player].'.'.'halloween'.'.'.@event[location][0].'.'.@event[location][2]);
                                        if(add(@lastknocked, 79200) <= divide(time(), 1000)){ # if the time that door comes off cooldown was before the current time
                                                @tier1 = array('apple 1 name:&6Apple lore:&6Halloween_2016_reward|&aTier_1', 'inksac 2 name:&6Ink_Sac lore:&6Halloween_2016_reward|&aTier_1',
                                                        'redstonedust 16 name:&6Redstone_Dust lore:&6Halloween_2016_reward|&aTier_1', 'beetroot 8 name:&6Beetroot lore:&6Halloween_2016_reward|&aTier_1');
                                                @tier2 = array('rottenflesh 3 name:&6Rotten_Flesh lore:&6Halloween_2016_reward|&2Tier_2',
                                                        'pumpkinpie 12 name:&6Savoury_Pumpkin_Pie lore:&6Halloween_2016_reward|&2Tier_2', '383:96 1 name:&6Mooshroom_Egg lore:&6Halloween_2016_reward|&2Tier_2');
                                                @tier3 = array('goldenapple 2 name:&6Lesser_Golden_Apple lore:&6Halloween_2016_reward|&cTier_3', '322:1 1 name:&6Greater_Golden_Apple lore:&6Halloween_2016_reward|&cTier_3');
                                                @tier4 = 'pumpkin 1 name:&6Jack lore:&6Halloween_2016_reward|&4Tier_4 thorns:4';
                                                # Give reward
                                                @rand = rand(1, 11); #random number between 1-10, both inclusive
                                                #tmsg(@event[player], colorize('&8[&6Halloween&8] &6For now, your treat is a pat on the back :p'));
                                                if(@rand > 4){
                                                        if(@rand > 7){
                                                                if(@rand == 10){ #tier 4
                                                                        #rolled number is 10
                                                                        runas('~console', '/essentials:give '.@event[player].' '.@tier4);
                                                                        runas('~console', '/perm player '.@event[player].' set nc.bats.2016');
                                                                        tmsg(@event[player], colorize('&8[&6Halloween&8] &6You\'ve just learned the bat emote (WIP), and received Jack the Pumpkin!.'));
                                                                        console('[NCHalloween] Reward of tier 4 granted to '.@event[player].'.');
                                                                } else{ #tier 3
                                                                        #rolled number is 8 or 9
                                                                        runas('~console', '/essentials:give '.@event[player].' '.array_rand(@tier3, 1, false)[0]);
                                                                        tmsg(@event[player], colorize('&8[&6Halloween&8] &6You get some treats.'));
                                                                        console('[NCHalloween] Reward of tier 3 granted to '.@event[player].'.');
                                                                }
                                                        } else{ #tier 2
                                                                #rolled number is 5-7
                                                                runas('~console', '/essentials:give '.@event[player].' '.array_rand(@tier2, 1, false)[0]);
                                                                tmsg(@event[player], colorize('&8[&6Halloween&8] &6You get some treats.'));
                                                                console('[NCHalloween] Reward of tier 2 granted to '.@event[player].'.');
                                                        }
                                                } else{ #tier 1
                                                        #rolled number is 1-4
                                                        runas('~console', '/essentials:give '.@event[player].' '.array_rand(@tier1, 1, false)[0]);
                                                        tmsg(@event[player], colorize('&8[&6Halloween&8] &6You get some treats.'));
                                                        console('[NCHalloween] Reward of tier 1 granted to '.@event[player].'.');
                                                }
                                                export(@event[player].'.halloween.'.@event[location][0].'.'.@event[location][2], divide(time(), 1000));
                                        } else{
                                                # Nobody's home
                                                @timediffS = subtract(add(@lastknocked, 79200), divide(time(), 1000));
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
                                                tmsg(@event[player], colorize('&8[&6Halloween&8] &6You have already visited this house today.'));
                                                tmsg(@event[player], colorize('&6Maybe you could visit again tomorrow, in '.@timediff.'?'));
                                        }
                                        break();
                                }
                        }
                        #broadcast('completed in '.subtract(time(), @starttime).'ms.');
                }
        }
}
