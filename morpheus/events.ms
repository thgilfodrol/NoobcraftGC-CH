# Inspired by the Morpheus forge plugin included in a lot of (FTB) modpacks
# Adds players to list of people in bed
bind(player_enter_bed, null, null, @event, 
    include('plugins/CommandHelper/LocalPackages/morpheus/procs.ms');
    @allowedworlds = _get_allowed_worlds();

    if(array_contains(@allowedworlds, @event['location']['world'])){
        _add_sleeping_player(@event['player'], @event['location']['world']);
    }
)
