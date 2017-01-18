# Inspired by the Morpheus forge plugin included in a lot of (FTB) modpacks
# Adds players to list of people in bed
bind(player_enter_bed, null, null, @event, 
    include('plugins/CommandHelper/LocalPackages/morpheus/procs.ms');
    @allowedworlds = _get_allowed_worlds();

    if(array_contains(@allowedworlds, @event['location']['world'])){
	if(_is_valid_player(@event['player'])){ # if player can trigger time change
	    set_timeout(5000, closure(){
		if(ponline(@event['player'])){
            	    _add_sleeping_player(@event['player'], @event['location']['world']);
	    	    if(!_try_change_to_day(@event['location']['world'])){ # time is unchanged
			_prompt_players(@event['player'], @event['location']['world'], true);
	    	    }
		}
	    });
	}
    }
)

# Removes players from list of people in bed
bind(player_leave_bed, null, null, @event,
    include('plugins/CommandHelper/LocalPackages/morpheus/procs.ms');
    @allowedworlds = _get_allowed_worlds();

    if(array_contains(@allowedworlds, @event['location']['world'])){
	_remove_sleeping_player(@event['player'], @event['location']['world']);
	_prompt_players(@event['player'], @event['location']['world'], true);
    }
)
