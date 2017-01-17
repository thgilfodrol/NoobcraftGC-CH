proc _add_sleeping_player(@player, @world){
    @key = 'morpheus.asleep';
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
    @key = 'morpheus.asleep';
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

# Worlds where Morpheus has power
proc _get_allowed_worlds(){
    return(array('world', 'exploreupdate'));
}

# Evaluates if sufficient players are in bed, and changes it to day if so
# Returns true if successful
proc _try_change_to_day(@world){
    @percentreq = 0.50; # % asleep required to change to day
    @key = 'morpheus.asleep';
    @asleep = import(@key, null);

    # Shouldn't be called before a sleeping player has been added, which would create the array
    if(is_null(@asleep)){
	return(false); # so return false
    } else{
	@allplayers = all_players([@world]);
	# If there are enough people sleeping
	# Shouldn't need to check for div by 0 b/c allplayers is >= asleep[world]
	if((array_size(@asleep[@world]) / array_size(@allplayers)) >= @percentreq){
	    set_world_time(@world, 2000);
	    foreach(@p in @allplayers){ # tell everyone in the world about the time change
		tmsg(@p, colorize('&e[&6Announcer&e] &7A new day is here!'));
	    }
	    return(true);
	}
	return(false); # not enough in bed
    }
}
