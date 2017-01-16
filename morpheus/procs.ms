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

# Worlds where Morpheus has power
proc _get_allowed_worlds(){
    return(array('world', 'exploreupdate'));
}
