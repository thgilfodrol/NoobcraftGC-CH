proc _ncchat_get_channels(){
    @channels = associative_array();
    @channels['Global'] = associative_array(
	    'color': '&7', # default text color
    	'nick': 'G',
	    'perm': 'herochat.speak.global',
    	'default': true); # if players are subscribed automatically
    @channels['Staff'] = associative_array(
        'color': '&a', # default text color
        'nick': 'S',
	    'perm': 'herochat.speak.staff',
        'default': true); # if players are subscribed automatically
    @channels['Local'] = associative_array(
        'color': '&e', # default text color
        'nick': 'L',
    	'perm': 'herochat.speak.local',
        'default': true); # if players are subscribed automatically
    @channels['Upsidedown'] = associative_array(
        'color': '&b', # default text color
        'nick': 'U',
    	'perm': 'herochat.speak.aharter',
        'default': true); # if players are subscribed automatically
    @channels['Admin'] = associative_array(
        'color': '&c', # default text color
        'nick': 'A',
        'perm': 'herochat.speak.admin',
        'default': true); # if players are subscribed automatically

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

    if(!(array_contains(array_keys(@channels), @pchannel))){
        throw('NotFoundException', 'Player\'s channel '.@pchannel.' did not match a known channel name.');
    }

    @col = @channels[@pchannel]['color'];
    @nick = @channels[@pchannel]['nick'];

	return(colorize('&7{&2S&7} '.@col.'['.@nick.'] &f'.@prefix.'%1$s'.@suffix.@col.': %2$s'));

    # return('<%1$s> %2$s'); # default format
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

# Given a permission, returns an array of online players who have that permission
proc _ncchat_get_players_with_permission(@perm){
    @all_players = all_players();

    @recipients = array_filter(@all_players, closure(@index, @recipient){
        return(has_permission(@recipient, @perm));
    });

    return(@recipients);
}

# Given a NCChat text (not JSON) message object, creates a literal chat message
# the message object is composed of:
# server: header for origin server (e.g. {S} for main, {D} for discord, etc)
# channel: channel long name, e.g. "Global"
# player name: full player name
# message: the message to send
# recipients: array of player names
# literal: whether or not to return an event format string
#proc _ncchat_generate_message(@msgobj){
#    return(false);
#}
