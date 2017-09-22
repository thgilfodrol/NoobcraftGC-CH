register_command('announcer', array(
    'description': 'Helper command for the server announcer.',
    'usage': 'Usage: /announcer help',
    'permission': 'nc.announcer',
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
    'aliases': array('acc'),
    'executor': closure(@alias, @sender, @args) {
        @helpmenu = colorize('&dNC Announcer >> &7Help Menu\n'.
            '&b/announcer &rhide <category> &7- hide all announcements from a specific category until next restart.\n'.
            '&b/announcer &rshow <category> &7- show all announcements from a specific category again.\n'.
            '&b/announcer &radmin <args> &7- admin commands.\n'.
            '&b/announcer &rhelp &7- show this message.');

        if(array_size(@args) == 0){
            msg(@helpmenu);
            return(true)
        } else{
            @args = array_map(@args, closure(@value){
                return(to_lower(@value));
            });

            switch(@args[0]){
                case 'hide':
                    msg(colorize('&cNot implemented.'));
                case 'show':
                    msg(colorize('&cNot implemented.'));
                case 'admin':
                    msg(colorize('&cNot implemented.'));
                case 'help':
                    msg(colorize('&cNot implemented.'));
                default:
                    msg(colorize('&cInvalid arguments.'));
                    msg(@helpmenu);
                    return(true);
            }
        }

        return(false);
    }
));
