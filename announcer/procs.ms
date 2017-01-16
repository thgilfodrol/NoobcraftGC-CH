# Returns an array of the broadcast with the specified index if one is passed in, otherwise return the entire list of broadcasts.
# Always returns an array. Throws IndexOutOfBoundsException.
proc _announcer_get_broadcasts([@index]){
    @bd = array();
    # base format: string containing broadcast or tellraw, then announcement category, weight of broadcast, and if the first element is tellraw
    # setting weight of 0 effectively disables the broadcast, setting to 2 makes it twice as likely to be picked than 1
    @bd[] = array('{"text":"Sample text here."}', 'tips', 1, true); # sample tellraw broadcast
    @bd[] = array('If you clean your vacuum cleaner, you\'re making your vacuum cleaner, and you\'re a vacuum cleaner.', 'jokes', 1, false); 
    @bd[] = array('Hello World!', 'tips', 1, false);

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
		# Filter out and substitute tags like {donations} here
		# This reduces compile time and allows us to reload the announcer independently
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
# Returns array containing string, announcement category, weight, and if it's a tellraw
proc _announcer_get_random_broadcast(){
    @broadcasts = _announcer_get_expanded_broadcasts();
    return(array_rand(@broadcasts)[0]);
}
