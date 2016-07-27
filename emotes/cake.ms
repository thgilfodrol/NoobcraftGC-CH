# MethodScript mplementation of CloudBot's .cake emote
assign(@ptag, '&9[NCEmotes] ')
assign(@mcol, '&7')
assign(@kcol, '&6')
register_command('acake', array(
    'description': colorize(@ptag.@mcol.'Gift a cherished someone a cake.'),
    'usage': colorize(@ptag.@mcol.'Usage: /acake <player>'),
    'permission': 'nc.emotes.acake',
    'noPermMsg': colorize(@ptag.@mcol.'You do not have permission to gift people cakes D: .'),
    'tabcompleter': closure(@alias, @sender, @args) {
        if(array_size(@args) == 0) {
			return(all_players());
        }
        @search = @args[array_size(@args) - 1];
        return(array_filter(all_players(), closure(@index, @player) {
			return(equals_ic(@search, substr(@player, 0, length(@search))));
        }));
    },
    'aliases':array('sendcake'),
    'executor': closure(@alias, @sender, @args) {
        if(array_size(@args) == 1) {
			assign(@adjective, array('scrumptious', 'delicious', 'mouthwatering', 'incredible', 'tasty', 'rich', 'delectable', 'yummy', 'savoury', 'freshly baked', 'warm', 'molten'));
			assign(@flavour, array('chocolate', 'vanilla bean', 'butterscotch', 'red velvet', 'tiramisu', 'caramel', 'strawberry shortcake', 'lemon raspberry', 'pumpkin spice', 'cherry creme', ''));
			assign(@type, array('moon', 'marble', 'genoa', 'cup', 'sponge', 'cream pie', 'bundt', 'marshmallow', 'angel food', 'ice cream', 'cheese'));
			assign(@filling, array('glazed strawberry', 'chocolate mousse', 'caramel fudge', 'custard', 'crushed oreo', 'nutella', 'diced peach', 'pineapple', 'blueberry', 'apricot', 'fruit salad'));
			assign(@side, array('roasted trail mix', 'chocolate ice cream', 'triple chocolate sauce', 'dried fruit', 'fresh strawberries', 'raspberry ice cream', 'gummy bears', 'mint chocolates', 'poptarts', 'oreos', 'rainbow sprinkles'));
			if(equals_ic(@args[0], 'announcer')) {
				broadcast(colorize('&7[G] * '.pinfo(@sender)[4].'&7 orders a cake.'));		
				broadcast(colorize('&9[&6Announcer&9]&7 hands '.@sender.'&7 a '.array_rand(@adjective, 1, false)[0].' '.array_rand(@flavour, 1, false)[0].' '.array_rand(@type, 1, false)[0].' cake with '.array_rand(@filling, 1, false)[0].' filling served with a small bowl of '.array_rand(@side, 1, false)[0].'!'));
            } else if(ponline(player(@args[0]))) {
				broadcast(colorize('&7[G] * '.pinfo(@sender)[4].'&7 orders a cake for '.player(@args[0]).'&7.'));
				broadcast(colorize('&9[&6Announcer&9]&7 hands '.player(@args[0]).'&7 a '.array_rand(@adjective, 1, false)[0].' '.array_rand(@flavour, 1, false)[0].' '.array_rand(@type, 1, false)[0].' cake with '.array_rand(@filling, 1, false)[0].' filling served with a small bowl of '.array_rand(@side, 1, false)[0].'!'));
            } else {
				broadcast(colorize('&7[G] * '.pinfo(@sender)[4].'&7 orders a cake for '.@args[0].'.'));
				broadcast(colorize('&9[&6Announcer&9]&7 hands '.@args[0].'&7 a '.array_rand(@adjective, 1, false)[0].' '.array_rand(@flavour, 1, false)[0].' '.array_rand(@type, 1, false)[0].' cake with '.array_rand(@filling, 1, false)[0].' filling served with a small bowl of '.array_rand(@side, 1, false)[0].'!'));
            }
            return(true);
        }
        return(false);
    }
));