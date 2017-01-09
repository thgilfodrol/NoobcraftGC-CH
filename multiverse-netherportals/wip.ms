# WIP message so people don't get confused while this is being written
bind(player_portal_travel, array('priority': 'highest'), null, @event){
    @p = @event['player'];
    if(@event['type'] == 'NETHER_PORTAL' || @event['type'] == 'END_PORTAL'){
        if(string_position(@event['from']['world'], 'exploreupdate') != -1){
            tmsg(@p, colorize('&4&lNOTICE: &r&cNether and End portal code is currently being rewritten due to some bugs. '.
                'If you want to go to the nether, use &a/mv tp 111_nether&c. If you want to go to the end, the portals in'.
                ' strongholds near spawn should have a &awarp sign&c at them that you can use as a substitute for the time'.
                ' being. Sorry for the inconvenience!'));
            cancel();
            consume();
        }
    }
}
