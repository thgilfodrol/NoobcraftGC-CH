# Broadcast every 10 minutes, starting 5 seconds after registration
set_interval(600*1000, 5000, closure(){
    include('procs.ms'); 
    @broadcast = _announcer_get_random_broadcast();
    # array of players who ignored categories of announcements
    @playerignores = import('announcer.ignores', array()); 
    
    # If the broadcast is a tellraw
    if(@broadcast[3]){
        foreach(@player in all_players()){
	    # If player has set an ignore
	    if(array_index_exists(@playerignores, @player) && array_contains(@playerignores[@player], @broadcast[1])){
		continue();
	    } else{
		runas('~console', '/tellraw '.@player.' '.@broadcast[0]);
	    }
	}
    } else{ # broadcast is a normal string
        foreach(@player in all_players()){ # 2 duplicate loops so /tellraw check isn't done every iter, will clean up this mess later
	    # If player has set an ignore
	    if(array_index_exists(@playerignores, @player) && array_contains(@playerignores[@player], @broadcast[1])){
		continue();
	    } else{
		tmsg(@player, colorize(@broadcast[0]));
	    }
	}
    }
});
