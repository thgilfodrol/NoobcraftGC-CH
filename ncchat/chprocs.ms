include('procs.ms');

# Generate (but NOT send) a message given a player and message
# @p: String player
# @msg: String chat message
#
proc _ncchat_generate_message(@p){
    @ch = _ncchat_get_channels();
    @pch = _ncchat_player_get_channel(@p);
    @allp = all_players();
    @result = associative_array();

    # player's current channel doesn't match any known channel
    if(!(array_contains(array_keys(@ch), @pch))){
        throw('NotFoundException', 'Player\'s current channel does not match a known channel name.');
    }

    @format = _ncchat_format(@p, @pch);
    @recipients = array_map(@allp, closure(@recipient){
        if(has_permission(@recipient, @ch[@pch]['perm'])){
            return(@recipient);
        }
        return();
    });

    @result['recipients'] = @recipients;
    @result['format'] = @format;

    return(@result);
}
