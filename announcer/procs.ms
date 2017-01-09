proc _announcer_get_broadcasts(){
    @bd = array();
    # base format: closure containing broadcast or tellraw, followed by weight of broadcast 
    # setting weight of 0 effectively disables the broadcast, setting to 2 makes it twice as likely to be picked than 1
    @bd[] = array(closure(){ broadcast(colorize()); }, 1); 
    @bd[] = array(closure(){ broadcast(colorize('Hello World!')); }, 1);

}

# Returns an array of integers representing the index of a broadcast, quantity dictated by the weight
proc _announcer_get_expanded_broadcasts(){
    @cachedlist = import('announcer.expandedbroadcastarray');
    if(@cachedlist == null){
	# Create the array, aliases must've been reloaded at some point
	@cachedlist = array();
	@broadcasts = _announcer_get_broadcasts();
	for(@i = 0, @i < array_size(@broadcasts), @i++){
	    for(@j = 0, @j < @broadcasts[@i][1], @j++){
		@cachedlist[] = @i;
	    }
	}
	# Cache the list and return it
	export('announcer.expandedbroadcastarray', @cachedlist);
	return(@cachedlist);
    } else{
	# The array already exists, so just retrieve it from cache
	return(@cachedlist);
    }
}
