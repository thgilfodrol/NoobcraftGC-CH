bind('discord_message_received', array('priority': 'highest'), array('channel': 'server'), @event,
    @cmd_trigger = '>>';
    @args = parse_args(@event['message']);
    @trigger = substr(@args[0], 0, 2);
    @cmd = substr(@args[0], 2);

    if(length(@args[0]) > 2 && @trigger == @cmd_trigger){
        switch(@cmd){
            # this command displays a count and list of all non-opped players
            case 'list':
                @players = all_players();
                @non_op_players = array_filter(@players, closure(@key, @value){
                    return(!pisop(@value));
                });
                @num_non_op_players = array_size(@non_op_players);

                discord_broadcast('server', concat('There are ', @num_non_op_players, ' players online:\n'));
                discord_broadcast('server', array_implode(@non_op_players, ', '));

                consume();
                break();
            default:
                discord_broadcast('server', concat(
                    'Sorry ', @event['nickname'], ', but "', @args[0], '" is not a valid command.'
                ));
        }
    }
)
