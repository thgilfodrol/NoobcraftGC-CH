proc _ncbuy_get_perks(){
    @perks = array();
    @perks['enderchest'] = array(
        'description': 'Access your ender chest with /ec',
        'permnode': 'essentials.enderchest',
        'cost': 5000);
    @perks['workbench'] = array(
        'description': 'Open a crafting table interface anywhere with /workbench',
        'permnode': 'essentials.workbench',
        'cost': 5000);
    @perks['backondeath'] = array(
        'description': 'Return to where you died using /back',
        'permnode': 'essentials.back.ondeath',
        'cost': 10000);
    @perks['keepxp'] = array(
        'description': 'Keep your experience if you die',
        'permnode': 'essentials.keepxp',
        'cost': 15000);

    return(@perks);
}

proc _ncbuy_get_kits(){
    @kits = array();
    @kits['mats'] = array(
        'description': '16 glowstone, 32 cobblestone, 32 sand, 16 oak logs, 16 coal',
        'items': array(
            array('type': 89, 'qty': 16, 'meta': null),
            array('type': 4, 'qty': 32, 'meta': null),
            array('type': 12, 'qty': 32, 'meta': null),
            array('type': 17, 'qty': 16, 'meta': null),
            array('type': 263, 'qty': 16, 'meta': null)),
        'cost': 45);
    @kits['armor'] = array(
        'description': 'Chain Armor Set',
        'items': array(
            array('type': 302, 'qty': 1, 'meta': null),
            array('type': 303, 'qty': 1, 'meta': null),
            array('type': 304, 'qty': 1, 'meta': null),
            array('type': 305, 'qty': 1, 'meta': null)),
        'cost': 60);
    @kits['tools'] = array(
        'description': 'Stone sword and tools set',
        'items': array(
            array('type': 272, 'qty': 1, 'meta': null),
            array('type': 275, 'qty': 1, 'meta': null),
            array('type': 274, 'qty': 1, 'meta': null),
            array('type': 273, 'qty': 1, 'meta': null),
            array('type': 291, 'qty': 1, 'meta': null)),
        'cost': 10);
    @kits['fishingtools'] = array(
        'description': 'Weakly enchanted fishing rod, fishing boat, bait',
        'items': array(
            array('type': 346, 'qty': 1, 'meta': array(
                'enchants': array(array('etype': 'LUCK', 'elevel': 2), array('etype': 'LURE', 'elevel': 2)),
                'display': colorize('&r&bTrusty Fishing Rod'))),
            array('type': 333, 'qty': 1, 'meta': array('display': colorize('&r&6Trusty Canoe'))),
            array('type': 297, 'qty': 4, 'meta': array('display': colorize('&r&6Fishing Bait')))),
        'cost': 50);

    return(@kits);
}
