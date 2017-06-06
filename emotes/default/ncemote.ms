# helper command for nc emote system
register_command('ncemote', array(
    'description': 'Helper command for the Noobcraft emote system',
    'usage': '/ncemote [arguments]',
    'permission': 'nc.emotes.ncemote',
    'noPermMsg': colorize('&cYou do not have permission to use this command.'),
    'tabcompleter': closure(@alias, @sender, @args) {
        if(array_size(@args) == 0) {
            return(all_players());
        }
        @search = @args[array_size(@args) - 1];
        return(array_filter(all_players(), closure(@index, @player) {
            return(equals_ic(@search, substr(@player, 0, length(@search))));
        }));
    },
    'aliases': array('ncemotes', 'emotes', 'emote'),
    'executor': closure(@alias, @sender, @args){

    }
));
