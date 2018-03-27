include('procs.ms');
include('../names/procs.ms');

# Send a tellraw message @args to @target
# @target: target selector, defaults to @a
# @args: json formatted string, no default
proc _ncchat_tellraw(@target, @args){
    # Default to sending to everyone
    if(@target == ''){
        @target = '@a';
    }

    if(@args == ''){
	    throw('NotFoundException',
            'The text JSON array cannot be empty.'
        )
    }

    runas('~console', sconcat('/tellraw', @target, @args));
}

# Given the player @player, a channel @pchannel, and their message @pchat,
# returns a tellraw compatible json array
# @player: the player's name
# @pchannel: the player's channel
proc _ncchat_json_format(@player, @pchannel, @pchat){
    @channels = _ncchat_get_channels();
    @prefix = vault_user_prefix(pworld(@player), @player);
    @suffix = vault_user_suffix(pworld(@player), @player);

    # Given channel @pchannel does not exist
    if(!array_index_exists(@channels, @pchannel)){
        throw('NotFoundException', 
            concat('The channel \"', @pchannel, '" does not exist.')
        );
    }

    @chatcolor = _ncchat_mc_to_json_color(@channels[@pchannel]['color']);

    @body = array();

    # server and channel tag
    @body[] = associative_array('text': colorize('&7{&2S&7} '));
    @body[] = associative_array('text': concat(color(@chatcolor), '[', @channels[@pchannel]['nick'], '] '));

    # name
    @body[] = associative_array('text': colorize(@prefix));
    @body[] = associative_array('text': colorize(concat(_nctitle_get_rank_color(@player), @player)));
    @body[] = associative_array('text': colorize(@suffix));

    # message body
    # remember to sanitize @pchat!
    @body[] = associative_array('text': concat(': ', @pchat), 'color': @chatcolor);

    return(json_encode(@body));
}

# Given a minecraft colour code, return the corresponding json colour
proc _ncchat_mc_to_json_color(@mc){
    @data = associative_array(
        '&1': 'dark_blue',
        '&2': 'dark_green',
        '&3': 'dark_aqua',
        '&4': 'dark_red',
        '&5': 'dark_purple',
        '&6': 'gold',
        '&7': 'gray',
        '&8': 'dark_gray',
        '&9': 'blue',
        '&a': 'green',
        '&b': 'aqua',
        '&c': 'red',
        '&d': 'light_purple',
        '&e': 'yellow',
        '&f': 'white',
        '&k': 'obfuscated',
        '&l': 'bold',
        '&m': 'strikethrough',
        '&n': 'underline',
        '&o': 'italic'
    );

    # Check if the given colour code is valid
    if(array_index_exists(@data, @mc)){
        return(@data[@mc]);
    } else{
        throw('NotFoundException',
            concat('The given color/formatting code,', @mc, ', is not a recognized code.')
        );
    }
}

# Given a json colour, return the corresponding minecraft colour code
proc _ncchat_json_to_mc_color(@json){
    throw('Exception', 'This is not yet implemented.');
}
