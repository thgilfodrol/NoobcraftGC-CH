proc _ncbuy_get_perks(){
    @perks = array();
    @perks['enderchest'] = array(
        'description': 'Access your ender chest with /ec',
        'cost': 5000);
    @perks['workbench'] = array(
        'description': 'Open a crafting table interface anywhere with /workbench',
        'cost': 5000);
    @perks['backondeath'] = array(
        'description': 'Return to where you died using /back',
        'cost': 10000);
    @perks['keepxp'] = array(
        'description': 'Keep your experience if you die',
        'cost': 15000);

    return(@perks);
}

proc _ncbuy_get_kits(){
    @kits = array();
    @kits['mats'] = array(
        'description': '16 glowstone, 32 cobblestone, 32 sand, 16 oak logs, 16 coal',
        'cost': 45);
    @kits['armor'] = array(
        'description': 'Chain Armor Set',
        'cost': 60);
    @kits['tools'] = array(
        'description': 'stone sword, stone axe, stone pickaxe, stone shovel',
        'cost': 15);
    @kits['fishingtools'] = array(
        'description': 'weakly enchanted fishing rod, fishing boat, bait',
        'cost': 50);

    return(@kits);
}
