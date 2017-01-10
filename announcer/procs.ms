# Returns an array of the broadcast with the specified index if one is passed in, otherwise return the entire list of broadcasts.
# Always returns an array. Throws IndexOutOfBoundsException.
proc _announcer_get_broadcasts([@index]){
    @bd = array();
    # base format: closure containing broadcast or tellraw, then announcement category, followed by weight of broadcast 
    # setting weight of 0 effectively disables the broadcast, setting to 2 makes it twice as likely to be picked than 1
    @bd[] = array(closure(){ broadcast(colorize()); }, 'tips', 1); 
    @bd[] = array(closure(){ broadcast(colorize('Hello World!')); }, 'tips', 1);

    # Return the entire array if no index is specified
    if(@index == null || @index == ''){
        return(@bd);
    } else{
	# Return the broadcast at the specified index if an index was passed in
	if(array_index_exists(@bd, @index)){
	    return(array(@bd[@index]));
	} else{ # index does not exist
	    throw('IndexOutOfBoundsException', 'IndexOutOfBoundsException');
	}
    }
}

# Returns an array of integers representing the index of a broadcast, quantity dictated by the weight
proc _announcer_get_expanded_broadcasts(){
    @cachedlist = import('announcer.expandedbroadcastarray');
    if(@cachedlist == null){
	# Create the array, aliases must've been reloaded at some point
	@cachedlist = array();
	@broadcasts = _announcer_get_broadcasts();
	for(@i = 0, @i < array_size(@broadcasts), @i++){
	    for(@j = 0, @j < @broadcasts[@i][2], @j++){
		@cachedlist[] = @i;
	    }
	}
	# Cache the list and return it
	export('announcer.expandedbroadcastarray', @cachedlist);
	return(@cachedlist);
    }
    # The array already exists, so just retrieve it from cache
    return(@cachedlist);    
}

# Honours the weighting of the broadcasts when picking one
# Returns array containing closure, announcement category, and weight
proc _announcer_get_random_broadcast(){
    return(_announcer_get_broadcasts(array_rand(_announcer_get_expanded_broadcasts())));
}
