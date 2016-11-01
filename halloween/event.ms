bind(player_interact, null, null, @event){
        if(@event[action] == 'right_click_block' && @event[world] == 'world' && @event[player] == 'ThgilFoDrol'){
                @doors = array(64, 193, 194, 195, 196, 197);
                if(array_contains(@doors, reg_split(':', @event[block])[0])){ #only doors are trigger treats
                        # Check location (currently sun's house)
                        @corner1 = array(6879, 62, -3873);
                        @corner2 = array(6876, 65, -3864);
                        if(@event[location][0] <= @corner1[0] && @event[location][0] >= @corner2[0]){
                                if(@event[location][1] >= @corner1[1] && @event[location][1] <= @corner2[1]){
                                        if(@event[location][2] >= @corner1[2] && @event[location][2] <= @corner2[2]){
                                                # Check if player has already claimed their rewards here for today
                                                # NOTE: TIME IS TO BE STORED IN SECONDS. time() RETURNS IN MILLISECONDS.
                                                @lastknocked = import(@event[player].'.'.'halloween'.'.'.@event[location][0].'.'.@event[location][1].'.'.@event[location][2]);
                                                if(add(@lastknocked, 86400) <= divide(time(), 1000)){ # if the time that door comes off cooldown was before the current time
                                                        # Give reward
                                                        @rand = rand(1, 11); #random number between 1-10, both inclusive
                                                        tmsg(@event[player], colorize('&8[&6Halloween&8] &6For now, your treat is a pat on the back :p'));
                                                        if(@rand > 4){
                                                                if(@rand > 7){
                                                                        if(@rand == 10){
                                                                                tmsg(@event[player], colorize('&8[&6Halloween&8] &6However, your reward tier ('.@rand.') would have been 10, and won the bat emote!.'));
                                                                        } else{
                                                                                tmsg(@event[player], colorize('&8[&6Halloween&8] &6However, your reward tier ('.@rand.') would have been 8-9.'));
                                                                        }
                                                                } else{
                                                                        tmsg(@event[player], colorize('&8[&6Halloween&8] &6However, your reward tier ('.@rand.') would have been 5-7.'));
                                                                }
                                                        } else{
                                                                tmsg(@event[player], colorize('&8[&6Halloween&8] &6However, your reward tier ('.@rand.') would have been 1-4.'));
                                                        }
                                                        export(@event[player].'.'.'halloween'.'.'.@event[location][0].'.'.@event[location][1].'.'.@event[location][2], divide(time(), 1000));
                                                } else{
                                                        # Nobody's home
                                                        @timediffS = subtract(add(@lastknocked, 86400), divide(time(), 1000));
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
                                                #tmsg('thgilfodrol', @event);
                                        }
                                }
                        }
                }
        }
}
