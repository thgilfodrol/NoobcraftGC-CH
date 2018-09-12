include('procs.ms');

bind('player_interact', array('priority': 'low'), array('player': 'ThgilFoDrol', 'itemname': 'IRON_AXE'), @event,
    @p = @event['player'];

    if(@event['action'] == 'left_click_air' || @event['action'] == 'right_click_air'){
        return();
    }

    if(!has_permission(@p, 'nc.worldedit')){
        return();
    }

    try{
        if(@event['location']['world'] != 'world'){
            tmsg(@p, colorize('&eNCWE // &bDisabled for the nether and end.'));
        }
    } catch(IndexOverflowException @e){
        tmsg(@p, colorize('&cRan into an unusual bug. Event obj @event:'));
        tmsg(@p, @event);
        tmsg(@p, colorize('&cException details: '));
        tmsg(@p, @e);
    }

    @loc = @event['location'];
    if(@event['action'] == 'left_click_block'){
        _ncwe_set_pos1(@p, @loc);
        @pos2 = _ncwe_get_pos2(@p);

        @msg = colorize('&eNCWE // &bFirst position set to '.(_ncwe_get_pos1(@p)));
        if(is_null(@pos2)){
            tmsg(@p, @msg);
        } else{
            @total = _ncwe_get_sel_total(@p);

            tmsg(@p, concat(@msg, colorize('&b ('.@total.')')))
        }
    } else if(@event['action'] == 'right_click_block'){
        _ncwe_set_pos2(@p, @loc);
        @pos1 = _ncwe_get_pos1(@p);

        @msg = colorize('&eNCWE // &bSecond position set to '.(_ncwe_get_pos2(@p)));
        if(is_null(@pos1)){
            tmsg(@p, @msg);
        } else{
            @total = _ncwe_get_sel_total(@p);

            tmsg(@p, concat(@msg, colorize('&b ('.@total.')')))
        }
    }
)
