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
        @helpmenu = closure(){
            msg(colorize('&6NC Emotes >> &7Help Menu'));
            msg(colorize('&b/ncemote &flist [page]&7 - display a list of emotes.'));
            msg(colorize('&b/ncemote &finfo <emote>&7 - display information about an emote.'));
            msg(colorize('&b/ncemote &fhelp&7 - show this message.'));
        }

        if(array_size(@args) == 0){
            execute(@helpmenu);
            return(true);
        } else{
            @args = array_map(@args, closure(@value){
                return(to_lower(@value));
            });

            switch(@args[0]){
                case 'list':
                    return(true);
                case 'info':
                    return(true);
                case 'help':
                    return(true);
                default:
                    return(false);
            }
        }
    }
));
