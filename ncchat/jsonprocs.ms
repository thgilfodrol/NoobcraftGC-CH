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

# Send a tellraw message @args to each player in array @targetarray
# @target: list of players, no default
# @args: json formatted string, no default
proc _ncchat_tellraw_list(@players, @args){
    if(@args == ''){
        throw('NotFoundException',
            'The text JSON array cannot be empty.'
        )
    }

    foreach(@player in @players){
        runas('~console', sconcat('/tellraw', @player, @args));
    }
}

# Given the player @player, a channel @pchannel, and their message @pchat,
# returns a tellraw compatible json array
# @player: the player's name
# @pchannel: the player's channel
# @pchat: the player's chat message
# @minimal: whether or not to format in minimal mode
proc _ncchat_json_format(@player, @pchannel, @pchat, @minimal){
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

    @lastknownname = _ncchat_last_known_name(@player);
    if(@lastknownname == @player){
        @namehistorytip = concat(colorize('&b'), @player, colorize(' &fhas never changed their name.'));
    } else{
        @namehistorytip = concat(colorize('Last known as &b'), @lastknownname);
    }

    @displayname = display_name(@player);

    # server and channel tag
    @body[] = associative_array('text': colorize('&7{&2S&7} '));
    @body[] = associative_array(
        'text': concat(color(@chatcolor), '[', @channels[@pchannel]['nick'], '] '),
        'hoverEvent': associative_array(
            'action': 'show_text',
            'value': @pchannel,
        ),
        'clickEvent': associative_array(
            'action': 'suggest_command',
            'value': concat('/', to_lower(@channels[@pchannel]['nick']), ' '),
        ),
    );

    # name formatting
    if(@minimal){ # formatting in minimal mode
        # name
        @body[] = associative_array(
            'text': colorize(concat(_nctitle_get_rank_color(@player), @displayname)),
            'hoverEvent': associative_array(
                'action': 'show_text',
                # prefix, name, suffix hovertext
                'value': colorize(concat(@prefix, @displayname, @suffix, '\n', @namehistorytip)),
            ),
            'clickEvent': associative_array(
                'action': 'suggest_command',
                'value': concat('/msg ', @player, ' '),
            ),
        );
    } else{ # not formatting in minimal mode
        # prefix, name, suffix
        @body[] = associative_array('text': colorize(@prefix));
        @body[] = associative_array(
            'text': colorize(concat(_nctitle_get_rank_color(@player), @displayname)),
            'hoverEvent': associative_array(
                'action': 'show_text',
                'value': @namehistorytip,
            ),
            'clickEvent': associative_array(
                'action': 'suggest_command',
                'value': concat('/msg ', @player, ' '),
            ),
        );
        @body[] = associative_array('text': colorize(@suffix));
    }

    # Process @pchat (e.g. render urls)
    @processed = _ncchat_process_chat(@pchat);

    # message body
    # remember to sanitize @pchat!
    @body[] = associative_array('text': ': ', 'color': @chatcolor, 'extra': @processed);

    return(json_encode(@body));
}

# Given a player's chat message, process it to properly display URLs
# Returns json array of text components
proc _ncchat_process_chat(@pchat){
    # source: https://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
    @urlpattern = '(https?:\\/\\/?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?)';
    # source: https://stackoverflow.com/a/3809435
    @urlpattern3 = '(http(s)?:\\/\\/.)?(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&\\/\\/=]*)';

    @processed = array();

    @matches = reg_match_all(@urlpattern3, @pchat);

    # No urls in given chat
    if(array_size(@matches) === 0){
        # Send the chat back unprocessed; nothing to be done here
        @processed[] = associative_array('text': @pchat);
        return(@processed);
    }

    # Collect matched urls into an array
    @urls = array();
    array_iterate(@matches, closure(@key, @value){
        # Match found
        if(array_size(@value) !== 0){
            # Add to url array
            @urls[] = @value[0]
        }
    });

    @components = array();
    # Split text on urls so we have the text that was between each url
    @text = reg_split(@urlpattern3, @pchat);

    # Size of @urls should always be 1 less than @text
    @numurls = array_size(@urls);
    @numtext = array_size(@text);

    # Reconstruct chat
    for(@i = 0, @i < (@numtext - 1), @i++){
        # Shorten url size if over 36 chars long
        if(length(@urls[@i]) > 36){
            # Display a 24 char preview
            @urltext = concat(substr(@urls[@i], 0, 24), '...');
        } else{
            @urltext = @urls[@i]; # just display the original url
        }

        @components[] = associative_array('text': @text[@i]);
        @components[] = associative_array(
            'text': concat(color('AQUA'), @urltext),
            'clickEvent': associative_array(
                'action': 'open_url',
                'value': @urls[@i],
            ),
            'hoverEvent': associative_array(
                'action': 'show_text',
                'value': concat(color('AQUA'), @urls[@i]),
            ),
        );
    }
    @components[] = associative_array('text': @text[@numtext - 1]); # append final text chunk

    return(@components);
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

# Returns the player's last known name from memory (if stored), otherwise falls back to plast_known_name()
proc _ncchat_last_known_name(@player){
    @key = concat('ncchat.lastknownname.', @player);
    @name = import(@key, null);

    if(@name == null){
        @name = plast_known_name(@player);
        export(@key, @name);
    }

    return(@name);
}

# Sets minimal mode for @player
# Returns the value minimal mode was changed to
proc _ncchat_player_set_minimal_mode(@player, @value){
    @key = concat('ncchat.minimal.', @player);

    export(@key, @value);
    return(@value);
}

# Gets minimal mode setting for @player
# Returns the setting they have for minimal mode
proc _ncchat_player_get_minimal_mode(@player){
    @key = concat('ncchat.minimal.', @player);
    @value = import(@key, false);

    return(@value);
}

# Sets the player's NCC nickname
proc _ncchat_player_set_nickname(@player, @nickname){
    @key = concat('ncchat.nicknames.', @player);
    # Store in cache
    export(@key, @nickname);
    # Write to persistence
    x_new_thread(time(), closure(){
        store_value(@key, @nickname);
    });

    return();
}

# Given player name @player, returns their NCC nickname
# If there was no cached nickname found, return player name @player
proc _ncchat_player_get_nickname(@player){
    @key = concat('ncchat.nicknames.', @player);
    # Retrieve from cache
    @value = import(@key, @player);

    return(@value);
}
