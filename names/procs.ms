# {c} is a tag substitute for the colour from _nctitle_get_rank_color()
proc _nctitle_get_titles(){
    @titles = array();
    # default titles
    @titles['adventurer'] = array(
        'display': '[Adventurer]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['explorer'] = array(
        'display': '[Explorer]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['hunter'] = array(
        'display': '[Hunter]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['noob'] = array(
        'display': '[Noob]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['fighter'] = array(
        'display': '[Fighter]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['pansy'] = array(
        'display': '[Pansy]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['gatherer'] = array(
        'display': '[Gatherer]',
        'special': false,
        'info': 'has no special requirements',
        'permnode': null);
    # special titles
    @titles['champion'] = array(
        'display': '&6[{c}Champion&6]',
        'special': true,
        'info': 'can be unlocked by winning a Mob Arena match',
        'permnode': 'nc.title.champion');
    @titles['gladiator'] = array(
        'display': '[Gladiator]',
        'special': true,
        'info': 'can be unlocked by playing a special Mob Arena match',
        'permnode': 'nc.title.gladiator');
    @titles['voidwalker'] = array(
        'display': '&5[&9VoidWalker&5]',
        'special': true,
        'info': 'can be unlocked by winning a special Mob Arena match',
        'permnode': 'nc.title.voidwalker');
    @titles['wraith'] = array(
        'display': '[Wraith]',
        'special': true,
        'info': 'can be unlocked by having 1000 deaths',
        'permnode': 'nc.title.wraith');
    @titles['masterofdeath'] = array(
        'display': '[Master of Death]',
        'special': true,
        'info': 'can be unlocked by having 5000 deaths',
        'permnode': 'nc.title.masterofdeath');
    @titles['survivalist'] = array(
        'display': '[Survivalist]',
        'special': true,
        'info': 'can be unlocked by registering on our /forums and then having an Admin activate your account',
        'permnode': 'nc.title.survivalist');
    @titles['theeggceptional'] = array(
        'display': '[The Eggceptional]',
        'special': true,
        'info': 'can be unlocked by finding a lucky egg during an Easter Egg Hunt.',
        'permnode': 'nc.title.theeggceptional');

    return(@titles);
}


proc _nctitle_title_exists(@title){
    return(array_index_exists(_nctitle_get_titles(), @title));
}

# Returns a string with a title formatted in accordance with the player's rank
# Does not check if title is valid
proc _nctitle_format_title(@player, @title){
    @titledata = _nctitle_get_titles()[@title];
    @color = _nctitle_get_rank_color(@player);
    return(@color.replace(@titledata['display'], '{c}', @color).' '.@color);
}

proc _nctitle_get_rank_color(@player){
    if(has_permission(@player, 'nc.title.admin')){ # the player is an admin
        return('&8');
    } else if(has_permission(@player, 'nc.title.semiadmin')){ # the player is a semiadmin
        return('&5');
    } else if(has_permission(@player, 'nc.title.moderator')){ # the player is a moderator
        return('&9');
    } else if(has_permission(@player, 'nc.title.semimod')){ # the player is a semimod
        return('&b');
    } else if(has_permission(@player, 'nc.title.veteran')){ # the player is a veteran
        return('&6');
    } else{ # player has none of the above perms, giving them a green tag for Member
        return('&2');
    }
}
