include('procs.ms');
include('../nctitle/procs.ms');

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
# returns associative array of tellraw compatible json arrays, named 'expanded' and 'minimal'
# @player: the player's name
# @pchannel: the player's channel
# @pchat: the player's chat message
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

    @namedata = _ncchat_previous_name(puuid(@player));
    if(is_null(@namedata)){ # cache is being updated
        @namehistorytip = concat(colorize('&a'), @player, colorize('&f\'s name cache is currently being updated.'));
    } else if(@namedata['name'] == @player){
        # player's previous and current name is an exact match
        @namehistorytip = concat(colorize('&a'), @player, colorize(' &fhas never changed their name.'));
    } else{
        if(@namedata['changedToAt'] == 0){ # original name
            # "CURRENT_NAME was previously only known as PREVIOUS_NAME until DATE."
            @namehistorytip = concat(colorize('&a'), @player, colorize(' &fwas previously only known as &b'),
                @namedata['name'], colorize('&f until &6'), simple_date('yyyy/MM/dd z', @namedata['changedToAt']), colorize('&f.')
            );
        } else{
            # "CURRENT_NAME was previously known as PREVIOUS_NAME until DATE."
            @namehistorytip = concat(colorize('&a'), @player, colorize(' &fwas previously known as &b'),
                @namedata['name'], colorize('&f until &6'), simple_date('yyyy/MM/dd z', @namedata['changedToAt']), colorize('&f.')
            );
        }
    }

    # Veteran tooltip
    if(has_permission(@player, 'group.veteran')){

    }

    @displayname = display_name(@player);

    ### chat headers ###
    # server tag component
    @servercomp = associative_array('text': colorize('&7{&2S&7} '));
    # channel tag component
    @channelcomp = associative_array(
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

    ### prefix, name, suffix ###
    # prefix component
    @prefixcomp = associative_array('text': colorize(@prefix));
    # suffix component
    @suffixcomp = associative_array('text': colorize(@suffix));
    # name component
    @namecomp = associative_array(
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

    # Process @pchat (e.g. render urls)
    @processed = _ncchat_process_chat(@pchat);

    ### message body ###
    # remember to sanitize @pchat!
    @messagecomp = associative_array('text': ': ', 'color': @chatcolor, 'extra': @processed);

    # construct expanded chat string
    @expanded = array();
    @expanded[] = @servercomp;
    @expanded[] = @channelcomp;
    @expanded[] = @prefixcomp;
    @expanded[] = @namecomp;
    @expanded[] = @suffixcomp;
    @expanded[] = @messagecomp;

    # construct minimal chat string
    @minimal = array();
    @minimal[] = @servercomp;
    @minimal[] = @channelcomp;
    @minimal[] = @namecomp;
    @minimal[] = @messagecomp;

    return(associative_array('expanded': json_encode(@expanded), 'minimal': json_encode(@minimal)));
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

        # Check if url starts with http:// or https://
        if(length(@urls[@i]) >= 11){ # 11 chars is shortest possible url, http://a.tk
            # Check if first 7 or 8 chars is not http:// or https://, respectively
            if(substr(@urls[@i], 0, 7) != 'http://' && substr(@urls[@i], 0, 8) != 'https://'){
                # Prepend http header by default
                @urls[@i] = concat('http://', @urls[@i]);
            }
            # else there is already a header
        } else{ # no protocol header, assume missing
            @urls[@i] = concat('http://', @urls[@i]); # prepend http header
        }

        @components[] = associative_array('text': @text[@i]);
        @components[] = associative_array(
            'text': concat(color('WHITE'), @urltext),
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

    ### DEBUG ###
    #tmsg('ThgilFoDrol', 'with colour: '.colorize(@pchat));
    #tmsg('ThgilFoDrol', 'without colour: '.@pchat);

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

# Given player uuid, returns the player's previous name from memory (if stored)
# Returns array containing their current name if they've never changed it, or null if the cache is being updated
# Array keys:
# name: previous name
# changedToAt: when they changed to their current one (0 if original)
proc _ncchat_previous_name(@puuid){
    @key = concat('ncchat.lastknownname.', @puuid);
    @name = import(@key, null);

    # Mojang uses UUIDs without dashes
    @puuid = replace(@puuid, '-', '');

    if(@name == null){
#        @name = plast_known_name(@puuid);
        http_request('https://api.mojang.com/user/profiles/'.@puuid.'/names', closure(@response){
            if(@response['responseCode'] == 200){ # http ok
                @body = json_decode(@response['body']);
                @bodysize = array_size(@body);

                if(@bodysize == 1){ # name hasn't been changed before
                    # Set their current name in the cache
                    export(@key, associative_array('name': @body[0]['name'], 'changedToAt': 0));
                    # Don't return here, as we want to avoid concurrency issues
                } else if(@bodysize > 1){ # name has been changed before
                    # Set their current name in the cache
                    # the -2nd element is the second element from the right
                    # we use the -1st element for changedToAt because that's the time they *stopped* using their previous name
                    export(@key, associative_array('name': @body[-2]['name'], 'changedToAt': @body[-1]['changedToAt']));

                    # Since the -2nd element may be the original username (i.e. @body[-2] == @body[0])
                    # we check if the array contains a changedToAt value first
#                    if(array_size(@body[-2]) == 2){
#                        export(@key, associative_array('name': @body[-2]['name'], 'changedToAt': @body[-2]['changedToAt']));
#                    }
                } else{ # 0 elements, should never happen
                    throw('NotFoundException',
                        concat('The Mojang API returned a 0 element json object when retrieving the previous name for ', @puuid)
                    );
                }
            } else{
                console(concat('An error occurred when checking the previous name for ', @puuid));
                console(concat('Mojang\'s servers responded with: ', @response));
                throw('BadEntityException', 'The Mojang API did not return 200.');
            }
        });
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
