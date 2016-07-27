# Live version, copy to main.ms
bind(vehicle_enter, array(priority: monitor), array(vehicletype: 'HORSE'), @event,    
	if(@event[passengertype] == 'PLAYER' && !is_cancelled()){
		# Declare variables
		assign(@entity_id, @event[vehicle]);
		assign(@entity_loc, entity_loc(@entity_id));
		# Check if counter exists
		if(!has_value('testing.olympus.ht.cid')){
			store_value('testing.olympus.ht.cid', -1);
		}
		# Construct array for storage
		assign(@norm_eloc, array_normalize(@entity_loc)[cslice(0, 3)]);
		assign(@floor_eloc, array(floor(@norm_eloc[0]), floor(@norm_eloc[1]), floor(@norm_eloc[2]), @norm_eloc[3]));
		@ncid = get_value('testing.olympus.ht.cid') + 1;
		store_value('testing.olympus.ht.data.'.@ncid, array(@ncid, ceil(time() / 1000), @floor_eloc, 'vehicle_enter', @event[passenger], @entity_id));
		# Increment counter
		store_value('testing.olympus.ht.cid', @ncid);
		# Done!
		broadcast(colorize('&c[!] '.@event[player].' mounted a horse. Assigned Gargoyle id #'.@ncid.'.'), 'nc.title.semimod');
	}
)