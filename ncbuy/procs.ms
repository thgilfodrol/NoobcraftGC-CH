proc _ncbuy_get_perks(){
    @perks = array();
    @perks['enderchest'] = array(
        'description': 'Access your ender chest with /ec',
        'permnode': 'essentials.enderchest',
        'cost': 55000);
    @perks['workbench'] = array(
        'description': 'Open a crafting table interface anywhere with /workbench',
        'permnode': 'essentials.workbench',
        'cost': 6000);
    @perks['backondeath'] = array(
        'description': 'Return to where you died using /back',
        'permnode': 'essentials.back.ondeath',
        'cost': 60000);
    @perks['keepxp'] = array(
        'description': 'Keep your experience if you die',
        'permnode': 'essentials.keepxp',
        'cost': 30000);

    return(@perks);
}

proc _ncbuy_get_kits(){
    @kits = array();
    @kits['mats'] = array(
        'description': '16 glowstone, 32 cobblestone, 32 sand, 16 oak logs, 16 coal',
        'items': array(
            array('name': 'GLOWSTONE', 'qty': 16, 'meta': null),
            array('name': 'COBBLESTONE', 'qty': 32, 'meta': null),
            array('name': 'SAND', 'qty': 32, 'meta': null),
            array('name': 'OAK_LOG', 'qty': 16, 'meta': null),
            array('name': 'COAL', 'qty': 16, 'meta': null)),
        'cost': 300);
    @kits['armor'] = array(
        'description': 'Chain Armor Set',
        'items': array(
            array('name': 'CHAINMAIL_HELMET', 'qty': 1, 'meta': null),
            array('name': 'CHAINMAIL_CHESTPLATE', 'qty': 1, 'meta': null),
            array('name': 'CHAINMAIL_LEGGINGS', 'qty': 1, 'meta': null),
            array('name': 'CHAINMAIL_BOOTS', 'qty': 1, 'meta': null)),
        'cost': 450);
    @kits['tools'] = array(
        'description': 'Stone sword and tools set',
        'items': array(
            array('name': 'STONE_SWORD', 'qty': 1, 'meta': null),
            array('name': 'STONE_AXE', 'qty': 1, 'meta': null),
            array('name': 'STONE_PICKAXE', 'qty': 1, 'meta': null),
            array('name': 'STONE_SHOVEL', 'qty': 1, 'meta': null),
            array('name': 'STONE_HOE', 'qty': 1, 'meta': null)),
        'cost': 50);
    @kits['fishingtools'] = array(
        'description': 'Weakly enchanted fishing rod, fishing boat, bait',
        'items': array(
            array('name': 'FISHING_ROD', 'qty': 1, 'meta': array(
                'enchants': array(array('etype': 'LUCK', 'elevel': 1), array('etype': 'LURE', 'elevel': 1)),
                'display': colorize('&r&bTrusty Fishing Rod'))),
            array('name': 'OAK_BOAT', 'qty': 1, 'meta': array('display': colorize('&r&6Trusty Canoe'))),
            array('name': 'BREAD', 'qty': 4, 'meta': array('display': colorize('&r&6Fishing Bait')))),
        'cost': 250);
    @kits['food'] = array(
        'description': 'Food to sustain you for a short time',
        'items': array(
            array('name': 'APPLE', 'qty': 3, 'meta': array('display': colorize('&r&6Apple'))),
            array('name': 'CARROT', 'qty': 2, 'meta': array('display': colorize('&r&6Carrot')))),
        'cost': 75);


    return(@kits);
}
