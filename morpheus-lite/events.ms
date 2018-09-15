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

        # broadcast message alert
        broadcast(colorize(concat('&7{&2S&7} [G] &5[Announcer]&7: Wakey wakey, rise and shine! ', @event['player'], ' snoozed and now it\'s day. Tada!')));
    })
)
