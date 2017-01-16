# Default weapons. Consider merging with array in _gun_stats(@abbreviation) 
export('weapons', array(
	SR: 'Sniper Rifle',
	DMR: 'Designated Marksman Rifle',
	SG: 'Shotgun',
	AR: 'Assault Rifle',
	MN: 'Magnum',
	TR: 'Turret',
));

# Scope zoom mechanic
# TODO: Individual player binds to allow for arena integration
# TODO: Add zoom key to gun stats and use that instead of constants
# TODO: Use _get_active_gun(@player) instead of remaking the array here
bind(player_toggle_sneak, null, null, @event,
    @p = @event[player];
	@uuid = puuid(@p);
	@item = get_inventory_item(@uuid, pheld_slot(@p));
	if(@event[sneaking]){
		if (@item != null){
			if (@item[name] == 'GOLD_NUGGET'){
				set_peffect(@p, 2, 3, 3600, false, false);
			} else if (@item[name] == 'IRON_INGOT'){
				set_peffect(@p, 2, 2, 3600, false, false);
			} else if (@item[name] == 'STICK'){
				set_peffect(@p, 2, 0, 3600, false, false);
			} else if (@item[name] == 'ARROW'){
				set_peffect(@p, 2, 1, 3600, false, false);
			} else if (@item[name] == 'CLAY_BRICK'){
				set_peffect(@p, 2, 0, 3600, false, false);
			}
		}
	} else{
		set_peffect(@p, 2, 0, 0, false, false);
	}	
	export(@event[player].'.sneaking', @event[sneaking]);
)

# Fires projectiles with stats according to what weapon the player is holding
# TODO: Individual player binds to allow for arena integration
bind(player_interact, null, null, @event,
	include('core-procs.ms');
	if (@event[action] == 'right_click_block' || @event[action] == 'right_click_air'){
		if (@event[hand] == 'main_hand'){
			@p = @event[player];
			@uuid = puuid(@p);
			@starttime = time();
			@gun = _get_active_gun(@p);
			if (_is_gun(@gun)){
				@gunstats = _gun_stats(@gun);
				@plevel = plevel(@p);
				if (add(@gunstats[firerate], import(@p.'.ratecd', 0)) > time() # not limited by fire rate
					|| @plevel < @gunstats[ammopershot]){ # not enough ammo
					die();
				}
				@bullets = import('bullets', array());				
				@finalaccuracy = @gunstats[baseaccuracy]; # higher values are better
				if (!entity_grounded(@uuid)){
					@finalaccuracy -= @gunstats[baseaccuracy] * 0.5;
				}
				if (import(@p.'.sneaking', false)){
					@finalaccuracy += @gunstats[baseaccuracy] * @gunstats[scopemodifier];
				}
				@lineofsight = entity_line_of_sight(@uuid, array(0), 50);
				# NB- guns with multiple projectiles per shot don't currently work due to damage immunity mechanics in mc
				for(@i = 0, @i < @gunstats[roundspershot], @i++){ # loop allows for guns with more than one projectile per shot (e.g. shotguns) 
					@bulletuuid = shoot_projectile(@uuid, 'SNOWBALL', @lineofsight[array_size(@lineofsight) - 1], @gunstats[bulletspeed]);
					@velocity = array_normalize(entity_velocity(@bulletuuid))[cslice(0, 3)];
					@direction = array(@velocity[0] / @velocity[3], @velocity[1] / @velocity[3], @velocity[2] / @velocity[3]);
					set_entity_velocity(@bulletuuid, _randomize_direction(@direction[cslice(0, 2)], @finalaccuracy, @velocity[3]));
					array_push(@bullets, array(@bulletuuid, @gunstats[damage], @p, @gun));
					#array_merge(@bullets, array(@bulletuuid: array(@gunstats[damage], @p, @gun))); experimental non-looped method
				}
				set_plevel(@p, @plevel - @gunstats[ammopershot]); # remove ammo
				export('bullets', @bullets);
				export(@p.'.ratecd', time());
				#broadcast('TOOK '.subtract(time(), @starttime).'ms');
			}
		}
	}
)

# Removes active bullets from cache upon collision
bind(projectile_hit, null, array(type: 'SNOWBALL'), @event, @thg){
	@bullets = import('bullets', array());
	@i = 0;
	# Consider making a proc for this
	foreach(@bullet in @bullets){
		if (@bullet[0] == @event[id]){
			array_remove(@bullets, @i);
			break();
		}
		@i++;
	}
	export('bullets', @bullets);
}

# Applies projectile damage to entities, and resets the player's shield regen status
bind(entity_damage, null, array(cause: 'PROJECTILE'), @event, @thg){
	@bullets = import('bullets', array());
	foreach(@bullet in @bullets){		
		if (@bullet[0] == @event[damager]){
			modify_event('amount', @bullet[1]);
			tmsg(@bullet[2], colorize('&8'.@bullet[3].' &7bullet &8'.@bullet[0].' &7did &8'.(@bullet[1] / 2).'\u2764&7.'));
			if (@event[type] == 'PLAYER'){
				@p = @event[player];
				export(@p.'.shieldlasthit', time());
				clear_task(import(@p.'.currshieldtask'));
				export(@p.'.currshieldtask', set_timeout(10000, closure(){
					if (ponline(@p) && add(import(@p.'.shieldlasthit', 0), 10000) < time()){
						set_peffect(@p, 22, 0, 0, false, false);
						set_peffect(@p, 22, 9, 3600, false, false);					
						tmsg(@p, colorize('&7=-=-=SHIELDS REGENERATED=-=-='));
					}
				}));
			}			
			break();
		}
	}
}

# Custom death messages for fps module related deaths
bind(player_death, array(priority: 'HIGHEST'), null, @event, @thg){
	include('core-procs.ms');
	@e = @event[cause];
	if (@e[cause] == 'PROJECTILE'){
		@bullets = import('bullets', array());
		foreach(@bullet in @bullets){		
			if (@bullet[0] == @e[damager]){
				@p = get_player_from_entity_id(@e[id]);
				@gun = _gun_long_name(@bullet[3]);
				modify_event('death_message', colorize('&c'.@p.' &7was killed by &9'.@bullet[2].' &8[&5'.@gun.'&8]'));
				# Gory effects- redstone block crack particles
				runas('~console', '/execute '.@p.' ~ ~ ~ particle blockcrack '.@e[location][x].' '.add(@e[location][y], 1).' '.@e[location][z].' 0.5 0.5 0.5 0 30 force @a 152'); 
				break();
			}
		}
	}	
	modify_event('keep_inventory', true);	
}