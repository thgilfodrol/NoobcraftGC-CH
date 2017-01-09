set_interval(600*1000, 5000, closure(){
    include('/plugins/CommandHelper/LocalPackages/announcer/procs.ms'); 
    @broadcasts = _announcer_get_broadcasts();
    
});
