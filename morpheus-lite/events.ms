bind('player_enter_bed', null, null, @event,
    # is not in overworld
    if(@event['location']['world'] != 'world'){
        # exit
        return();
    }

    set_timeout(5000, closure(){
        # check if player is still in bed
        if(!pinfo(@event['player'])[16]){
            console(@event['player'].' was in a bed, but has left it.');
        }

        # stop the storm
        storm(false);
        # set time to day
        set_world_time('world', 0);

        @announcement = array('rise and shine!', 'eggs are bakey!', '*rooster noises*!', 'a new day is here!', 'time to get up!', 'it\'s day-breaky!');
        @verb = array('snoozed', 'took a nap', 'had some shut-eye', 'hit the hay', 'went to bed', 'laid down for a bit', 'fell asleep');

        # broadcast message alert
        broadcast(colorize(concat('&7{&2S&7} [G] &5[Announcer]&7: Wakey wakey, ', array_rand(@announcement, 1, false)[0], ' ', @event['player'], ' ', array_rand(@verb, 1, false)[0], ' and now it\'s day. Tada!')));
    })
)
