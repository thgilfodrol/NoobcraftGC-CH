# Inspired by the Morpheus forge plugin included in a lot of (FTB) modpacks
# Adds players to list of people in bed
bind(player_enter_bed, null, null, @event, 
    include('plugins/CommandHelper/LocalPackages/morpheus/procs.ms');
    @allowedworlds = _get_allowed_worlds();

    if(array_contains(@allowedworlds, @event['location']['world'])){
	if(_is_valid_player(@event['player'])){ # if player can trigger time change
            _add_sleeping_player(@event['player'], @event['location']['world']);
	    if(!_try_change_to_day(@event['location']['world'])){ # time is unchanged
		@allplayers = all_players(@world);
		@msg = colorize('&e[&6Announcer&e] &7').@event['player'].colorize('&7 is now in bed. Need ')._get_percent_req().colorize('&7% to be in bed to transition to day.');
		foreach(@player in @allplayers){
		    tmsg(@player, @msg);
		}
	    }
	}
    }
)

# Removes players from list of people in bed
bind(player_leave_bed, null, null, @event,
    include('plugins/CommandHelper/LocalPackages/morpheus/procs.ms');
    @allowedworlds = _get_allowed_worlds();

    if(array_contains(@allowedworlds, @event['location']['world'])){
	_remove_sleeping_player(@event['player'], @event['location']['world']);
    }
)
