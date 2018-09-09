include('procs.ms');
include('jsonprocs.ms');

bind('player_chat', array('priority': 'high'), null, @event,
#    if(ponline('ThgilFoDrol')){
#       tmsg('ThgilFoDrol', @event);
#    }

    @channels = _ncchat_get_channels();
    @pchannel = _ncchat_player_get_channel(@event['player']);
    if(@pchannel == 'Global'){
        #_ncchat_tellraw('@a', json_encode(array(array('text': '{'), array('text': @event['player']), array('text': '} '.@event['message']))));

        @allplayers = all_players();
        @chatformat = _ncchat_json_format(@event['player'], @pchannel, @event['message']);
        @expanded = @chatformat['expanded'];
        @minimal = @chatformat['minimal'];

        foreach(@player in @allplayers){
            @minmode = _ncchat_player_get_minimal_mode(@player);
            if(!@minmode){
                _ncchat_tellraw(@player, @expanded);
            } else{
                _ncchat_tellraw(@player, @minimal);
            }
        }

        discord_broadcast('server', concat('<', @event['player'], '> : ', @event['message']))

        cancel();

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

        discord_broadcast('staff', concat('<', @event['player'], '> : ', @event['message']))
    } else if(@pchannel == 'Local'){
            @sploc = ploc(@event['player']); # sender player location
        @recipients = array_filter(@event['recipients'], closure(@key, @recipient){
                @rploc = ploc(@recipient); # recipient player location

                if(@sploc['world'] == @rploc['world']){ # same world
                        @distance = sqrt(pow((@sploc['x'] - @rploc['x']), 2) + pow((@sploc['z'] - @rploc['z']), 2));
                    return(@distance <= 200); # in range
                }
            });

            @nonstaff = array_filter(@recipients, closure(@key, @target){
                if(@event['player'] == @target){ # sender is receiver
                        return(true);
                }

                if(!pisop(@target) || pmode(@target) != 'SPECTATOR'){ # target isn't op nor spectator
                        return(true);
                }

                return(false);
            });
        if(array_size(@nonstaff) == 1){
                set_timeout(50, closure(){
                    tmsg(@event['player'], colorize('&eNobody hears you.'));
            });
        }

        foreach(@p in all_players()){
                if(has_permission(@p, 'nc.socialspy.local')){
                    if(!array_contains(@recipients, @p)){ # if player isn't in range
                        tmsg(@p, colorize('&8[SS] &7[L] '.@event['player'].': ').(strip_colors(@event['message'])));
                }
                }
        }

            modify_event('recipients', @recipients);
        modify_event('format', _ncchat_format(@event['player'], @pchannel));
    } else if(@pchannel == 'Upsidedown'){
            @chat = _ncchat_format(@event['player'], @pchannel);
        @recipients = array_filter(@event['recipients'], closure(@key, @recipient){
                return(has_permission(@recipient, @channels[@pchannel]['perm']));
            });
        modify_event('recipients', @recipients);
            modify_event('format', @chat);
    }

    console(concat('{S} [', @channels[@pchannel]['nick'], '] ', @event['player'], ': ', @event['message']), false);
)
