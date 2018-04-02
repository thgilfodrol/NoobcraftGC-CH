include('procs.ms');
bind('block_break', array('priority': 'monitor'), null, @event,
    @ores = associative_array(
        '129': associative_array(
            'name': 'emerald',
            'color': '&a',
        ),
        '56': associative_array(
            'name': 'diamond',
            'color': '&b',
        ),
        '15': associative_array(
            'name': 'iron',
            'color': '&7',
        ),
    );

@start = time();

    @ores = _ncanticheat_get_ores();

    # player is in survival, and the block broken is an ore that we track
        if(pmode(@event['player']) == 'SURVIVAL' && array_index_exists(@ores, string(@event['block']['type']))){
        @counter = 0;
        @matches = array();
        @eventblock = associative_array( # prevent duplicates in final array where you have two of this array, with integer keys and without
            'x': @event['location']['x'],
            'y': @event['location']['y'],
            'z': @event['location']['z'],
            'world': @event['location']['world'],
        );
        @matches[] = @eventblock;
        @storagekey = 'ncanticheat.oredetect.blocks';
        @tracked = import(@storagekey, array()); # store the previously tracked ore blocks

        if(array_contains(@tracked, @eventblock)){ # if mined block was already tracked
            # stop tracking the block, as we assume player was successful in mining it
            array_remove_values(@tracked, @eventblock);
            export(@storagekey, @tracked); # update tracked block list
            # exit
            return();
        }

        do{
            @surrounding = array();
            @newadditions = 0;

            # iterate over the list of connected ores we found from the previous loop
            foreach(@match in @matches){
                @surrounding = array_merge(@surrounding, _ncanticheat_get_surrounding_blocks(@match)); # push a list of matching surrounding blocks, inc. duplicates
            }

            # iterate over surrounding blocks
            foreach(@block in @surrounding){
                if(!array_contains(@matches, @block) && !array_contains(@tracked, @block)){ # this block wasn't checked before
                    @matches[] = @block; # push to matches
                    @newadditions += 1;
                }
            }

            @counter += 1;
        } while(@counter < 4 && @newadditions != 0);

        @tracked = array_merge(@tracked, @matches); # push new matched blocks to tracked block list
        array_remove_values(@tracked, @eventblock); # stop tracking the block the player just broke
        export(@storagekey, @tracked); # update tracked block list

        @quantity = string(array_size(@matches));
        if(@counter == 4){ # max loop count was reached
            # there may be more ores we didn't record
            @quantity .= '+';
        }
        @ore = @ores[string(@event['block']['type'])];
        @ploc = array_normalize(ploc(@event['player']))[0..3];
        @ploc[1] += 1; # why the hell is ploc returning a block below the player
        broadcast(concat(colorize('&c[!] '.@ore['color']), @event['player'], ' found ', @quantity, ' ', @ore['name'], ' ore (light: ', get_light_at(@ploc), ').'), 'herochat.speak.staff');

#           broadcast((colorize('&c[!] ').@event['player'].' mined '.@ore.'.'), 'herochat.speak.staff');

#broadcast('Took '.subtract(time(), @start).'ms');
        }
)

bind('block_place', array('priority': 'monitor'), null, @event,
    @ores = _ncanticheat_get_ores();
    @storagekey = 'ncanticheat.oredetect.blocks';
    @tracked = import(@storagekey, array()); # retrieve the previously tracked ore blocks

    @eventblock = associative_array(
        'x': @event['location']['x'],
        'y': @event['location']['y'],
        'z': @event['location']['z'],
        'world': @event['location']['world'],
    );

    if(pmode(@event['player']) == 'CREATIVE'){ # ignore blocks placed by creative mode people
        return();
    }

    # check if we track the block type that was placed
    if(array_index_exists(@ores, string(@event['type']))){
        # add to tracked blocks list
        @tracked[] = @eventblock;
        export(@storagekey, @tracked); # update tracked blocks list
    }
)
