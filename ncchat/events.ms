include('/home/mcma3ncmain/.ampdata/instances/NCMain2/Minecraft/plugins/CommandHelper/LocalPackages/chat/procs.ms');

bind('player_chat', null, null, @event,
#    if(ponline('ThgilFoDrol')){
#       tmsg('ThgilFoDrol', @event);
#    }

    @channels = _ncchat_get_channels();
    @pchannel = _ncchat_player_get_channel(@event['player']);
    if(@pchannel == 'Global'){
        modify_event('format', _ncchat_format(@event['player'], @pchannel));
    } else if(@pchannel == 'Staff'){
        @chat = _ncchat_format(@event['player'], @pchannel);
        @recipients = array_map(@event['recipients'], closure(@recipient){
            if(has_permission(@recipient, @channels['Staff']['perm'])){
                return(@recipient);
            }
            return();
        });
        modify_event('recipients', @recipients);
        modify_event('format', @chat);
    } else if(@pchannel == 'Local'){
        @sploc = ploc(@event['player']); # sender player location
        @recipients = array_map(@event['recipients'], closure(@recipient){
            @rploc = ploc(@recipient); # recipient player location

            if(@sploc['world'] == @rploc['world']){ # same world
                @distance = sqrt(pow((@sploc['x'] - @rploc['x']), 2) + pow((@sploc['z'] - @rploc['z']), 2));
                if(@distance <= 200){ # in range
                    return(@recipient);
                }
            }
            return();
        });

        modify_event('recipients', @recipients);
        modify_event('format', _ncchat_format(@event['player'], @pchannel));
    }
)

broadcast(colorize('&cA reload of the chat code has reset your current chat channel to Global.'), 'nc.title.semimod');
