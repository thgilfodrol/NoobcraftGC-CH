# {c} is a tag substitute for the colour from _nctitle_get_rank_color()
proc _nctitle_get_titles(){
    @titles = array();

    # default titles
    @titles['adventurer'] = array(
        'display': '[Adventurer]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['explorer'] = array(
        'display': '[Explorer]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['hunter'] = array(
        'display': '[Hunter]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['noob'] = array(
        'display': '[Noob]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['fighter'] = array(
        'display': '[Fighter]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'category': 'default',
        'permnode': null);
    @titles['pansy'] = array(
        'display': '[Pansy]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'permnode': null);
    @titles['gatherer'] = array(
        'display': '[Gatherer]',
        'special': false,
        'donor': false,
        'info': 'has no special requirements',
        'permnode': null);

    # special titles
    @titles['champion'] = array(
        'display': '&6[{c}Champion&6]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by winning a Mob Arena match',
        'permnode': 'nc.title.champion');
    @titles['gladiator'] = array(
        'display': '[Gladiator]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by playing a special Mob Arena match',
        'permnode': 'nc.title.gladiator');
    @titles['voidwalker'] = array(
        'display': '&5[&9VoidWalker&5]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by winning a special Mob Arena match',
        'permnode': 'nc.title.voidwalker');
    @titles['wraith'] = array(
        'display': '[Wraith]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by having 1000 deaths',
        'permnode': 'nc.title.wraith');
    @titles['masterofdeath'] = array(
        'display': '[Master of Death]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by having 5000 deaths',
        'permnode': 'nc.title.masterofdeath');
    @titles['survivalist'] = array(
        'display': '[Survivalist]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by registering on our /forums and then having an Admin activate your account',
        'permnode': 'nc.title.survivalist');
    @titles['theeggceptional'] = array(
        'display': '[The Eggceptional]',
        'special': true,
        'donor': false,
        'info': 'can be unlocked by finding a lucky egg during an Easter Egg Hunt.',
        'permnode': 'nc.title.theeggceptional');

    # donor 1 titles
    @titles['the'] = array(
        'display': '[The]',
        'special': false,
        'donor': true,
        'info': 'reserved for Donor 1.',
        'permnode': 'nc.perks.titles.tier.1');
    @titles['lord'] = array(
        'display': '[Lord]',
        'special': false,
        'donor': true,
        'info': 'reserved for Donor 1.',
        'permnode': 'nc.perks.titles.tier.1');
    @titles['lady'] = array(
        'display': '[Lady]',
        'special': false,
        'donor': true,
        'info': 'reserved for Donor 1.',
        'permnode': 'nc.perks.titles.tier.1');
    @titles['duke'] = array(
        'display': '[Duke]',
        'special': false,
        'donor': true,
        'info': 'reserved for Donor 1.',
        'permnode': 'nc.perks.titles.tier.1');
    @titles['duchess'] = array(
        'display': '[Duchess]',
        'special': false,
        'donor': true,
        'info': 'reserved for Donor 1.',
        'permnode': 'nc.perks.titles.tier.1');

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

# returns the player's name with prefix and suffix applied
# (basically what shows up in chat)
proc _nctitle_get_formatted_name(@p){
    @rcol = _nctitle_get_rank_color(@p); # rank colour
    @prefix = vault_user_prefix(pworld(@p), @p);
    @suffix = vault_user_suffix(pworld(@p), @p);
    return(colorize(concat(@prefix, @rcol, display_name(@p), @suffix)));
}
