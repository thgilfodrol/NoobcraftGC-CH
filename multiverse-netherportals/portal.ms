#bind(player_portal_travel, null, array('type': 'NETHER_PORTAL'), @event){
#       include('/home/mcma3ncmain/testservers/ncmainclone_2016-12-15/plugins/CommandHelper/LocalPackages/portals/procs.ms');
#       @p = @event['player'];
#       tmsg(@p, @event);
#tmsg(@p, 'NETHER PORTAL CODE FIRING NOW');
#return();
#    if(_can_have_nether_portal(@event['from']['world'])){
#        @divisionfactor = _ndivision_factor(_ndestination_world(@event['from']['world']));
#               @ploc = ploc();
#        @to = array(floor(divide(@event['from']['x'], @divisionfactor)), @event['from']['y'], floor(divide(@event['from']['z'], @divisionfactor)), _ndestination_world(@event['from']['world']));
#        tmsg(@p, @to);
#        set_timeout(3000, closure(){
#            @nploc = ploc(); # location after 3 seconds
#            if(!ponline(@event['player'])){ die(); }
##            if(floor(@nploc[0]) !== floor(@ploc[0]) || floor(@nploc[2]) !== floor(@ploc[2])){
##                tmsg(@event['player'], 'Cancelled teleport due to movement');
##                die();
##            }
#            if(!set_ploc(@event['player'], @to)){
#                tmsg(@p, ('Could not transport player.'));
#                tmsg(@p, @to);
#            } else{
#                @ploc = ploc(); # location after teleport
#                tmsg(@p, @ploc);
#                tmsg(@p, 'Prepping portal...');
#                @ploc = array(floor(divide(@nploc[0], @divisionfactor)), @ploc[1], floor(divide(@nploc[2], @divisionfactor)), _ndestination_world(@event['from']['world']));
#                @ploc1 = array(@ploc[0], @ploc[1], @ploc[2] - 1, _ndestination_world(@event['from']['world']));
#                @ploc2 = array(@ploc[0], @ploc[1], @ploc[2] + 2, _ndestination_world(@event['from']['world']));
#                _create_nether_portal(@ploc1, @ploc2);
#                tmsg(@p, @ploc1 . '\n' . @ploc2);
#            }
#        });
#    }
#}

bind(player_portal_travel, null, array('type': 'END_PORTAL'), @event){
    @p = @event['player'];
    tmsg(@p, @event);
    @111endspawn = array(69, 59, 69, 'exploreupdate_the_end', 179.9, 0);
    @111spawn = array(249, 77, 230, 'exploreupdate', 179.9, 0);
    @dest = array();

    switch(@event['from']['world']){
        case 'exploreupdate':
            @dest = @111endspawn;
        case 'exploreupdate_the_end':
            @dest = @111spawn;
        default:
            return();
    }
    #modify_event('to', @dest);
    # try pseudoknight's spigot bug workaround
    set_timeout(50, closure(){
        set_ploc(@p, @dest);
    });
    tmsg(@p, @dest);
}
