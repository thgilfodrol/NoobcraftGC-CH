# Displays to the player the logs as per the parameters they included (base proc credits to CH wiki)
# Accepts an array with relevant information, the page number, and the amount of results to list per page
proc _paginate_gargoyle_lookup(@list, @page, @perpage=5) {
    assign(@ptag, '&cGargoyle // ');
	assign(@mcol, '&7');
	assign(@kcol, '&8');
	# Check if @list is empty and sorts alphabetically
    if( @list == null ) {
        @list = array();
    }
    # Checks to see if any values would appear on the specified page
    # If so, get all values from that page and push them to the array, else get page 1
    @maxpage = ceil(array_size(@list) / @perpage)
    if(!is_integral(@page) || @maxpage == 0) {
        @maxpage = 1;
    }
    # If the page number is less than 1, higher than the maximum page, or not a number
    if(!is_integral(@page) || @page < 1 || @page > @maxpage) {
        die(colorize(@ptag.@kcol.'Invalid page.'));
    }
	# Subset of @list
    @finalList = array();
    for(@i = (@page - 1) * @perpage, @i < (@page * @perpage), @i++) {
        if(array_size(@list) > @i) {
            array_push(@finalList, @list[@i]);
        }
    }
    msg(colorize(@ptag.@mcol.'Showing '.array_size(@list).' results. Page '.@page.' of '.@maxpage));
    foreach(@value in @finalList){
		# Check if it matches the params		
		# Then prepare and send it to the player
		@event = @value[3];
		if (@event == 'vehicle_enter'){
			assign(@verb, 'entered a');
			assign(@action, 'enter');
		}
		# Time converter
		assign(@timediffS, ceil(subtract(divide(time(), 1000), @value[1])));							
		if (@timediffS > 60){
			@timediffM = floor(divide(@timediffS, 60)); # to mins
			if (@timediffM > 60){
				@timediffH = floor(divide(@timediffM, 60)); # to hours
				if (@timediffH > 24){
					@timediffD = floor(divide(@timediffH, 24));
					@timediff = @timediffD.'d'.floor(@timediffH % 24).'h'.ceil(@timediffM % 60).'m'; #5d20h15m
				} else{
					@timediff = @timediffH.'h'.ceil(@timediffM % 60).'m'; #20h15m
				}				
			} else{
				@timediff = @timediffM.'m';
			}
		} else{
			@timediff = @timediffS.'s';
		}
		# Piggyback onto essentials's data to convert offline uuid to username
		assign(@name, get_player_from_entity_id(@value[4]));
		if (@name == null){
			try(
				assign(@essusrdata, read(import('serverpath').'/plugins/Essentials/userdata/'.@value[4].'.yml'));
				assign(@name, yml_decode(@essusrdata)[lastAccountName]);
				, #catch
				msg(colorize(@ptag.@mcol.'Encountered an error while attempting to retrieve the last recorded username of a uuid.'));
				msg(colorize(@kcol.'UUID: '.@mcol.@value[4]));
				break();
			);
		}
		msg(colorize('&c - '.@kcol.'['.@value[0].'] &3'.@name.@mcol.' '.@verb.' horse with uuid &3'.@value[5].' '.@mcol.@timediff.' ago '.@kcol.'(a:'.@event.')'));
	}
}