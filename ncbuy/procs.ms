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
