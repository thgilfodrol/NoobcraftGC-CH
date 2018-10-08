include('procs.ms')

register_command('nctitle', array(
    'description': 'Manage your titles (chat prefixes).',
    'usage': colorize('&cUsage: /nctitle help'),
    'permission': 'nc.title.list',
    'noPermMsg': colorize('&cInsufficient permissions (you should have this, but you don\'t. try reporting it to staff?)'),
    'tabcompleter': closure(@alias, @sender, @args) {
        @numargs = array_size(@args);
        @search = @args[@numargs - 1];

        if(@numargs == 1) {
            @options = array('list', 'set', 'clear', 'info', 'help');
        } else if(@numargs == 2){
            if((@args[0] == 'set') || (@args[0] == 'info')){
                @options = array_keys(_nctitle_get_titles());
            } else if(@args[0] == 'list'){
                @options = array('special', 'donor', 'default', 'all');
            }
        } else{
            return(array());
        }

        return(array_filter(@options, closure(@index, @option) {
            return(equals_ic(@search, substr(@option, 0, length(@search))));
        }));
    },
    'executor': closure(@alias, @sender, @args) {
        @numargs = array_size(@args);

        # show the help menu if there are no args or if the 1 arg given is "help"
        if(@numargs == 0 || ((@numargs == 1 ) && (to_lower(@args[0]) == 'help'))){
            msg(colorize('&6NC Titles >> &7Help Menu'));
            msg(colorize('&b/nctitle &flist&7 - display a list of titles.'));
            msg(colorize('&b/nctitle &fset <title>&7 - set your title to one from the list.'));
            msg(colorize('&b/nctitle &fclear&7 - clear your current title.'));
            msg(colorize('&b/nctitle &finfo <title>&7 - display information about a title.'));
            msg(colorize('&b/nctitle &fhelp&7 - show this message.'));

            return(true);
        } else{
            @p = player();
            @titles = _nctitle_get_titles();

            switch(to_lower(@args[0])){
                case 'list':
                    if(@numargs === 2){
                        @cat = to_lower(@args[1]);
                        if(!(@cat == 'special' || @cat == 'donor' || @cat == 'default' || @cat == 'all')){
                            msg(colorize('&6NC Titles >> &cInvalid category "'.@args[1].'".'));
                            msg(colorize('&f<category>&7 can be either &fspecial&7, &fdonor&7, &fdefault&7, or &fall&7.'));
                            return(true);
                        }
                    } else{
                        msg(colorize('&6NC Titles >> &7Usage: &b/nctitle &flist <category>'));
                        msg(colorize('&f<category>&7 can be either &fspecial&7, &fdonor&7, &fdefault&7, or &fall&7.'));

                        return(true);
                    }

                    @owned = '';
                    @special = '';
                    @donor = '';

                    msg(colorize('&6NC Titles >>&7 Title List'));
                    foreach(@title:@data in @titles){
                        # determine if we need to display this one
                        if(@cat != 'all'){
                            # if the category requested isn't special or all, but the title is special
                            if((@cat != 'special') && @data['special']){
                                # skip this title
                                continue();
                            # req cat isn't donor or all but title is donor
                            } else if((@cat != 'donor') && @data['donor']){
                                # skip this title
                                continue();
                            # req cat isn't default or all, but title is default
                            } else if((@cat != 'default') && (!@data['donor'] && !@data['special'])){
                                # skip this title
                                continue();
                            }
                        }

                        # apply category tags
                        if(is_null(@data['permnode']) || has_permission(@data['permnode'])){
                            @owned = ' &2{owned}';
                        }
                        if(@data['special']){
                            @special = ' &c{special}';
                        }
                        if(@data['donor']){
                            @donor = ' &5{donor}';
                        }

                        msg(colorize(' &8[&7> '._nctitle_format_title(@p, @title).@special.@donor.@owned));

                        @owned = '';
                        @special = '';
                        @donor = '';
                    }

                    return(true);
                case 'set':
                    if(@numargs === 2){
                        @title = to_lower(@args[1]);

                        if(_nctitle_title_exists(@title)){
                            if(is_null(@titles[@title]['permnode']) || has_permission(@titles[@title]['permnode'])){
                                @prefix = _nctitle_format_title(@p, @title);
                                runas('~console', '/lp user '.@p.' meta removeprefix 20');
                                runas('~console', '/lp user '.@p.' meta addprefix 20 "'.@prefix.'"');
                                msg(colorize('&6NC Titles >> &7Your title has been set to '.substr(@prefix, 0, length(@prefix) - 3).'&7.'));
                            } else{
                                msg(colorize('&6NC Titles >> &cYou have not unlocked this title yet.'));
                            }
                        } else{
                            msg(colorize('&6NC Titles >> &cThe title &b'.@title.'&c does not exist.'));
                        }
                    } else{
                        msg(colorize('&6NC Titles >> &cUsage: &f/nctitle &bset <title>'));
                    }

                    return(true);
                case 'remove':
                case 'unset':
                case 'delete':
                case 'clear':
                    runas('~console', '/lp user '.@p.' meta removeprefix 20');
                    msg(colorize('&6NC Titles >> &7Your title has been cleared.'));
                case 'info':
                    @title = to_lower(@args[1]);

                    if(@numargs === 2){
                        if(_nctitle_title_exists(@title)){
                            msg(colorize('&6NC Titles >> &7The title &b'.@title.'&7 '.@titles[@title]['info'].'.'));
                        } else{
                            msg(colorize('&6NC Titles >> &cThe title &b'.@title.'&c does not exist.'));
                        }
                    } else{
                        msg(colorize('&6NC Titles >> &cUsage: &f/nctitle &binfo <title>'));
                    }

                    return(true);
                default:
                    return(false);
            }
        }

    }
));
