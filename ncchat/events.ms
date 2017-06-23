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
    }
)

broadcast(colorize('&cA reload of the chat code has reset your current chat channel to Global.'), 'nc.title.semimod');
