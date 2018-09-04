include('procs.ms');

# helper command for nc emote system
register_command('ncemote', array(
    'description': 'Helper command for the Noobcraft emote system',
    'usage': '/ncemote [arguments]',
    'permission': 'nc.emotes.ncemote',
    'noPermMsg': colorize('&cYou do not have permission to use this command.'),
    'tabcompleter': closure(@alias, @sender, @args) {
        @subcommands = array('list', 'info', 'help');

        if(array_size(@args) == 1){
            @search = @args[array_size(@args) - 1];
            return(array_filter(@subcommands, closure(@index, @subcommand) {
                return(equals_ic(@search, substr(@subcommand, 0, length(@search))));
            }));
        }
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
                    @pagenumber = 1;
                    if(array_size(@args) < 3){ # no more than 2 arguments
                        if(array_size(@args) == 2){ # page number is given
                            @pagenumber = @args[1];
                        }

                        if(!is_integral(@pagenumber) || @pagenumber <= 0){ # page number is not int or is negative
                            msg(colorize('&cPage number must be a non-zero positive integer.'));
                            msg(colorize('&6Correct usage: &b/ncemote &flist [page]&7 - display a list of emotes.'));
                            return(true);
                        }
                    } else{ # too many arguments
                        msg(colorize('&cInvalid number of arguments.'));
                        msg(colorize('&6Correct usage: &b/ncemote &flist [page]&7 - display a list of emotes.'));
                        return(true);
                    }

                    @entriesperpage = 10;
                    @emotes = array_keys(_ncemotes_get_emotes());
                    @numberofemotes = array_size(@emotes);

                    msg(colorize('&6NC Emotes >> &7Emote List (Page '.@pagenumber.'/'.(ceil(@numberofemotes / @entriesperpage)).')'));
                    for(@i = @pagenumber * @entriesperpage - @entriesperpage, @i < @pagenumber * @entriesperpage && @i < @numberofemotes, @i++){
                        msg(colorize(' &8[&7>&a '.@emotes[@i]));
                    }
                    if(@pagenumber < ceil(@numberofemotes / @entriesperpage)){ # more pages exist
                        msg(colorize('&7You can view the next page with &b/ncemote &flist '.(@pagenumber + 1).'&7.'));
                    }

                    return(true);
                case 'info':
                    msg(colorize('&cnot implemented. might not be implemented. pending extra thought.'));
                    msg(colorize('&cyours truly,'));
                    msg(colorize('-thiggypudding'));
                    return(true);
                case 'help':
                    execute(@helpmenu);
                    return(true);
                default:
                    msg(colorize('&cInvalid arguments.'));
                    execute(@helpmenu);
                    return(true);
            }
        }
    }
));
