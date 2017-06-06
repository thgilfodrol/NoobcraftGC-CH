include('/home/mcma3ncmain/testservers/ncmainclone_2016-12-15/plugins/CommandHelper/LocalPackages/emotes/default/procs.ms');

@emotes = _ncemotes_get_emotes();
# iterate over list of emotes to register each as an actual command using metadata
foreach(@emote:@metadata in @emotes){ # @emote is the name/command of emote
    register_command(@emote, associative_array(
        'description': 'Part of the standard set of emotes.',
        'usage': '/'.@emote.' [optional text]',
        'permission': @metadata['permnode'],
        'noPermMsg': colorize('&cYou do not have permission to use this emote.'),
        'tabcompleter': closure(@alias, @sender, @args){
            if(array_size(@args) == 0) {
                return(all_players());
            }
            @search = @args[array_size(@args) - 1];
            return(array_filter(all_players(), closure(@index, @player) {
                return(equals_ic(@search, substr(@player, 0, length(@search))));
            }));
        },
        'aliases': '',
        'executor': closure(@alias, @sender, @args){
            # cooldown check
            @cooldownkey = @sender.'.emote';
            @lastused = import(@cooldownkey, 0);
            @resettime = @lastused + 3; # 3 sec cd
            @currenttime = time() / 1000;

            if(@resettime <= @currenttime){ # off cooldown
                export(@cooldownkey, time() / 1000);

                @details = array_implode(@args);
                if(length(@details) != 0){
                    # pad details with a leading space, if they exist (fixes issue that caused issues with mycmd impl)
                    @details = ' '.@details;
                }

                broadcast(colorize('&a'.@sender.' '.@metadata['format'].@details.'.'));
            } else{
                msg(colorize('&cYou must wait '.ceil(@resettime - @currenttime).' more seconds until you can use an emote again.'));
            }

            return(true);
        }
    ));

    broadcast('debug: registered '.@emote);
}
