# Inspired by the Morpheus forge plugin included in a lot of (FTB) modpacks
# Adds players to list of people in bed
bind(player_enter_bed, null, null, @event, 
    include('plugins/CommandHelper/LocalPackages/morpheus/procs.ms');
    @allowedworlds = _get_allowed_worlds();

    if(array_contains(@allowedworlds, @event['location']['world'])){
	if(_is_valid_player(@event['player'])){ # if player can trigger time change
	    @ploc1 = array_normalize(ploc(@event['player']))[0]; # x loc of bed
	    set_timeout(5000, closure(){
		@ploc2 = array_normalize(ploc(@event['player']))[0]; # current x loc
		# make sure player is still online and that they didn't move
		if(ponline(@event['player']) && @ploc1 == @ploc2){
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
	if(get_world_time(@event['location']['world']) >= 12500){ 
	    # player didn't exit bed because it became daytime; it's still night
	    _prompt_players(@event['player'], @event['location']['world'], false);
	}
    }
)
