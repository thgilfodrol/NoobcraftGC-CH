# Function that accepts an xyz direction array, shifts it by random values as per the @factor,
# and multiplies it with speed again to turn it into a vector array
proc _randomize_direction(@array, @factor, @speed){
	for(@i = 0, @i < array_size(@array), @i++){
		@array[@i] = (@array[@i] + (rand() - 0.5) / @factor) * @speed;
	}
	return(@array);
}

# Retrieve the gun the player is currently holding in their main hand
# Consider using array for data instead of comparisons
proc _get_active_gun(@player){
	@item = get_inventory_item(puuid(@player), pheld_slot(@player));
	if (@item == null){
		return(null);
	} else{
		if (@item[name] == 'GOLD_NUGGET'){
			return('SR');
		} else if (@item[name] == 'IRON_INGOT'){
			return('DMR');
		} else if (@item[name] == 'STICK'){
			return('SG');
		} else if (@item[name] == 'ARROW'){
			return('AR');
		} else if (@item[name] == 'CLAY_BRICK'){
			return('MN');
		} else{
			return(null);
		}
	}
}

# Given the short name of a gun, returns true if it is a gun and false if not
proc _is_gun(@abbreviation){
	@weapons = import('weapons', array());
	return(array_contains(array_keys(@weapons), @abbreviation));
}

# Given the short name of a gun, returns the long name of the gun
proc _gun_long_name(@abbreviation){
	@weapons = import('weapons', array());
	return(@weapons[@abbreviation]);
}

# Given the short name of a gun, returns an array of its stats
# TODO: Consider merging with the export('weapons') list
proc _gun_stats(@abbreviation){
	@weapons = array(
		# Format: fire_rate, base_accuracy, scope_accuracy_modifier, bullet_speed, damage, ammo_per_shot, rounds_per_shot, mag_size, reload_speed, projectile_type
		SR: array(name: 'Sniper Rifle', firerate: 2000, baseaccuracy: 4.0, scopemodifier: 10, bulletspeed: 4.5, damage: 24, ammopershot: 1, roundspershot: 1, magsize: 7, reloadspeed: 4000, projectile: 'SNOWBALL'), # Sniper Rifle
		DMR: array(name: 'Designated Marksman Rifle', firerate: 500, baseaccuracy: 7.0, scopemodifier: 8, bulletspeed: 4.0, damage: 10, ammopershot: 1, roundspershot: 1, magsize: 15, reloadspeed: 2500, projectile: 'SNOWBALL'), # Designated Marksman Rifle
		SG: array(name: 'Shotgun', firerate: 1500, baseaccuracy: 6.0, scopemodifier: 2, bulletspeed: 2.0, damage: 3, ammopershot: 1, roundspershot: 8, magsize: 8, reloadspeed: 5000, projectile: 'SNOWBALL'), # Shotgun
		AR: array(name: 'Assault Rifle', firerate: 100, baseaccuracy: 8.0, scopemodifier: 3.5, bulletspeed: 3.5, damage: 4, ammopershot: 1, roundspershot: 1, magsize: 36, reloadspeed: 2000, projectile: 'SNOWBALL'), # Shotgun
		MN: array(name: 'Magnum', firerate: 500, baseaccuracy: 9.0, scopemodifier: 5, bulletspeed: 2.5, damage: 12, ammopershot: 1, roundspershot: 1, magsize: 6, reloadspeed: 1000, projectile: 'SNOWBALL'), # Shotgun
	);	
	return(@weapons[@abbreviation]);
}