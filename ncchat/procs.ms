proc _ncchat_get_channels(){
    @channels = associative_array();
    @channels['Global'] = associative_array(
        'color': '&7', # default text color
        'nick': 'G', # nickname, used in channel tag formatting
        'perm': 'herochat.speak.global', # required to speak in this channel
        'socialspy': false, # if we should get socialspy alerts for this channel
        'range': -1, # range of transmission, negative value means unlimited (i.e. global)
        'default': true, # if players are subscribed automatically
    );
    @channels['Staff'] = associative_array(
        'color': '&a',
        'nick': 'S',
        'perm': 'herochat.speak.staff',
        'socialspy': false,
        'range': -1,
        'default': true,
    );
    @channels['Local'] = associative_array(
        'color': '&e',
        'nick': 'L',
        'perm': 'herochat.speak.local',
        'socialspy': true,
        'range': 200,
        'default': true,
    );
    @channels['Upsidedown'] = associative_array(
        'color': '&b',
        'nick': 'U',
        'perm': 'herochat.speak.aharter',
        'socialspy': false,
        'range': -1,
        'default': true,
    );

    return(@channels);
}

proc _ncchat_player_get_channel(@player){
    @pchannel = import('ncchat'.@player.'channel', 'Global');

    return(@pchannel);
}

proc _ncchat_player_set_channel(@player, @channel){
    export('ncchat'.@player.'channel', @channel);
}

proc _ncchat_format(@player, @pchannel){
    @channels = _ncchat_get_channels();
    @prefix = vault_user_prefix(pworld(@player), @player);
    @suffix = vault_user_suffix(pworld(@player), @player);

    if(@pchannel == 'Global'){
        @col = @channels['Global']['color'];
        @nick = @channels['Global']['nick'];

        return(colorize(@col.'{&2S'.@col.'} ['.@nick.'] &f'.@prefix.'%1$s'.@suffix.@col.': %2$s'));
    } else if(@pchannel == 'Staff'){
        @col = @channels['Staff']['color'];
        @nick = @channels['Staff']['nick'];

        return(colorize(@col.'{&2S'.@col.'} ['.@nick.'] &f'.@prefix.'%1$s'.@suffix.@col.': %2$s'));
    } else if(@pchannel == 'Local'){
        @col = @channels['Local']['color'];
        @nick = @channels['Local']['nick'];

        return(colorize(@col.'{&2S'.@col.'} ['.@nick.'] &f'.@prefix.'%1$s'.@suffix.@col.': %2$s'));
    }

    return('<%1$s> %2$s'); # default format
}

proc _ncchat_format_emote(@player, @pchannel, @action){
    @channels = _ncchat_get_channels();

    @col = @channels[@pchannel]['color'];
    @nick = @channels[@pchannel]['nick'];
    return(colorize(@col.'{&2S'.@col.'} ['.@nick.'] * '.@player.' '.@col).@action);
}

proc _ncchat_player_can_speak_in(@player, @channel){
    @channels = _ncchat_get_channels();
    if(array_index_exists(@channels, @channel)){
        return(has_permission(@player, _ncchat_get_channels()[@channel]['perm']));
    }
    return(null);
}

# Accepts partial name, e.g. G, g, or global and outputs Global. null if no channel exists
proc _ncchat_get_channel_full_name(@partialname){
    @channels = _ncchat_get_channels();

    @channelfullname = null;

    foreach(@channel:@data in @channels){
        if(@partialname == to_lower(@data['nick']) || @partialname == to_lower(@channel)){ # matches channel nick or complete name
            @channelfullname = to_lower(@channel);
            return(concat(to_upper(@channelfullname[0]), @channelfullname[1..]));
        }
    }

    return(@channelfullname);
}
