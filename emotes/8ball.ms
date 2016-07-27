# MethodScript mplementation of CloudBot's .8ball emote
assign(@ptag, '&9[NCEmotes] ')
assign(@mcol, '&7')
assign(@kcol, '&6')
register_command('8ball', array(
    'description': colorize(@ptag.@mcol.'Ask Announcer a simple question.'),
    'usage': colorize(@ptag.@mcol.'Usage: /8ball <question>\n'.
	@ptag.@mcol.'To ignore 8ball usage until next restart or until you toggle it again, use /8ball <on|off>'
	),
    'permission': 'nc.emotes.8ball',
    'noPermMsg': colorize(@ptag.@mcol.'You do not have permission to use this command.'),
    'tabcompleter': closure(@alias, @sender, @args) {
        if(array_size(@args) == 0) {
			return(all_players());
        }
        @search = @args[array_size(@args) - 1];
        return(array_filter(all_players(), closure(@index, @player) {
			return(equals_ic(@search, substr(@player, 0, length(@search))));
        }));
    },
    'aliases':array('8', 'eightball'),
    'executor': closure(@alias, @sender, @args) {
        if(array_size(@args) > 0) {
			assign(@cooldown, 30);
			assign(@lastuse, import(@sender.'.8ball.cooldown', 0));
			if (add(@lastuse, @cooldown) > divide(time(), 1000)){
				assign(@timeleft, subtract(add(@lastuse, @cooldown), divide(time(),1000)));
				msg(colorize(@ptag.@mcol.'You must wait '.@kcol.ceil(@timeleft).@mcol.' more seconds before asking another question.'));
				return(true);
			}
			if (equals_ic(@args[0], 'on')){
				export(@sender.'.8ball.ignored', false);
				die(colorize(@ptag.@mcol.'Now &ashowing '.@mcol.'8ball content.'));
			} else if (equals_ic(@args[0], 'off')){
				export(@sender.'.8ball.ignored', true);
				die(colorize(@ptag.@mcol.'Now &chiding '.@mcol.'8ball content.'));
			}
			assign(@responses, array( # coloured responses
				'&2&lAs I see it, yes.', 
				'&2&lIt is certain.', 
				'&2&lIt is decidedly so.', 
				'&2&lMost likely.', 
				'&2&lOutlook good.', 
				'&2&lSigns point to yes.', 
				'&2&lOne would be wise to think so.', 
				'&2&lNaturally.',
				'&2&lWithout a doubt.',
				'&2&lYes.',
				'&2&lYes, definitely.',
				'&2&lYou may rely on it.',
				'&lReply hazy, try again.',
				'&lAsk again later.',
				'&lBetter not tell you  now.',
				'&lCannot predict now.',
				'&lConcentrate and ask again.',
				'&lYou know the answer better than I.',
				'&lMaybe...',
				'&c&lYou\'re kidding, right?',
				'&c&lDon\'t count on it.',
				'&c&lIn your dreams.',
				'&c&lMy reply is no.',
				'&c&lMy sources say no.',
				'&c&lOutlook not so good.',
				'&c&lVery doubtful.',
			));
			assign(@response, array_rand(@responses, 1, false)[0]);
			foreach(@player in all_players()){
				assign(@ignored, import(@player.'.8ball.ignored', false));
				if(!@ignored || @player == @sender){
					tmsg(@player, colorize('&7[G] * '.@sender.'&7 asks Announcer, ').array_implode(@args).'');
					tmsg(@player, colorize('&9[&6Announcer&9]&7 shakes the all knowing electronic 8ball...'));
					tmsg(@player, colorize('&9[&6Announcer&9]&7 says, '.@response));
				}
			}
			export(@sender.'.8ball.cooldown', divide(time(), 1000));
            return(true);
        }
        return(false);
    }
));