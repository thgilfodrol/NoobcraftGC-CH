# Returns list of emotes and associated data
proc _ncemotes_get_emotes(){
    @emotes = associative_array();
#    @emotes[''] = array(
#       'permnode': '', # if no permnode key exists or if perm is empty (recommended), user requires default permnode nc.emotes.standard
#       'format': '');

    # Complex emote example
    @emotes['smell'] = array(
        'format': closure(@player, @args){
            broadcast(colorize('&a'.@player.' smells.'));
        });

    @emotes['annoyed'] = array(
        'format': 'is annoyed');
    @emotes['bark'] = array(
        'format': 'barks');
    @emotes['bow'] = array(
        'format': 'bows');
    @emotes['burp'] = array(
        'format': 'burps');
    @emotes['chuckle'] = array(
        'format': 'chuckles');
    @emotes['clap'] = array(
        'format': 'claps');
    @emotes['congrat'] = array(
        'format': 'congratulates');
    @emotes['cough'] = array(
        'format': 'coughs');
    @emotes['cry'] = array(
        'format': 'cries');
    @emotes['dance'] = array(
        'format': 'dances');
    @emotes['die'] = array(
        'format': 'dies');
    @emotes['dodge'] = array(
        'format': 'dodges');
    @emotes['douse'] = array(
        'format': 'douses');
    @emotes['drink'] = array(
        'format': 'drinks');
    @emotes['eat'] = array(
        'format': 'eats');
    @emotes['facepalm'] = array(
        'format': 'facepalms');
    @emotes['fail'] = array(
        'format': 'fails');
    @emotes['fall'] = array(
        'format': 'falls');
    @emotes['fistbump'] = array(
        'format': 'fistbumps');
    @emotes['flinch'] = array(
        'format': 'flinches');
    @emotes['frolic'] = array(
        'format': 'frolics');
    @emotes['frown'] = array(
        'format': 'frowns');
    @emotes['gesture'] = array(
        'format': 'gestures vaguely');
    @emotes['giggle'] = array(
        'format': 'giggles');
    @emotes['grin'] = array(
        'format': 'grins');
    @emotes['grumble'] = array(
        'format': 'grumbles');
    @emotes['grunt'] = array(
        'format': 'grunts');
    @emotes['headdesk'] = array(
        'format': 'headdesks');
    @emotes['hug'] = array(
        'format': 'hugs');
    @emotes['laugh'] = array(
        'format': 'laughs');
    @emotes['look'] = array(
        'format': 'looks');
    @emotes['meow'] = array(
        'format': 'meows');
    @emotes['mumble'] = array(
        'format': 'mumbles');
    @emotes['ni'] = array(
        'format': 'shouts Ni');
    @emotes['nod'] = array(
        'format': 'nods');
    @emotes['oof'] = array(
        'format': 'oofs');
    @emotes['pace'] = array(
        'format': 'paces');
    @emotes['palmdeskface'] = array(
        'format': 'palmdeskfaces');
    @emotes['panic'] = array(
        'format': 'panics');
    @emotes['party'] = array(
        'format': 'parties');
    @emotes['pat'] = array(
        'format': 'pats');
    @emotes['point'] = array(
        'format': 'points');
    @emotes['ponder'] = array(
        'format': 'ponders');
    @emotes['popcorn'] = array(
        'format': 'sits back and eats popcorn');
    @emotes['puke'] = array(
        'format': 'pukes');
    @emotes['rage'] = array(
        'format': 'rages');
    @emotes['scold'] = array(
        'format': 'scolds');
    @emotes['scream'] = array(
        'format': 'screams');
    @emotes['shake'] = array(
        'format': 'shakes');
    @emotes['shrug'] = array(
        'format': 'shrugs');
    @emotes['shudder'] = array(
        'format': 'shudders');
    @emotes['sigh'] = array(
        'format': 'sighs');
    @emotes['sing'] = array(
        'format': 'sings');
    @emotes['sit'] = array(
        'format': 'sits');
    @emotes['slap'] = array(
        'format': 'slaps');
    @emotes['smirk'] = array(
        'format': 'smirks');
    @emotes['sneeze'] = array(
        'format': 'sneezes');
    @emotes['snicker'] = array(
        'format': closure(@player, @args){
            broadcast(colorize('&a').@player.' snickers'.(array_implode(@args)).'.');

	    set_timeout(1000, closure(){
	        @rand = rand(10);
		if(@rand == 1){
		    broadcast(colorize('&aAnnouncer marco polos.'));
		} else if(@rand == 2){
		    broadcast(colorize('&aAnnouncer kitkats.'));
		} else if(@rand == 3){
		    broadcast(colorize('&aAnnouncer mars.'));
		}
	    });
        });
    @emotes['stand'] = array(
        'format': 'stands');
    @emotes['stare'] = array(
        'format': 'stares');
    @emotes['talk'] = array(
        'format': 'talks');
    @emotes['tea'] = array(
        'format': 'sips their tea');
    @emotes['thank'] = array(
        'format': 'says thank you');
    @emotes['think'] = array(
        'format': 'thinks');
    @emotes['tickle'] = array(
        'format': 'tickles');
    @emotes['toast'] = array(
        'format': 'toasts');
    @emotes['violin'] = array(
        'format': 'plays the violin');
    @emotes['wave'] = array(
        'format': 'waves');
    @emotes['welcome'] = array(
        'format': 'welcomes');
    @emotes['whack'] = array(
        'format': 'whacks');
    @emotes['whale'] = array(
        'format': 'makes whale noises');
    @emotes['wink'] = array(
        'format': 'winks');
    @emotes['work'] = array(
        'format': 'works');
    @emotes['yawn'] = array(
        'format': 'yawns');
    @emotes['um'] = array(
    	'format': 'ums');
    @emotes['wubs'] = array(
    	'format': 'wubs');

    return(@emotes);
}
