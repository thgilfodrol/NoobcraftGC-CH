# MethodScript mplementation of CloudBot's .taco emote
assign(@ptag, '&9[NCEmotes] ')
assign(@mcol, '&7')
assign(@kcol, '&6')
register_command('ataco', array(
    'description': colorize(@ptag.@mcol.'Gift a cherished someone a taco.'),
    'usage': colorize(@ptag.@mcol.'Usage: /ataco <player>'),
    'permission': 'nc.emotes.ataco',
    'noPermMsg': colorize(@ptag.@mcol.'You do not have permission to gift people tacos D: .'),
    'tabcompleter': closure(@alias, @sender, @args) {
        if(array_size(@args) == 0) {
			return(all_players());
        }
        @search = @args[array_size(@args) - 1];
        return(array_filter(all_players(), closure(@index, @player) {
			return(equals_ic(@search, substr(@player, 0, length(@search))));
        }));
    },
    'aliases':array('sendtaco'),
    'executor': closure(@alias, @sender, @args) {
        if(array_size(@args) == 1) {
			assign(@quality, array('spicy', 'mild', 'delicious', 'boring', 'perfect', 'scrumptious', 'mouthwatering', 'savoury'));
			assign(@type, array('hard-shell', 'soft-shell', 'crispy', 'puffy', 'Indian'));
			assign(@meat, array('minced beef', 'shredded beef', 'steak', 'pork', 'various meats', 'mystery meat', 'chicken', 'refried beans', 'tofu'));
			assign(@topping, array('guacamole', 'salsa', 'sour cream', 'cheese', 'lettuce', 'tomatoes', 'avocado', 'fried rice', 'onion', 'scallions', 'jalapenos', 'capsicum', 'ghost chili', 'olives', 'pineapple', 'raspberries', 'ghast tears', 'magma cream'));
			if(equals_ic(@args[0], 'announcer')) {
				broadcast(colorize('&7[G] * '.pinfo(@sender)[4].'&7 orders a taco.'));
				broadcast(colorize('&9[&6Announcer&9]&7 hands '.@sender.'&7 a '.array_rand(@quality, 1, false)[0].' '.array_rand(@type, 1, false)[0].' taco filled with '.array_rand(@meat, 1, false)[0].' and topped with '.array_rand(@topping, 1, false)[0].', '.array_rand(@topping, 1, false)[0].', and '.array_rand(@topping, 1, false)[0].'!'));				
            } else if(ponline(player(@args[0]))) {
				broadcast(colorize('&7[G] * '.pinfo(@sender)[4].'&7 orders a taco for '.player(@args[0]).'&7.'));
				broadcast(colorize('&9[&6Announcer&9]&7 hands '.player(@args[0]).'&7 a '.array_rand(@quality, 1, false)[0].' '.array_rand(@type, 1, false)[0].' taco filled with '.array_rand(@meat, 1, false)[0].' and topped with '.array_rand(@topping, 1, false)[0].', '.array_rand(@topping, 1, false)[0].', and '.array_rand(@topping, 1, false)[0].'!'));				
            } else {
				broadcast(colorize('&7[G] * '.pinfo(@sender)[4].'&7 orders a taco for '.@args[0].'.'));
				broadcast(colorize('&9[&6Announcer&9]&7 hands '.@args[0].'&7 a '.array_rand(@quality, 1, false)[0].' '.array_rand(@type, 1, false)[0].' taco filled with '.array_rand(@meat, 1, false)[0].' and topped with '.array_rand(@topping, 1, false)[0].', '.array_rand(@topping, 1, false)[0].', and '.array_rand(@topping, 1, false)[0].'!'));
            }
            return(true);
        }
        return(false);
    }
));