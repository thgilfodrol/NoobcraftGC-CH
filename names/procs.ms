# {c} is a tag substitute for the colour from _nctitle_get_rank_color()
proc _nctitle_get_titles(){
    @titles = array();
    # default titles
    @titles['adventurer'] = array(
        'display': '[Adventurer]',
        'permnode': null);
    @titles['explorer'] = array(
        'display': '[Explorer]',
        'permnode': null);
    @titles['hunter'] = array(
        'display': '[Hunter]',
        'permnode': null);
    @titles['noob'] = array(
        'display': '[Noob]',
        'permnode': null);
    @titles['fighter'] = array(
        'display': '[Fighter]',
        'permnode': null);
    @titles['pansy'] = array(
        'display': '[Pansy]',
        'permnode': null);
    @titles['gatherer'] = array(
        'display': '[Gatherer]',
        'permnode': null);
    # special titles
    @titles['champion'] = array(
        'display': '&6[{c}Champion&6]',
        'permnode': 'nc.title.champion');
    @titles['gladiator'] = array(
        'display': '[Gladiator]',
        'permnode': 'nc.title.gladiator');
    @titles['voidwalker'] = array(
        'display': '&5[&9VoidWalker&5]',
        'permnode': 'nc.title.voidwalker');

    return(@titles);
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
