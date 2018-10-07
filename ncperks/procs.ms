# add a prefix or suffix to player
# type can be either 'prefix' or 'suffix'
proc _ncperks_set_meta(@player, @type, @input, @priority){
    # remove double quotes from input
    @input = replace(@input, '"', '');

    if(@type == 'prefix'){
        @format = concat('&8[', @input, '&8]&r ');
    } else if(@type == 'suffix'){
        @format = concat(' &8[', @input, '&8]&r');
    } else{
        throw('NotFoundException', 'Expecting type \'prefix\' or \'suffix\', but found \''.@type.'\' instead.');
    }

    runas('~console', '/lp user '.@player.' meta remove'.@type.' '.@priority);
    runas('~console', '/lp user '.@player.' meta add'.@type.' '.@priority.' "'.@format.'"');

    return(@format);
}
