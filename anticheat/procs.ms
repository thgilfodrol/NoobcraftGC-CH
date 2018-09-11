# Given a keyed loc array, return an array of surrounding blocks with the same id as keyed loc arrays
proc _ncanticheat_get_surrounding_blocks(@locarray){
    @givenblockid = get_block(@locarray);
    @surrounding = array();

    for(@x = @locarray['x'] - 1, @x <= @locarray['x'] + 1, @x++){
        for(@y = @locarray['y'] - 1, @y <= @locarray['y'] + 1, @y++){
            for(@z = @locarray['z'] - 1, @z <= @locarray['z'] + 1, @z++){
                @candidateblock = associative_array(
                    'x': @x,
                    'y': @y,
                    'z': @z,
                    'world': @locarray['world'];
                );

                # check if candidate block id matches block id of given block
                if(@givenblockid == get_block(@candidateblock)){
                    # matches, so we add to array
                    @surrounding[] = @candidateblock;
                }
            }
        }
    }

    return(@surrounding);
}

# Return array mapping ore ids to names
proc _ncanticheat_get_ores(){
    @ores = associative_array(
        'EMERALD_ORE': associative_array(
            'name': 'emerald',
            'color': '&a',
        ),
        'DIAMOND_ORE': associative_array(
            'name': 'diamond',
            'color': '&b',
        ),
        'IRON_ORE': associative_array(
            'name': 'iron',
            'color': '&7',
        ),
        'GOLD_ORE': associative_array(
            'name': 'gold',
            'color': '&e',
        ),
    );

    return(@ores);
}
