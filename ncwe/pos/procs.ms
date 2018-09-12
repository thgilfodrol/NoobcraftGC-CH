proc _ncwe_get_pos1(@player){
    @pos1 = import('ncwe.pos1.'.@player);

    return(@pos1);
}

proc _ncwe_set_pos1(@player, @loc){
    export('ncwe.pos1.'.@player, array('x': integer(@loc['x']), 'y': integer(@loc['y']), 'z': integer(@loc['z']), 'world': @loc['world']));
}

proc _ncwe_get_pos2(@player){
    @pos2 = import('ncwe.pos2.'.@player);

    return(@pos2);
}

proc _ncwe_set_pos2(@player, @loc){
    export('ncwe.pos2.'.@player, array('x': integer(@loc['x']), 'y': integer(@loc['y']), 'z': integer(@loc['z']), 'world': @loc['world']));
}

proc _ncwe_clear_pos(@player){
    export('ncwe.pos1.'.@player, null);
    export('ncwe.pos2.'.@player, null);
}

proc _ncwe_get_sel_total(@player){
    @pos1 = _ncwe_get_pos1(@player);
    @pos2 = _ncwe_get_pos2(@player);

    if(is_null(@pos1) || is_null(@pos2)){
        return(null);
    }

    @xv = abs(@pos1['x'] - @pos2['x']) + 1;
    @yv = abs(@pos1['y'] - @pos2['y']) + 1;
    @zv = abs(@pos1['z'] - @pos2['z']) + 1;

    return(integer(@xv * @yv * @zv));
}
