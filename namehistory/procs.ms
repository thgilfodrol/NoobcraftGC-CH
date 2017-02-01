# Retrieve and pretty print the name history of a player via Mojang's API
# Signature: uuid(string), flags(string array)
proc _print_name_history(@uuid, @flags){
    # configs
    @config = _get_config();
    @ptag = @config['ptag']; # prefix tag
    @mcol = @config['mcol']; # message colour
    @kcol = @config['kcol']; # keyword colour
    @dateformat = @config['dateformat']; # e.g. 2017/01/29 EDT   
    @baseurl = 'https://api.mojang.com/user/profiles/'.@uuid.'/names';

    http_request('https://api.mojang.com/user/profiles/'.@uuid.'/names', closure(@response){
	if (@response[responseCode] == 200){
	    @body = json_decode(@response[body]);
	    @bodysize = array_size(@body);			    

	    if (@bodysize > 1){
		msg(colorize(@ptag.@mcol.'Found a total of '.@kcol.(@bodysize - 1).@mcol.' name changes for '.@kcol.$player.@mcol.'.'));
		if (array_contains(@flags, '-u')){
	            msg(colorize(@ptag.@mcol.'UUID: '.@kcol.@uuid));
		}

		msg(colorize(@ptag.@mcol.'Original Username: '.@kcol.@body[0][name]));
		if (@bodysize > 2){
		    msg(colorize(@ptag.@mcol.'Previous Username(s): '));
		    for(@i = 1, @i < @bodysize - 1, @i++){
			msg(colorize(@ptag.@mcol.'-> '.@kcol.@body[@i][name].@mcol.', changed at '.@kcol.simple_date(@dateformat, @body[@i][changedToAt])));
		    }
		}

		msg(colorize(@ptag.@mcol.'Current Username: '));
		msg(colorize(@ptag.@mcol.'-> '.@kcol.@body[@bodysize - 1][name].@mcol.', changed at '.@kcol.simple_date(@dateformat, @body[@bodysize - 1][changedToAt])));
	    } else{
		msg(colorize(@ptag.@kcol.@body[0][name].@mcol.' has never changed their name.'));
		if (array_contains(@flags, '-u')){
		    msg(colorize(@ptag.@mcol.'UUID: '.@kcol.@uuid));
		}
	    }							
	} else{
	    msg(colorize(@ptag.@mcol.'Error: Mojang\'s API servers returned '.@kcol.@response[responseCode].' '.@response[responseText].@mcol.'.'));
	}					
    });
}

# Config data for this command
# Returns associative array of key : value
proc _get_config(){
    @config = associative_array();

    @config['ptag'] = '&9[&6NH&9] ';
    @config['kcol'] = '&6';
    @config['mcol'] = '&7';
    @config['dateformat'] = 'yyyy/MM/dd z'; # e.g. 2017/01/29 EDT

    return(@config);
}
