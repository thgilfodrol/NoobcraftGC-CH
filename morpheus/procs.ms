proc _add_sleeping_player(@player, @world){
    @key = get_storage_key();
    @asleep = import(@key, null);
    
    if(is_null(@asleep)){ # array is null, so let's create it 
	@asleep = associative_array();
	@allowedworlds = _get_allowed_worlds();
	foreach(@allowedworld in @allowedworlds){
	    # format: {'world1': {'player1', 'player2'}, 'world2': {}}
	    @asleep[@allowedworld] = array(); 
	}
    } else{ # array exists, so just add it
        @asleep[@world][] = @player;
    }

    # Export changes
    export(@key, @asleep);
}

proc _remove_sleeping_player(@player, @world){
    @key = _get_storage_key();
    @asleep = import(@key, null);

    if(is_null(@asleep)){
	# nothing in the array, nothing to remove \o/
	return;
    } else{ # array is not empty
	if(array_contains(@asleep[@world], @player)){
	    array_remove_values(@asleep, @player);
	}
    }

    # Export changes
    export(@key, @asleep);
}

proc _get_percent_req(){
    return(0.5);
}

# Worlds where Morpheus has power
proc _get_allowed_worlds(){
    return(array('world', 'exploreupdate'));
}

proc _get_storage_key(){
    return('morpheus.asleep');
}

# Evaluates if sufficient players are in bed, and changes it to day if so
# Returns true if successful
proc _try_change_to_day(@world){
    @percentreq = _get_percent_req(); # % asleep required to change to day
    @key = _get_storage_key();
    @asleep = import(@key, null);

    # Shouldn't be called before a sleeping player has been added, which would create the array
    if(is_null(@asleep)){
	return(false); # so return false
    } else{
	@allplayers = all_players(@world);
	@validplayers = _prune_ignored_players(@allplayers);
	# If there are enough people sleeping
	# Shouldn't need to check for div by 0 b/c validplayers is >= asleep[world]
	if((array_size(@asleep[@world]) / array_size(@validplayers)) >= @percentreq){
	    set_world_time(@world, 2000);
	    foreach(@p in @allplayers){ # tell everyone in the world about the time change
		tmsg(@p, colorize('&e[&6Announcer&e] &7A new day is here!'));
	    }
	    return(true);
	}
	return(false); # not enough in bed
    }
}

# Display a message to all players in the world notifying them about players in bed
# Signature: string:player, string:world, bool:entered
proc _prompt_players(@player, @world, @entered){
    @validplayers = _prune_ignored_players(all_players(@world));
    @asleep = import(_get_storage_key(), array());
    @percentreq = _get_percent_req() * 100;
    @msg = colorize('&e[&6Announcer&e] &7');
    if(@entered){
	@msg = @msg.@player.color('GRAY').'is now in bed (';
    } else{
	@msg = @msg.@player.color('GRAY').'left their bed (';
    }
    @msg = @msg.array_size(@asleep).'/'.array_size(@validplayers).'). Need '.@percentreq.'% to transition to day.';

    return(@msg);
}

# Remove players that shouldn't be considered in the percentage calculation
proc _prune_ignored_players(@playerarray){
    @pruned = array_map(@playerarray, closure(@player){
	if(_is_valid_player(@player)){ 
	    return(@player); 
	}
    });
    return(@pruned);
}

# Return if a player should be considered in the percentage calculation
proc _is_valid_player(@player){
    return(!(pisop(@player) || has_permission(@player, 'nc.morpheus.ignore')));
}
