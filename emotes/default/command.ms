include('procs.ms');

@emotes = _ncemotes_get_emotes();
# iterate over list of emotes to register each as an actual command using metadata
foreach(@emote:@metadata in @emotes){ # @emote is the name/command of emote
    @requiredperm = 'nc.emotes.default'; # default permission node for all emotes if no perm is specified
    if(array_index_exists(@metadata, 'permnode')){
        if(@metadata['permnode'] == ''){
            @requiredperm = 'nc.emotes.default'; # default permission node for all emotes if no perm is specified
        } else{
            @requiredperm = @metadata['permnode']; # use supplied perm
        }
    }

    register_command(@emote, associative_array(
        'description': 'Part of the standard set of emotes.',
        'usage': '/'.@emote.' [optional text]',
        'permission': @requiredperm,
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

                if(is_string(@metadata['format'])){
                    broadcast(colorize('&a'.@sender.' '.@metadata['format'].@details.'.'));
                } else if(is_closure(@metadata['format'])){
                    execute(@sender, @args, @metadata['format']);
                } else{ # config issue- format is neither string nor closure
                    msg(colorize('&4An internal error has occurred when running this command.'));
                    msg(colorize('&cPlease tell a staff member what command brought up this message.'));
                }
            } else{
                msg(colorize('&cYou must wait '.ceil(@resettime - @currenttime).' more seconds until you can use an emote again.'));
            }

            return(true);
        }
    ));

    broadcast('debug: registered '.@emote);
}
