include('procs.ms');
include('../nctitle/procs.ms');

register_command('ncperks', array(
    'description': 'Manage your donor perks.',
    'usage': colorize('&cUsage: /ncperks help'),
    'permission': 'nc.title.donor1',
    'noPermMsg': colorize('&cInsufficient permissions. You must be at least a tier 1 donor to use this command.'),
    'tabcompleter': closure(@alias, @sender, @args) {
        @numargs = array_size(@args);
        @search = @args[@numargs - 1];

        if(@numargs == 1) {
            @options = array('list', 'set', 'clear', 'info', 'help');
        } else if((@numargs == 2) && ((@args[0] == 'set') || (@args[0] == 'info'))){
            @options = array_keys(_nctitle_get_titles());
        } else{
            return(array());
        }
    },
    'executor': closure(@alias, @sender, @args) {
        # prevent console or cmd blocks from using this
        if(!ponline(@sender)){
            return(true);
        }

        @numargs = array_size(@args);
        # if there are no arguments or help is the first and only argument
        if(@numargs == 0 || ((@numargs == 1 ) && (to_lower(@args[0]) == 'help'))){
            msg(colorize('&6NC Perks >> &7Help Menu'));
            msg(colorize('&b/ncperks &fprefix <set|unset>&7 - set/unset your custom prefix.'));
            msg(colorize('&b/ncperks &fsuffix <set|unset>&7 - set/unset your custom suffix.'));
            msg(colorize('&b/ncperks &fhelp&7 - show this message.'));

            return(true);
        }

        if(@numargs >= 1){
            switch(to_lower(@args[0])){
                case 'prefix':
                    if(!has_permission(@sender, 'nc.perks.prefix.custom')){
                        msg(colorize('&6NC Perks >>&c Insufficient permissions. You must be at least a tier 4 donor to use this command.'));
                        return(true);
                    }

                    if(@numargs >= 2){
                        if(to_lower(@args[1]) == 'set'){
                            if(@numargs >= 3){
                                # returns the input starting from the 3rd argument (after 'set') to the end, both inclusive
                                @prefix = array_implode(@args[2..-1]);

                                # disallow prefixes longer than 16 chars
                                if(length(@prefix) > 16){
                                    msg(colorize('&6NC Perks >> &7Prefix Config'));
                                    msg(colorize('&cThe prefix is too long- the maximum allowed length is 16 characters.'));
                                    return(true);
                                }

                                @result = _ncperks_set_meta(@sender, 'prefix', @prefix, '20');

                                set_timeout(50, closure(){
                                    msg(colorize('&6NC Perks >> &7Prefix set!'));
                                    @fname = _nctitle_get_formatted_name(@sender);
                                    msg(colorize(concat('&bNew name preview: ', @fname)));
                                });

                                return(true);
                            } else{
                                msg(colorize('&6NC Perks >> &7Prefix set usage'));
                                msg(colorize('&b/ncperks &fprefix set <prefix>&7 - set your custom prefix.'));
                                return(true);
                            }
                        } else if(to_lower(@args[1]) == 'unset'){
                            runas('~console', '/lp user '.@sender.' meta removeprefix 20');

                            set_timeout(50, closure(){
                                msg(colorize('&6NC Perks >> &7Prefix unset!'));
                                @fname = _nctitle_get_formatted_name(@sender);
                                msg(colorize(concat('&bNew name preview: ', @fname)));
                            });

                            return(true);
                        }
                    } else{
                        msg(colorize('&6NC Perks >> &7Prefix Config'));
                        msg(colorize('&b/ncperks &fprefix set <prefix>&7 - set your custom prefix.'));
                        msg(colorize('&b/ncperks &fprefix unset&7 - remove your prefix.'));
                        return(true);
                    }
                case 'suffix':
                    if(!has_permission(@sender, 'nc.perks.suffix.custom')){
                        msg(colorize('&6NC Perks >>&c Insufficient permissions. You must be at least a tier 4 donor to use this command.'));
                        return(true);
                    }

                    if(@numargs >= 2){
                        if(to_lower(@args[1]) == 'set'){
                            if(@numargs >= 3){
                                # returns the input starting from the 3rd argument (after 'set') to the end, both inclusive
                                @suffix = array_implode(@args[2..-1]);

                                # disallow suffixes longer than 20 chars
                                if(length(@suffix) > 20){
                                    msg(colorize('&6NC Perks >> &7Suffix Config'));
                                    msg(colorize('&cThe suffix is too long- the maximum allowed length is 20 characters.'));
                                    return(true);
                                }

                                @result = _ncperks_set_meta(@sender, 'suffix', @suffix, '20');
                                msg(colorize('&6NC Perks >> &7Suffix set!'));

                                set_timeout(50, closure(){
                                    msg(colorize('&6NC Perks >> &7Prefix set!'));
                                    @fname = _nctitle_get_formatted_name(@sender);
                                    msg(colorize(concat('&bNew name preview: ', @fname)));
                                });

                                return(true);
                            } else{
                                msg(colorize('&6NC Perks >> &7Suffix set usage'));
                                msg(colorize('&b/ncperks &fsuffix set <suffix>&7 - set your custom suffix.'));
                                return(true);
                            }
                        } else if(to_lower(@args[1]) == 'unset'){
                            runas('~console', '/lp user '.@sender.' meta removesuffix 20');

                            set_timeout(50, closure(){
                                msg(colorize('&6NC Perks >> &7Prefix set!'));
                                @fname = _nctitle_get_formatted_name(@sender);
                                msg(colorize(concat('&bNew name preview: ', @fname)));
                            });

                            msg(colorize('&6NC Perks >> &7Suffix unset.'));
                            return(true);
                        }
                    } else{
                        msg(colorize('&6NC Perks >> &7Suffix Config'));
                        msg(colorize('&b/ncperks &fsuffix set <suffix>&7 - set your custom suffix.'));
                        msg(colorize('&b/ncperks &fsuffix unset&7 - remove your suffix.'));
                    }
                default:
                    msg(colorize('&6NC Perks >> &7Unrecognized subcommand &f'.@args[0].'&7.'));
                    return(false);
            }
        }

        return(false);
    }
));
